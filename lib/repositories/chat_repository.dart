import 'dart:async';
import 'dart:developer' show log;

import 'package:chat_app/core/utils/failure.dart';
import 'package:chat_app/models/chat_message.dart'
    show ChatMessage, MessageStatus, MessageType;
import 'package:chat_app/models/models.dart'
    show ChatRoomModel, PaginatedResult, UserModel;
import 'package:cloud_firestore/cloud_firestore.dart'
    show
        CollectionReference,
        DocumentSnapshot,
        FieldValue,
        FirebaseFirestore,
        Query,
        Timestamp;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

class ChatRepository {
  const ChatRepository({required this.firestore, required this.auth});

  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  CollectionReference get _chatRooms => firestore.collection("chatRooms");

  CollectionReference getChatRoomMessages(String chatRoomId) {
    return _chatRooms.doc(chatRoomId).collection("messages");
  }

  Stream<Either<Failure, List<ChatRoomModel>>> getChatRooms(String userId) {
    return firestore
        .collection('chatRooms')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) {
          final chatRooms = snapshot.docs
              .map((doc) => ChatRoomModel.fromFirestore(doc))
              .toList();

          return right<Failure, List<ChatRoomModel>>(chatRooms);
        })
        .handleError((error, stackTrace) {
          return left(Failure('Failed to get chat rooms!'));
        });
  }

  Future<Either<Failure, PaginatedResult<UserModel>>> searchUser({
    required String searchText,
    DocumentSnapshot? lastDoc,
    int limit = 20,
  }) async {
    try {
      Query query = FirebaseFirestore.instance
          .collection('users')
          .where('fullName', isGreaterThanOrEqualTo: searchText)
          .where('fullName', isLessThanOrEqualTo: '$searchText\uf8ff')
          .orderBy('fullName')
          .limit(limit);

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }

      final snapshot = await query.get().timeout(const Duration(seconds: 5));

      final users = snapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .where((user) => user.uid != auth.currentUser?.uid)
          .toList();

      final result = PaginatedResult(items: users, lastDoc: lastDoc);

      return right(result);
    } catch (_) {
      return left(Failure('Failed to search user!'));
    }
  }

  Stream<Either<Failure, PaginatedResult<ChatMessage>>> getMessages(
    String chatRoomId, {
    DocumentSnapshot? lastDocument,
  }) {
    var query = getChatRoomMessages(
      chatRoomId,
    ).orderBy('timestamp', descending: true).limit(20);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    return query
        .snapshots()
        .map((snapshot) {
          final messages = snapshot.docs
              .map((doc) => ChatMessage.fromFirestore(doc))
              .toList();

          final lastDoc = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

          return right<Failure, PaginatedResult<ChatMessage>>(
            PaginatedResult(items: messages, lastDoc: lastDoc),
          );
        })
        .handleError((error, stackTrace) {
          return left(Failure('Failed to get messages'));
        });
  }

  Stream<Either<Failure, UserModel>> getUserInfo(String userId) {
    return firestore
        .collection("users")
        .doc(userId)
        .snapshots()
        .map((doc) {
          final userData = UserModel.fromFirestore(doc);
          return right<Failure, UserModel>(userData);
        })
        .handleError((error, stackTrace) {
          return left(Failure('Failed to load user info'));
        });
  }

  Future<Either<Failure, PaginatedResult<ChatMessage>>> getMoreMessages(
    String chatRoomId, {
    required DocumentSnapshot lastDocument,
  }) async {
    try {
      final query = getChatRoomMessages(chatRoomId)
          .orderBy('timestamp', descending: true)
          .startAfterDocument(lastDocument)
          .limit(20);

      log("comingg");

      final snapshot = await query.get().timeout(const Duration(seconds: 5));

      final messages = snapshot.docs
          .map((doc) => ChatMessage.fromFirestore(doc))
          .toList();

      final lastDoc = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

      return right(PaginatedResult(items: messages, lastDoc: lastDoc));
    } catch (_) {
      return left(Failure('Failed to load more messages'));
    }
  }

  Future<Either<Failure, Unit>> markMessagesAsRead(
    String chatRoomId,
    String userId,
  ) async {
    try {
      final batch = firestore.batch();

      final unreadMessages = await getChatRoomMessages(chatRoomId)
          .where("receiverId", isEqualTo: userId)
          .where('status', isEqualTo: MessageStatus.sent.toString())
          .get()
          .timeout(const Duration(seconds: 5));
      log("found ${unreadMessages.docs.length} unread messages");

      for (final doc in unreadMessages.docs) {
        batch.update(doc.reference, {
          'readBy': FieldValue.arrayUnion([userId]),
          'status': MessageStatus.read.toString(),
        });
      }

      await batch.commit();
      log("Marked messages as read for user $userId");

      return right(unit);
    } catch (e) {
      log("Error marking messages as read: $e");
      return left(Failure("Failed to mark messages as read"));
    }
  }

  Future<Either<Failure, ChatRoomModel>> getOrCreateChatRoom(
    String currentUserId,
    String otherUserId,
  ) async {
    try {
      if (currentUserId == otherUserId) {
        return left(Failure("Cannot create a chat room with yourself"));
      }

      final users = [currentUserId, otherUserId]..sort();
      final roomId = users.join("_");

      final roomDoc = await _chatRooms
          .doc(roomId)
          .get()
          .timeout(const Duration(seconds: 5));

      if (roomDoc.exists) {
        return right(ChatRoomModel.fromFirestore(roomDoc));
      }

      final currentUserSnapshot = await firestore
          .collection("users")
          .doc(currentUserId)
          .get();
      final otherUserSnapshot = await firestore
          .collection("users")
          .doc(otherUserId)
          .get();

      if (!currentUserSnapshot.exists || !otherUserSnapshot.exists) {
        return left(Failure("One or both users not found"));
      }

      final currentUserData = currentUserSnapshot.data()!;
      final otherUserData = otherUserSnapshot.data()!;

      final participantsName = {
        currentUserId: currentUserData['fullName']?.toString() ?? "",
        otherUserId: otherUserData['fullName']?.toString() ?? "",
      };

      final participantsAvatar = {
        currentUserId: currentUserData['avatarUrl']?.toString() ?? "",
        otherUserId: otherUserData['avatarUrl']?.toString() ?? "",
      };

      final newRoom = ChatRoomModel(
        id: roomId,
        participants: users,
        participantsName: participantsName,
        lastReadTime: {
          currentUserId: Timestamp.now(),
          otherUserId: Timestamp.now(),
        },
        participantsAvatar: participantsAvatar,
      );

      await _chatRooms
          .doc(roomId)
          .set(newRoom.toMap())
          .timeout(const Duration(seconds: 5));

      return right(newRoom);
    } catch (e) {
      return left(Failure("Failed to get or create chat room: $e"));
    }
  }

  Future<void> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String receiverId,
    required String content,
    MessageType type = MessageType.text,
  }) async {
    //batch
    final batch = firestore.batch();

    //get message sub collection

    final messageRef = getChatRoomMessages(chatRoomId);
    final messageDoc = messageRef.doc();

    //chatmessage

    final message = ChatMessage(
      id: messageDoc.id,
      chatRoomId: chatRoomId,
      senderId: senderId,
      receiverId: receiverId,
      content: content,
      type: type,
      timestamp: Timestamp.now(),
      readByUserIds: [senderId],
    );

    //add message to sub collection
    batch.set(messageDoc, message.toMap());

    //update chatroom

    batch.update(_chatRooms.doc(chatRoomId), {
      "lastMessage": content,
      "lastMessageSenderId": senderId,
      "lastMessageTime": message.timestamp,
    });
    await batch.commit();
  }

  Future<Either<Failure, bool>> findExistingChatRoom(
    List<String> docIds,
  ) async {
    try {
      final collection = FirebaseFirestore.instance.collection('chatRooms');

      for (final id in docIds) {
        final docSnapshot = await collection.doc(id).get();
        if (docSnapshot.exists) {
          return right(true);
        }
      }

      return right(false);
    } catch (e) {
      return left(Failure('Failed to find chat room existence'));
    }
  }

  Stream<bool> checkUnread(String chatRoomId, String userId) {
    final snapshot = getChatRoomMessages(chatRoomId)
        .where("receiverId", isEqualTo: userId)
        .where('status', isEqualTo: MessageStatus.sent.toString())
        .snapshots()
        .map((snapshot) => snapshot.docs.length);

    return snapshot.map((count) => count > 0);
  }

  Stream<Either<Failure, bool>> isUserBlocked(
    String currentUserId,
    String otherUserId,
  ) {
    final controller = StreamController<Either<Failure, bool>>();

    try {
      firestore
          .collection("users")
          .doc(currentUserId)
          .snapshots()
          .timeout(const Duration(seconds: 5))
          .listen(
            (doc) {
              try {
                final userData = UserModel.fromFirestore(doc);
                final isBlocked = userData.blockedUsers.contains(otherUserId);
                controller.add(right(isBlocked));
              } catch (e) {
                controller.add(left(Failure('Failed to parse user data')));
              }
            },
            onError: (error) {
              controller.add(
                left(Failure('Failed to check if user is blocked')),
              );
            },
          );
    } catch (e) {
      controller.add(left(Failure('Unexpected error checking block status')));
    }

    return controller.stream;
  }

  // Stream<bool> amIBlocked(String currentUserId, String otherUserId) {
  //   return firestore.collection("users").doc(otherUserId).snapshots().map((
  //     doc,
  //   ) {
  //     final userData = UserModel.fromFirestore(doc);
  //     return userData.blockedUsers.contains(currentUserId);
  //   });
  // }

  Stream<Either<Failure, bool>> amIBlocked(
    String currentUserId,
    String otherUserId,
  ) {
    try {
      return firestore
          .collection("users")
          .doc(otherUserId)
          .snapshots()
          .timeout(const Duration(seconds: 5))
          .map((doc) {
            final userData = UserModel.fromFirestore(doc);
            final isBlocked = userData.blockedUsers.contains(currentUserId);
            return right<Failure, bool>(isBlocked);
          })
          .handleError((error) {
            return left<Failure, bool>(
              Failure('Failed to check if user is blocked'),
            );
          });
    } catch (e) {
      return Stream.value(
        left(Failure('Unexpected error checking block status')),
      );
    }
  }

  Future<Either<Failure, Unit>> blockUser(
    String currentUserId,
    String blockedUserId,
  ) async {
    try {
      final userRef = firestore.collection("users").doc(currentUserId);
      await userRef
          .update({
            'blockedUsers': FieldValue.arrayUnion([blockedUserId]),
          })
          .timeout(const Duration(seconds: 5));
      return right(unit);
    } catch (e) {
      return left(Failure('Failed to block user'));
    }
  }

  Future<Either<Failure, Unit>> unBlockUser(
    String currentUserId,
    String blockedUserId,
  ) async {
    try {
      final userRef = firestore.collection("users").doc(currentUserId);
      await userRef
          .update({
            'blockedUsers': FieldValue.arrayRemove([blockedUserId]),
          })
          .timeout(const Duration(seconds: 5));
      return right(unit);
    } catch (e) {
      return left(Failure('Failed to unblock user'));
    }
  }
}

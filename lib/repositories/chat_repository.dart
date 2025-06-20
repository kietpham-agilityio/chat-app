import 'dart:async';
import 'dart:developer' show log;
import 'dart:io';

import 'package:chat_app/core/resources/l10n_generated/l10n.dart';
import 'package:chat_app/core/utils/failure.dart';
import 'package:chat_app/models/chat_message_model.dart'
    show ChatMessageModel, MessageStatus, MessageType;
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
    final current = Platform.environment.containsKey('FLUTTER_TEST')
        ? S()
        : S.current;
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
          return left(Failure(current.errorFailedToGetChatRooms));
        });
  }

  Future<Either<Failure, PaginatedResult<UserModel>>> searchUser({
    required String searchText,
    DocumentSnapshot? lastDoc,
    int limit = 20,
  }) async {
    final current = Platform.environment.containsKey('FLUTTER_TEST')
        ? S()
        : S.current;
    try {
      Query query = firestore
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
    } catch (e) {
      return left(Failure(current.errorFailedToSearchUsers));
    }
  }

  Stream<Either<Failure, PaginatedResult<ChatMessageModel>>> getMessages(
    String chatRoomId, {
    DocumentSnapshot? lastDocument,
  }) {
    final current = Platform.environment.containsKey('FLUTTER_TEST')
        ? S()
        : S.current;
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
              .map((doc) => ChatMessageModel.fromFirestore(doc))
              .toList();

          final lastDoc = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

          return right<Failure, PaginatedResult<ChatMessageModel>>(
            PaginatedResult(items: messages, lastDoc: lastDoc),
          );
        })
        .handleError((error, stackTrace) {
          return left(Failure(current.errorFailedToGetMessages));
        });
  }

  Stream<Either<Failure, UserModel>> getUserInfo(String userId) {
    final current = Platform.environment.containsKey('FLUTTER_TEST')
        ? S()
        : S.current;
    return firestore
        .collection("users")
        .doc(userId)
        .snapshots()
        .map((doc) {
          final userData = UserModel.fromFirestore(doc);
          return right<Failure, UserModel>(userData);
        })
        .handleError((error, stackTrace) {
          return left(Failure(current.errorFailedToLoadUserInfo));
        });
  }

  Future<Either<Failure, PaginatedResult<ChatMessageModel>>> getMoreMessages(
    String chatRoomId, {
    required DocumentSnapshot lastDocument,
  }) async {
    final current = Platform.environment.containsKey('FLUTTER_TEST')
        ? S()
        : S.current;
    try {
      final query = getChatRoomMessages(chatRoomId)
          .orderBy('timestamp', descending: true)
          .startAfterDocument(lastDocument)
          .limit(20);

      log("comingg");

      final snapshot = await query.get().timeout(const Duration(seconds: 5));

      final messages = snapshot.docs
          .map((doc) => ChatMessageModel.fromFirestore(doc))
          .toList();

      final lastDoc = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

      return right(PaginatedResult(items: messages, lastDoc: lastDoc));
    } catch (_) {
      return left(Failure(current.errorFailedToLoadMoreMessages));
    }
  }

  Future<Either<Failure, Unit>> markMessagesAsRead(
    String chatRoomId,
    String userId,
  ) async {
    final current = Platform.environment.containsKey('FLUTTER_TEST')
        ? S()
        : S.current;
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
      return left(Failure(current.errorFailedToMarkMessagesAsRead));
    }
  }

  Future<Either<Failure, ChatRoomModel>> getOrCreateChatRoom(
    String currentUserId,
    String otherUserId,
  ) async {
    final current = Platform.environment.containsKey('FLUTTER_TEST')
        ? S()
        : S.current;
    try {
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
        return left(Failure(current.errorOneOrBothUsersNotFound));
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
      return left(Failure(current.errorFailedToGetOrCreateChatRoom));
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

    final message = ChatMessageModel(
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
    final current = Platform.environment.containsKey('FLUTTER_TEST')
        ? S()
        : S.current;
    try {
      final collection = firestore.collection('chatRooms');

      for (final id in docIds) {
        final docSnapshot = await collection.doc(id).get();
        if (docSnapshot.exists) {
          return right(true);
        }
      }

      return right(false);
    } catch (e) {
      return left(Failure(current.errorFailedToFindChatRoomExistence));
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
    final current = Platform.environment.containsKey('FLUTTER_TEST')
        ? S()
        : S.current;
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
                controller.add(
                  left(Failure(current.errorFailedToParseUserData)),
                );
              }
            },
            onError: (error) {
              controller.add(
                left(Failure(current.errorFailedToCheckIfUserIsBlocked)),
              );
            },
          );
    } catch (e) {
      controller.add(
        left(Failure(current.errorUnexpectedErrorCheckingBlockStatus)),
      );
    }

    return controller.stream;
  }

  Stream<Either<Failure, bool>> amIBlocked(
    String currentUserId,
    String otherUserId,
  ) {
    final current = Platform.environment.containsKey('FLUTTER_TEST')
        ? S()
        : S.current;
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
              Failure(current.errorFailedToCheckIfUserIsBlocked),
            );
          });
    } catch (e) {
      return Stream.value(
        left(Failure(current.errorUnexpectedErrorCheckingBlockStatus)),
      );
    }
  }

  Future<Either<Failure, Unit>> blockUser(
    String currentUserId,
    String blockedUserId,
  ) async {
    final current = Platform.environment.containsKey('FLUTTER_TEST')
        ? S()
        : S.current;
    try {
      final userRef = firestore.collection("users").doc(currentUserId);
      await userRef
          .update({
            'blockedUsers': FieldValue.arrayUnion([blockedUserId]),
          })
          .timeout(const Duration(seconds: 5));
      return right(unit);
    } catch (e) {
      return left(Failure(current.errorFailedToBlockUser));
    }
  }

  Future<Either<Failure, Unit>> unBlockUser(
    String currentUserId,
    String blockedUserId,
  ) async {
    final current = Platform.environment.containsKey('FLUTTER_TEST')
        ? S()
        : S.current;
    try {
      final userRef = firestore.collection("users").doc(currentUserId);
      await userRef
          .update({
            'blockedUsers': FieldValue.arrayRemove([blockedUserId]),
          })
          .timeout(const Duration(seconds: 5));
      return right(unit);
    } catch (e) {
      return left(Failure(current.errorFailedToUnblockUser));
    }
  }
}

import 'dart:developer' show log;

import 'package:chat_app/models/chat_message.dart'
    show ChatMessage, MessageStatus, MessageType;
import 'package:chat_app/models/models.dart'
    show ChatRoomModel, PaginatedResult, UserModel;
import 'package:chat_app/repositories/repositories.dart'
    show AppException, BaseRepository;
import 'package:cloud_firestore/cloud_firestore.dart'
    show
        CollectionReference,
        DocumentSnapshot,
        FieldValue,
        FirebaseFirestore,
        Query,
        Timestamp;

class ChatRepository extends BaseRepository {
  CollectionReference get _chatRooms => firestore.collection("chatRooms");

  CollectionReference getChatRoomMessages(String chatRoomId) {
    return _chatRooms.doc(chatRoomId).collection("messages");
  }

  Stream<List<ChatRoomModel>> getChatRooms(String userId) {
    return _chatRooms
        .where("participants", arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => ChatRoomModel.fromFirestore(doc))
                  .toList(),
        );
  }

  Future<PaginatedResult<UserModel>> searchUser({
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

      final snapshot = await query.get();

      final users =
          snapshot.docs
              .map((doc) => UserModel.fromFirestore(doc))
              .where((user) => user.uid != currentUser?.uid)
              .toList();

      final result = PaginatedResult(items: users, lastDoc: lastDoc);

      return result;
    } catch (e) {
      throw const AppException("Failed to search user");
    }
  }

  // Stream<List<ChatMessage>> getMessages(
  //   String chatRoomId, {
  //   DocumentSnapshot? lastDocument,
  // }) {
  //   var query = getChatRoomMessages(
  //     chatRoomId,
  //   ).orderBy('timestamp', descending: true).limit(20);

  //   if (lastDocument != null) {
  //     query = query.startAfterDocument(lastDocument);
  //   }
  //   return query.snapshots().map(
  //     (snapshot) =>
  //         snapshot.docs.map((doc) => ChatMessage.fromFirestore(doc)).toList(),
  //   );
  // }

  Stream<PaginatedResult<ChatMessage>> getMessages(
    String chatRoomId, {
    DocumentSnapshot? lastDocument,
  }) {
    var query = getChatRoomMessages(
      chatRoomId,
    ).orderBy('timestamp', descending: true).limit(20);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    return query.snapshots().map((snapshot) {
      final messages =
          snapshot.docs.map((doc) => ChatMessage.fromFirestore(doc)).toList();

      final lastDoc = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

      return PaginatedResult(items: messages, lastDoc: lastDoc);
    });
  }

  Future<PaginatedResult<ChatMessage>> getMoreMessages(
    String chatRoomId, {
    required DocumentSnapshot lastDocument,
  }) async {
    final query = getChatRoomMessages(chatRoomId)
        .orderBy('timestamp', descending: true)
        .startAfterDocument(lastDocument)
        .limit(20);
    log("comingg");
    final snapshot = await query.get();
    final messages =
        snapshot.docs.map((doc) => ChatMessage.fromFirestore(doc)).toList();
    final lastDoc = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
    return PaginatedResult(items: messages, lastDoc: lastDoc);
  }

  Future<void> markMessagesAsRead(String chatRoomId, String userId) async {
    try {
      final batch = firestore.batch();

      //get all unread messages where user is receviver

      final unreadMessages =
          await getChatRoomMessages(chatRoomId)
              .where("receiverId", isEqualTo: userId)
              .where('status', isEqualTo: MessageStatus.sent.toString())
              .get();
      log("found ${unreadMessages.docs.length} unread messages");

      for (final doc in unreadMessages.docs) {
        batch.update(doc.reference, {
          'readBy': FieldValue.arrayUnion([userId]),
          'status': MessageStatus.read.toString(),
        });

        await batch.commit();

        log("Marked messaegs as read for user $userId");
      }
    } catch (e) {
      log("Error marking messages as read: $e");
    }
  }

  Future<ChatRoomModel> getOrCreateChatRoom(
    String currentUserId,
    String otherUserId,
  ) async {
    // Prevent creating a chat room with yourself
    if (currentUserId == otherUserId) {
      throw Exception("Cannot create a chat room with yourself");
    }

    final users = [currentUserId, otherUserId]..sort();
    final roomId = users.join("_");

    final roomDoc = await _chatRooms.doc(roomId).get();

    if (roomDoc.exists) {
      return ChatRoomModel.fromFirestore(roomDoc);
    }

    final currentUserData =
        (await firestore.collection("users").doc(currentUserId).get()).data()
            as Map<String, dynamic>;
    final otherUserData =
        (await firestore.collection("users").doc(otherUserId).get()).data()
            as Map<String, dynamic>;
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

    await _chatRooms.doc(roomId).set(newRoom.toMap());
    return newRoom;
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
      readBy: [senderId],
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

  Future<bool> checkChatRoomExists(String docId) async {
    final docRef = FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(docId);

    final docSnapshot = await docRef.get();
    return docSnapshot.exists;
  }

  Future<bool> findExistingChatRoom(List<String> docIds) async {
    final collection = FirebaseFirestore.instance.collection('chatRooms');

    for (final id in docIds) {
      final docSnapshot = await collection.doc(id).get();
      if (docSnapshot.exists) {
        return true;
      }
    }

    return false;
  }

  Stream<bool> getUnreadCount(String chatRoomId, String userId) {
    final snapshot = getChatRoomMessages(chatRoomId)
        .where("receiverId", isEqualTo: userId)
        .where('status', isEqualTo: MessageStatus.sent.toString())
        .snapshots()
        .map((snapshot) => snapshot.docs.length);

    return snapshot.map((count) => count > 0);
  }

  Stream<bool> isUserBlocked(String currentUserId, String otherUserId) {
    return firestore.collection("users").doc(currentUserId).snapshots().map((
      doc,
    ) {
      final userData = UserModel.fromFirestore(doc);
      return userData.blockedUsers.contains(otherUserId);
    });
  }

  Stream<bool> amIBlocked(String currentUserId, String otherUserId) {
    return firestore.collection("users").doc(otherUserId).snapshots().map((
      doc,
    ) {
      final userData = UserModel.fromFirestore(doc);
      return userData.blockedUsers.contains(currentUserId);
    });
  }

  Future<void> blockUser(String currentUserId, String blockedUserId) async {
    final userRef = firestore.collection("users").doc(currentUserId);
    await userRef.update({
      'blockedUsers': FieldValue.arrayUnion([blockedUserId]),
      // 'blockedUsers': List<String>.from(data["blockedUsers"] ?? []),
    });
  }

  Future<void> unBlockUser(String currentUserId, String blockedUserId) async {
    final userRef = firestore.collection("users").doc(currentUserId);
    await userRef.update({
      'blockedUsers': FieldValue.arrayRemove([blockedUserId]),
    });
  }
}

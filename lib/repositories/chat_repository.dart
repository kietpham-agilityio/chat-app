import 'package:chat_app/models/models.dart'
    show ChatRoomModel, PaginatedResult, UserModel;
import 'package:chat_app/repositories/repositories.dart'
    show AppException, BaseRepository;
import 'package:cloud_firestore/cloud_firestore.dart'
    show CollectionReference, DocumentSnapshot, FirebaseFirestore, Query;

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
}

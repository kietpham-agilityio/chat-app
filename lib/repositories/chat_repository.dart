import 'package:chat_app/models/models.dart' show ChatRoomModel;
import 'package:chat_app/repositories/repositories.dart' show BaseRepository;
import 'package:cloud_firestore/cloud_firestore.dart' show CollectionReference;

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
}

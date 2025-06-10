import 'package:awesome_notifications/awesome_notifications.dart'
    show ReceivedAction;
import 'package:chat_app/core/notifications/notifications_service.dart'
    show NotificationHandler, NotificationsService;
import 'package:chat_app/models/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class NotificationController {
  static Future<void> onActionReceivedMethod(ReceivedAction action) async {
    await Firebase.initializeApp();

    if (action.buttonKeyPressed.isNotEmpty &&
        action.buttonKeyPressed == 'REPLY') {
      final replyText = action.buttonKeyInput;
      final receiverId = action.payload?['accountId'];
      final senderId = FirebaseAuth.instance.currentUser?.uid;

      if (replyText.isNotEmpty && receiverId != null && senderId != null) {
        final users = [senderId, receiverId]..sort();
        final chatRoomId = users.join("_");

        final batch = FirebaseFirestore.instance.batch();

        final chatroom = FirebaseFirestore.instance.collection("chatRooms");

        final messageRef = chatroom.doc(chatRoomId).collection('messages');

        final messageDoc = messageRef.doc();

        final message = ChatMessage(
          id: messageDoc.id,
          chatRoomId: chatRoomId,
          senderId: senderId,
          receiverId: receiverId,
          content: replyText,
          timestamp: Timestamp.now(),
          readBy: [senderId],
        );

        //add message to sub collection
        batch.set(messageDoc, message.toMap());

        //update chatroom

        batch.update(chatroom.doc(chatRoomId), {
          "lastMessage": replyText,
          "lastMessageSenderId": senderId,
          "lastMessageTime": message.timestamp,
        });
        await batch.commit();
      }
    } else {
      final data = action.payload ?? {};
      NotificationHandler.handleTapNavigate(data, NotificationsService.entity);
    }
  }
}

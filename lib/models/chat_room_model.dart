import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ChatRoomModel extends Equatable {
  ChatRoomModel({
    required this.id,
    required this.participants,
    this.lastMessage,
    this.lastMessageSenderId,
    this.lastMessageTime,
    Map<String, Timestamp>? lastReadTime,
    Map<String, String>? participantsName,
    Map<String, String>? participantsAvatar,
    this.isTyping = false,
    this.typingUserId,
    this.isCallActive = false,
  }) : lastReadTime = lastReadTime ?? {},
       participantsName = participantsName ?? {},
       participantsAvatar = participantsAvatar ?? {};

  final String id;
  final List<String> participants;
  final String? lastMessage;
  final String? lastMessageSenderId;
  final Timestamp? lastMessageTime;
  final Map<String, Timestamp>? lastReadTime;
  final Map<String, String>? participantsName;
  final Map<String, String>? participantsAvatar;
  final bool isTyping;
  final String? typingUserId;
  final bool isCallActive;

  factory ChatRoomModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatRoomModel(
      id: doc.id,
      participants: List<String>.from(data['participants']),
      lastMessage: data['lastMessage'],
      lastMessageSenderId: data['lastMessageSenderId'],
      lastMessageTime: data['lastMessageTime'],
      lastReadTime: Map<String, Timestamp>.from(data['lastReadTime'] ?? {}),
      participantsName: Map<String, String>.from(
        data['participantsName'] ?? {},
      ),
      participantsAvatar: Map<String, String>.from(
        data['participantsAvatar'] ?? {},
      ),
      isTyping: data['isTyping'] ?? false,
      typingUserId: data['typingUserId'],
      isCallActive: data['isCallActive'] ?? false,
    );
  }

  ChatRoomModel copyWith({
    List<String>? participants,
    String? lastMessage,
    String? lastMessageSenderId,
    Timestamp? lastMessageTime,
    Map<String, Timestamp>? lastReadTime,
    Map<String, String>? participantsName,
    Map<String, String>? participantsAvatar,
    bool? isTyping,
    String? typingUserId,
    bool? isCallActive,
  }) {
    return ChatRoomModel(
      id: id,
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      lastReadTime: lastReadTime ?? this.lastReadTime,
      participantsName: participantsName ?? this.participantsName,
      participantsAvatar: participantsAvatar ?? this.participantsAvatar,
      isTyping: isTyping ?? this.isTyping,
      typingUserId: typingUserId ?? this.typingUserId,
      isCallActive: isCallActive ?? this.isCallActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageSenderId': lastMessageSenderId,
      'lastMessageTime': lastMessageTime,
      'lastReadTime': lastReadTime,
      'isTyping': isTyping,
      'participantsName': participantsName,
      'participantsAvatar': participantsAvatar,
      'typingUserId': typingUserId,
      'isCallActive': isCallActive,
    };
  }

  @override
  List<Object?> get props => [
    id,
    participants,
    lastMessage,
    lastMessageSenderId,
    lastMessageTime,
    lastReadTime,
    participantsName,
    participantsAvatar,
    isTyping,
    typingUserId,
    isCallActive,
  ];
}

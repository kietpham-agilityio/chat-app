import 'package:equatable/equatable.dart';

class Conversation extends Equatable {
  const Conversation({
    required this.currentUserId,
    required this.partnerId,
    required this.partnerName,
    required this.partnerAvatar,
    this.lastMessageAt,
    this.lastSenderId,
    this.lastMessageContent,
  });

  final String currentUserId;
  final String partnerId;
  final String partnerName;
  final String partnerAvatar;
  final DateTime? lastMessageAt;
  final String? lastSenderId;
  final String? lastMessageContent;

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      currentUserId: json['current_user_id'] as String,
      partnerId: json['partner_id'] as String,
      partnerName: json['partner_name'] as String,
      partnerAvatar: json['partner_avatar'] as String,
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'] as String)
          : null,
      lastSenderId: json['last_sender_id'] as String?,
      lastMessageContent: json['last_message_content'] as String?,
    );
  }

  bool senderByMe() => currentUserId == lastSenderId;

  @override
  List<Object?> get props => [
    currentUserId,
    partnerId,
    partnerName,
    partnerAvatar,
    lastMessageAt,
    lastSenderId,
    lastMessageContent,
  ];
}

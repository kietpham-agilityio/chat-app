part of 'chat_cubit.dart';

enum ChatStatus { inital, loading, loaded, error }

class ChatState extends Equatable {
  final ChatStatus status;

  final List<ChatMessage> messages;
  final bool isReceiverTyping;
  final bool isReceiverOnline;
  final bool hasMoreMessages;
  final bool isLoadingMore;
  final bool isUserBlocked;
  final bool amIBlocked;
  final Timestamp? receiverLastSeen;
  final String? error;
  final String? receiverId;
  final String? chatRoomId;
  final DocumentSnapshot? lastDoc;
  final String? message;
  final String? receiverAvatarUrl;
  final String? receiverFullName;

  const ChatState({
    this.status = ChatStatus.inital,
    this.messages = const [],
    this.isReceiverTyping = false,
    this.isReceiverOnline = false,
    this.hasMoreMessages = true,
    this.isLoadingMore = false,
    this.isUserBlocked = false,
    this.amIBlocked = false,
    this.receiverLastSeen,
    this.error,
    this.receiverId,
    this.chatRoomId,
    this.lastDoc,
    this.message,
    this.receiverAvatarUrl,
    this.receiverFullName,
  });

  ChatState copyWith({
    ChatStatus? status,
    String? error,
    String? receiverId,
    String? chatRoomId,
    List<ChatMessage>? messages,
    bool? isReceiverTyping,
    bool? isReceiverOnline,
    Timestamp? receiverLastSeen,
    bool? hasMoreMessages,
    bool? isLoadingMore,
    bool? isUserBlocked,
    bool? amIBlocked,
    DocumentSnapshot? lastDoc,
    String? message,
    String? receiverAvatarUrl,
    String? receiverFullName,
  }) {
    return ChatState(
      status: status ?? this.status,
      error: error ?? this.error,
      receiverId: receiverId ?? this.receiverId,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      messages: messages ?? this.messages,
      isReceiverTyping: isReceiverTyping ?? this.isReceiverTyping,
      isReceiverOnline: isReceiverOnline ?? this.isReceiverOnline,
      receiverLastSeen: receiverLastSeen ?? this.receiverLastSeen,
      hasMoreMessages: hasMoreMessages ?? this.hasMoreMessages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isUserBlocked: isUserBlocked ?? this.isUserBlocked,
      amIBlocked: amIBlocked ?? this.amIBlocked,
      lastDoc: lastDoc ?? this.lastDoc,
      message: message ?? this.message,
      receiverAvatarUrl: receiverAvatarUrl ?? this.receiverAvatarUrl,
      receiverFullName: receiverFullName ?? this.receiverFullName,
    );
  }

  @override
  List<Object?> get props {
    return [
      status,
      error,
      receiverId,
      chatRoomId,
      messages,
      isReceiverTyping,
      isReceiverOnline,
      receiverLastSeen,
      hasMoreMessages,
      isLoadingMore,
      isUserBlocked,
      amIBlocked,
      lastDoc,
      message,
      receiverAvatarUrl,
      receiverFullName,
    ];
  }
}

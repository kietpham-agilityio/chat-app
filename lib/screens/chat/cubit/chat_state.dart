part of 'chat_cubit.dart';

enum ChatStatus { inital, loading, loaded, error }

class ChatState extends Equatable {
  final ChatStatus status;

  final List<ChatMessageModel> messages;
  final bool isReceiverTyping;
  final bool isComposing;
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
  final String? myAvatarUrl;

  const ChatState({
    this.status = ChatStatus.inital,
    this.messages = const [],
    this.isReceiverTyping = false,
    this.isComposing = false,
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
    this.myAvatarUrl,
  });

  ChatState copyWith({
    ChatStatus? status,
    String? error,
    String? receiverId,
    String? chatRoomId,
    List<ChatMessageModel>? messages,
    bool? isReceiverTyping,
    bool? isComposing,
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
    String? myAvatarUrl,
  }) {
    return ChatState(
      status: status ?? this.status,
      error: error ?? this.error,
      receiverId: receiverId ?? this.receiverId,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      messages: messages ?? this.messages,
      isReceiverTyping: isReceiverTyping ?? this.isReceiverTyping,
      isComposing: isComposing ?? this.isComposing,
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
      myAvatarUrl: myAvatarUrl ?? this.myAvatarUrl,
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
      isComposing,
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
      myAvatarUrl,
    ];
  }
}

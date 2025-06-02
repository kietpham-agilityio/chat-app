import 'dart:async' show StreamSubscription;
import 'dart:developer' show log;

import 'package:chat_app/models/chat_message.dart' show ChatMessage;
import 'package:chat_app/repositories/repositories.dart' show ChatRepository;
import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({
    required ChatRepository chatRepository,
    required this.currentUserId,
  }) : _chatRepository = chatRepository,
       super(const ChatState());

  final ChatRepository _chatRepository;
  final String currentUserId;
  bool _isInChat = false;
  StreamSubscription? _messageSubscription;

  void messageChanged(String message) => emit(state.copyWith(message: message));

  Future<bool> checkExistingChatRoom(String receiverId) async {
    try {
      final docIds = [
        '${currentUserId}_$receiverId',
        '${receiverId}_$currentUserId',
      ];
      return _chatRepository.findExistingChatRoom(docIds);
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<void> sendMessage({
    required String content,
    required String receiverId,
  }) async {
    if (state.chatRoomId == null) return;

    try {
      final isExistingChatRoom = await checkExistingChatRoom(receiverId);
      if (!isExistingChatRoom) {
        _isInChat = true;
        emit(state.copyWith(status: ChatStatus.loading));

        final chatRoom = await _chatRepository.getOrCreateChatRoom(
          currentUserId,
          receiverId,
        );
        emit(
          state.copyWith(
            chatRoomId: chatRoom.id,
            receiverId: receiverId,
            status: ChatStatus.loaded,
          ),
        );

        //subscribe to all updates
        _subscribeToMessages(chatRoom.id);
      }
      await _chatRepository.sendMessage(
        chatRoomId: state.chatRoomId!,
        senderId: currentUserId,
        receiverId: receiverId,
        content: content,
      );
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(error: "Failed to send message"));
    }
  }

  Future<void> enterChat(String receiverId) async {
    try {
      final a = await checkExistingChatRoom(receiverId);
      if (a) {
        _isInChat = true;
        emit(state.copyWith(status: ChatStatus.loading));

        final chatRoom = await _chatRepository.getOrCreateChatRoom(
          currentUserId,
          receiverId,
        );
        emit(
          state.copyWith(
            chatRoomId: chatRoom.id,
            receiverId: receiverId,
            status: ChatStatus.loaded,
          ),
        );

        //subscribe to all updates
        _subscribeToMessages(chatRoom.id);
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: ChatStatus.error,
          error: "Failed to create chat room $e",
        ),
      );
    }
  }

  void _subscribeToMessages(String chatRoomId) {
    _messageSubscription?.cancel();
    _messageSubscription = _chatRepository
        .getMessages(chatRoomId)
        .listen(
          (messages) {
            if (_isInChat) {
              _markMessagesAsRead(chatRoomId);
            }
            emit(state.copyWith(messages: messages));
          },
          onError: (error) {
            emit(
              state.copyWith(
                error: "Failed to load messages",
                status: ChatStatus.error,
              ),
            );
          },
        );
  }

  Future<void> _markMessagesAsRead(String chatRoomId) async {
    try {
      await _chatRepository.markMessagesAsRead(chatRoomId, currentUserId);
    } catch (e) {
      log("error marking messages as read $e");
    }
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _isInChat = false;
    return super.close();
  }
}

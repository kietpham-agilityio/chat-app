import 'dart:async' show StreamSubscription, Timer;
import 'dart:developer' show log;
import 'dart:io';

import 'package:chat_app/core/local_database/user_box.dart';
import 'package:chat_app/core/resources/l10n_generated/l10n.dart';
import 'package:chat_app/models/chat_message_model.dart' show ChatMessageModel;
import 'package:chat_app/repositories/repositories.dart' show ChatRepository;
import 'package:cloud_firestore/cloud_firestore.dart'
    show DocumentSnapshot, Timestamp;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({
    required ChatRepository chatRepository,
    required this.currentUserId,
    required this.userBox,
  }) : _chatRepository = chatRepository,
       super(const ChatState());

  final ChatRepository _chatRepository;
  final String currentUserId;
  final UserBox userBox;

  bool _isInChat = false;
  Timer? typingTimer;

  StreamSubscription? _messageSubscription;
  StreamSubscription? _blockStatusSubscription;
  StreamSubscription? _amIBlockStatusSubscription;
  StreamSubscription? _userInfoSubscription;
  StreamSubscription? _typingSubscription;

  void messageChanged(String message) {
    final isComposing = message.isNotEmpty;
    if (isComposing && state.isComposing != isComposing) {
      startTyping();
    } else if (!isComposing) {
      typingTimer?.cancel();
      _updateTypingStatus(false);
    }

    emit(state.copyWith(message: message, isComposing: isComposing));
  }

  Future<void> getMyAvatarUrl() async {
    final userDB = await userBox.getUser();
    emit(state.copyWith(myAvatarUrl: userDB?.avatarUrl));
  }

  Future<bool> checkExistingChatRoom(String receiverId) async {
    final docIds = [
      '${currentUserId}_$receiverId',
      '${receiverId}_$currentUserId',
    ];

    final result = await _chatRepository.findExistingChatRoom(docIds);

    return result.fold((failure) {
      log('Error checking existing chat room: ${failure.message}');
      return false;
    }, (exists) => exists);
  }

  Future<void> sendMessage({
    required String content,
    required String receiverId,
  }) async {
    try {
      final isExistingChatRoom = await checkExistingChatRoom(receiverId);
      if (!isExistingChatRoom) {
        _isInChat = true;
        emit(state.copyWith(status: ChatStatus.loading));

        final result = await _chatRepository.getOrCreateChatRoom(
          currentUserId,
          receiverId,
        );

        result.fold(
          (failure) {
            emit(
              state.copyWith(error: failure.message, status: ChatStatus.error),
            );
            return;
          },
          (chatRoom) {
            _subscribeToMessages(chatRoom.id);
            _subscribeToBlockStatus(receiverId);
            _subscribeToUserInfo(receiverId);
            _subscribeToTypingStatus(
              chatRoomId: chatRoom.id,
              receiverId: receiverId,
            );

            emit(
              state.copyWith(
                chatRoomId: chatRoom.id,
                receiverId: receiverId,
                status: ChatStatus.loaded,
              ),
            );
          },
        );
      }

      await _chatRepository.sendMessage(
        chatRoomId: state.chatRoomId!,
        senderId: currentUserId,
        receiverId: receiverId,
        content: content,
      );
    } catch (e) {
      log("Failed to send message: $e");
      emit(state.copyWith(error: S.current.errorFailedToSendMessage));
    }
  }

  Future<void> enterChat(String receiverId) async {
    final current = Platform.environment.containsKey('FLUTTER_TEST')
        ? S()
        : S.current;
    try {
      final isExisting = await checkExistingChatRoom(receiverId);

      if (isExisting) {
        _isInChat = true;
        emit(state.copyWith(status: ChatStatus.loading));

        final result = await _chatRepository.getOrCreateChatRoom(
          currentUserId,
          receiverId,
        );

        result.fold(
          (failure) {
            emit(
              state.copyWith(error: failure.message, status: ChatStatus.error),
            );
            return;
          },
          (chatRoom) {
            //subscribe to all updates
            _subscribeToMessages(chatRoom.id);
            _subscribeToBlockStatus(receiverId);
            _subscribeToUserInfo(receiverId);
            _subscribeToTypingStatus(
              chatRoomId: chatRoom.id,
              receiverId: receiverId,
            );

            emit(
              state.copyWith(
                chatRoomId: chatRoom.id,
                receiverId: receiverId,
                status: ChatStatus.loaded,
              ),
            );
          },
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: ChatStatus.error,
          error: current.errorFailedToCreateChatRoom,
        ),
      );
    }
  }

  void _subscribeToMessages(String chatRoomId) {
    _messageSubscription?.cancel();
    _messageSubscription = _chatRepository.getMessages(chatRoomId).listen((
      either,
    ) {
      either.fold(
        (failure) {
          emit(
            state.copyWith(error: failure.message, status: ChatStatus.error),
          );
        },
        (result) {
          if (_isInChat) {
            _markMessagesAsRead(chatRoomId);
          }
          emit(state.copyWith(messages: result.items, lastDoc: result.lastDoc));
        },
      );
    });
  }

  Future<void> loadMoreMessages() async {
    final current = Platform.environment.containsKey('FLUTTER_TEST')
        ? S()
        : S.current;

    if (state.status != ChatStatus.loaded ||
        state.messages.isEmpty ||
        !state.hasMoreMessages ||
        state.isLoadingMore) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    try {
      final lastMessage = state.messages.last;
      final lastDoc = await _chatRepository
          .getChatRoomMessages(state.chatRoomId!)
          .doc(lastMessage.id)
          .get();

      final result = await _chatRepository.getMoreMessages(
        state.chatRoomId!,
        lastDocument: lastDoc,
      );

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              error: failure.message,
              isLoadingMore: false,
              status: ChatStatus.error,
            ),
          );
        },
        (moreMessages) {
          if (moreMessages.items.isEmpty) {
            emit(state.copyWith(hasMoreMessages: false, isLoadingMore: false));
            return;
          }

          emit(
            state.copyWith(
              messages: [...state.messages, ...moreMessages.items],
              hasMoreMessages: moreMessages.items.length >= 20,
              isLoadingMore: false,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          error: current.errorFailedToLoadMoreMessages,
          isLoadingMore: false,
        ),
      );
    }
  }

  Future<void> _markMessagesAsRead(String chatRoomId) async {
    try {
      await _chatRepository.markMessagesAsRead(chatRoomId, currentUserId);
    } catch (e) {
      log("error marking messages as read $e");
    }
  }

  void _subscribeToBlockStatus(String otherUserId) {
    _blockStatusSubscription?.cancel();
    _blockStatusSubscription = _chatRepository
        .isUserBlocked(currentUserId, otherUserId)
        .listen(
          (eitherIsBlocked) {
            eitherIsBlocked.fold(
              (failure) {
                emit(state.copyWith(error: failure.message));
              },
              (isBlocked) {
                emit(state.copyWith(isUserBlocked: isBlocked));

                _amIBlockStatusSubscription?.cancel();
                _amIBlockStatusSubscription = _chatRepository
                    .amIBlocked(currentUserId, otherUserId)
                    .listen(
                      (eitherAmIBlocked) {
                        eitherAmIBlocked.fold(
                          (failure) {
                            emit(
                              state.copyWith(
                                error: failure.message,
                                status: ChatStatus.error,
                              ),
                            );
                          },
                          (amIBlocked) {
                            emit(state.copyWith(amIBlocked: amIBlocked));
                          },
                        );
                      },
                      onError: (_) {
                        emit(
                          state.copyWith(
                            error: S.current.errorFailedToGettingAmIBlocked,
                            status: ChatStatus.error,
                          ),
                        );
                      },
                    );
              },
            );
          },
          onError: (_) {
            emit(
              state.copyWith(
                error: S.current.errorFailedToGettingIsUserBlocked,
                status: ChatStatus.error,
              ),
            );
          },
        );
  }

  void _subscribeToUserInfo(String receiverId) {
    _userInfoSubscription?.cancel();
    _userInfoSubscription = _chatRepository.getUserInfo(receiverId).listen((
      either,
    ) {
      either.fold(
        (failure) {
          log("error getting user info: ${failure.message}");
          emit(
            state.copyWith(error: failure.message, status: ChatStatus.error),
          );
        },
        (userInfo) {
          emit(
            state.copyWith(
              receiverAvatarUrl: userInfo.avatarUrl,
              receiverFullName: userInfo.fullName,
            ),
          );
        },
      );
    });
  }

  Future<void> blockUser(String userId) async {
    final result = await _chatRepository.blockUser(currentUserId, userId);
    result.fold(
      (failure) {
        emit(state.copyWith(error: failure.message, status: ChatStatus.error));
      },
      (_) {
        emit(state.copyWith(isUserBlocked: true));
      },
    );
  }

  Future<void> unBlockUser(String userId) async {
    final result = await _chatRepository.unBlockUser(currentUserId, userId);
    result.fold(
      (failure) {
        emit(state.copyWith(error: failure.message, status: ChatStatus.error));
      },
      (_) {
        emit(state.copyWith(isUserBlocked: false));
      },
    );
  }

  void _subscribeToTypingStatus({
    required String chatRoomId,
    required String receiverId,
  }) {
    _typingSubscription?.cancel();
    _typingSubscription = _chatRepository
        .getTypingStatus(chatRoomId: chatRoomId, receiverId: receiverId)
        .listen(
          (status) {
            emit(state.copyWith(isReceiverTyping: status));
          },
          onError: (error) {
            // print("error getting online status");
          },
        );
  }

  void startTyping() {
    if (state.chatRoomId == null) return;

    typingTimer?.cancel();
    _updateTypingStatus(true);
  }

  Future<void> _updateTypingStatus(bool isTyping) async {
    if (state.chatRoomId == null) return;

    try {
      await _chatRepository.updateTypingStatus(
        state.chatRoomId!,
        currentUserId,
        isTyping,
      );
    } catch (e) {
      log("error updating typing status $e");
    }
  }

  Future<void> leaveRoom() async {
    _messageSubscription?.cancel();
    _amIBlockStatusSubscription?.cancel();
    _blockStatusSubscription?.cancel();
    _userInfoSubscription?.cancel();
    _typingSubscription?.cancel();
    _isInChat = false;
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _amIBlockStatusSubscription?.cancel();
    _blockStatusSubscription?.cancel();
    _userInfoSubscription?.cancel();
    _typingSubscription?.cancel();
    _isInChat = false;
    return super.close();
  }
}

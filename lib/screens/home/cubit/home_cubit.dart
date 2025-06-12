import 'dart:async';

import 'package:chat_app/models/models.dart' show ChatRoomModel;
import 'package:chat_app/repositories/chat_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required ChatRepository chatRepository})
    : _chatRepository = chatRepository,
      super(const HomeState());

  final ChatRepository _chatRepository;

  StreamSubscription<List<ChatRoomModel>>? _chatRoomSub;

  void initialize(String currentUserId) {
    emit(state.copyWith(status: HomeStatus.loading));

    _chatRoomSub?.cancel();
    _chatRoomSub = _chatRepository
        .getChatRooms(currentUserId)
        .listen(
          (chatRooms) {
            emit(state.copyWith(chats: chatRooms, status: HomeStatus.success));
          },
          onError: (error) {
            emit(state.copyWith(status: HomeStatus.failure, errorMessage: ''));
          },
        );
  }

  void dispose() {
    _chatRoomSub?.cancel();
  }
}

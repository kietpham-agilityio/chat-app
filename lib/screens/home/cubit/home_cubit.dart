import 'dart:async';

import 'package:chat_app/core/utils/failure.dart';
import 'package:chat_app/models/models.dart' show ChatRoomModel;
import 'package:chat_app/repositories/chat_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required ChatRepository chatRepository})
    : _chatRepository = chatRepository,
      super(const HomeState());

  final ChatRepository _chatRepository;

  StreamSubscription<Either<Failure, List<ChatRoomModel>>>? _chatRoomSub;

  void initialize(String currentUserId) {
    emit(state.copyWith(status: HomeStatus.loading));

    _chatRoomSub?.cancel();
    _chatRoomSub = _chatRepository
        .getChatRooms(currentUserId)
        .listen(
          (either) => either.fold(
            (failure) => emit(
              state.copyWith(
                status: HomeStatus.failure,
                errorMessage: failure.message,
              ),
            ),
            (chatRooms) => emit(
              state.copyWith(chats: chatRooms, status: HomeStatus.success),
            ),
          ),
        );
  }

  void dispose() {
    _chatRoomSub?.cancel();
  }

  @override
  Future<void> close() {
    _chatRoomSub?.cancel();
    return super.close();
  }
}

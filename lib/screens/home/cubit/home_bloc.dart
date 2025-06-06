import 'package:chat_app/models/models.dart' show ChatRoomModel;
import 'package:chat_app/repositories/repositories.dart' show ChatRepository;
import 'package:equatable/equatable.dart' show Equatable;
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required ChatRepository chatRepository})
    : _chatRepository = chatRepository,
      super(const HomeState()) {
    on<HomeInitializeEvent>(_initialize);
  }

  final ChatRepository _chatRepository;

  Future<void> _initialize(
    HomeInitializeEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));

    return emit.onEach<List<ChatRoomModel>>(
      _chatRepository.getChatRooms(event.currentUserId),
      onData: (chatRooms) {
        emit(state.copyWith(chats: chatRooms, status: HomeStatus.success));
      },
      onError: (error, stackTrace) {
        emit(state.copyWith(status: HomeStatus.failure, errorMessage: ''));
      },
    );
  }
}

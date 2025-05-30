import 'package:chat_app/models/models.dart' show ChatRoomModel;
import 'package:chat_app/repositories/repositories.dart' show ChatRepository;
import 'package:cloud_firestore/cloud_firestore.dart';
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

  Stream<List<ChatRoomModel>> getChatRooms(String userId) {
    final now = Timestamp.now();
    final mockChatRooms = List.generate(50, (index) {
      final chatId = 'chat_$index';
      final otherUserId = 'user_${index + 1}';

      return ChatRoomModel(
        id: chatId,
        participants: [userId, otherUserId],
        lastMessage: 'Message $index',
        lastMessageSenderId: index % 2 == 0 ? userId : otherUserId,
        lastMessageTime: Timestamp.fromMillisecondsSinceEpoch(
          now.millisecondsSinceEpoch - index * 60000,
        ),
        lastReadTime: {userId: now, otherUserId: now},
        participantsName: {userId: 'You', otherUserId: 'User $index'},
        isTyping: index % 10 == 0,
        typingUserId: index % 10 == 0 ? otherUserId : null,
        isCallActive: index % 7 == 0,
      );
    });

    return Stream.value(mockChatRooms);
  }
}

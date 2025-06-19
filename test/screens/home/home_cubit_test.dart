import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:chat_app/core/utils/failure.dart';
import 'package:chat_app/models/chat_room_model.dart';
import 'package:chat_app/repositories/chat_repository.dart';
import 'package:chat_app/screens/home/cubit/home_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late MockChatRepository mockChatRepository;
  late StreamController<Either<Failure, List<ChatRoomModel>>>
  chatRoomStreamController;

  setUp(() {
    mockChatRepository = MockChatRepository();
    chatRoomStreamController =
        StreamController<Either<Failure, List<ChatRoomModel>>>();
    when(
      () => mockChatRepository.getChatRooms(any()),
    ).thenAnswer((_) => chatRoomStreamController.stream);
  });

  tearDown(() {
    chatRoomStreamController.close();
  });

  group('HomeCubit', () {
    const userId = 'user1';
    final chatRooms = [
      ChatRoomModel(id: 'room1', participants: ['user1', 'user2']),
      ChatRoomModel(id: 'room2', participants: ['user1', 'user3']),
    ];

    blocTest<HomeCubit, HomeState>(
      'emits [loading, success] when getChatRooms returns chat rooms',
      build: () => HomeCubit(chatRepository: mockChatRepository),
      act: (cubit) {
        cubit.initialize(userId);
        chatRoomStreamController.add(Right(chatRooms));
      },
      expect: () => [
        const HomeState(status: HomeStatus.loading),
        HomeState(status: HomeStatus.success, chats: chatRooms),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'emits [loading, failure] when getChatRooms returns failure',
      build: () => HomeCubit(chatRepository: mockChatRepository),
      act: (cubit) {
        cubit.initialize(userId);
        chatRoomStreamController.add(Left(Failure('Some error')));
      },
      expect: () => [
        const HomeState(status: HomeStatus.loading),
        const HomeState(status: HomeStatus.failure, errorMessage: 'Some error'),
      ],
    );

    test('dispose cancels subscription', () async {
      final cubit = HomeCubit(chatRepository: mockChatRepository);
      cubit.initialize(userId);
      cubit.dispose();
      expect(chatRoomStreamController.hasListener, false);
      await cubit.close();
    });

    test('close cancels subscription', () async {
      final cubit = HomeCubit(chatRepository: mockChatRepository);
      cubit.initialize(userId);
      await cubit.close();
      expect(chatRoomStreamController.hasListener, false);
    });
  });
}

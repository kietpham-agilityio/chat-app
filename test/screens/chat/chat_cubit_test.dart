// ignore_for_file: subtype_of_sealed_class

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:chat_app/core/local_database/user_box.dart';
import 'package:chat_app/core/utils/failure.dart';
import 'package:chat_app/models/chat_message_model.dart';
import 'package:chat_app/models/chat_room_model.dart';
import 'package:chat_app/models/paginated_result.dart';
import 'package:chat_app/repositories/repositories.dart';
import 'package:chat_app/screens/chat/cubit/chat_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockChatRepository extends Mock implements ChatRepository {}

class MockUserBox extends Mock implements UserBox {}

class FakeChatMessageModel extends Fake implements ChatMessageModel {}

class FakeDocumentSnapshot extends Fake implements DocumentSnapshot {}

class FakePaginatedResult extends Fake
    implements PaginatedResult<ChatMessageModel> {
  @override
  List<ChatMessageModel> get items => [];
  @override
  DocumentSnapshot<Object?>? get lastDoc => null;
}

void main() {
  late ChatCubit chatCubit;
  late MockChatRepository mockChatRepository;
  late MockUserBox mockUserBox;
  const currentUserId = 'user1';
  const receiverId = 'user2';

  setUpAll(() {
    registerFallbackValue(FakeChatMessageModel());
    registerFallbackValue(FakeDocumentSnapshot());
    registerFallbackValue(FakePaginatedResult());
  });

  setUp(() {
    mockChatRepository = MockChatRepository();
    mockUserBox = MockUserBox();
    chatCubit = ChatCubit(
      chatRepository: mockChatRepository,
      currentUserId: currentUserId,
      userBox: mockUserBox,
    );
  });

  tearDown(() async {
    await chatCubit.close();
  });

  group('messageChanged', () {
    blocTest<ChatCubit, ChatState>(
      'emits state with updated message',
      build: () => chatCubit,
      act: (cubit) => cubit.messageChanged('hello'),
      expect: () => [chatCubit.state.copyWith(message: 'hello')],
    );
  });

  group('getMyAvatarUrl', () {
    // test('emits state with myAvatarUrl', () async {
    //   when(
    //     () => mockUserBox.getUser(),
    //   ).thenAnswer((_) async => _FakeUser(avatarUrl: 'avatar.png'));
    //   await chatCubit.getMyAvatarUrl();
    //   expect(chatCubit.state.myAvatarUrl, 'avatar.png');
    // });

    test('emits state with null avatar if user is null', () async {
      when(() => mockUserBox.getUser()).thenAnswer((_) async => null);
      await chatCubit.getMyAvatarUrl();
      expect(chatCubit.state.myAvatarUrl, null);
    });
  });

  group('checkExistingChatRoom', () {
    test('returns true when chat room exists', () async {
      when(
        () => mockChatRepository.findExistingChatRoom(any()),
      ).thenAnswer((_) async => right(true));
      final result = await chatCubit.checkExistingChatRoom(receiverId);
      expect(result, true);
    });

    test('returns false when chat room does not exist', () async {
      when(
        () => mockChatRepository.findExistingChatRoom(any()),
      ).thenAnswer((_) async => right(false));
      final result = await chatCubit.checkExistingChatRoom(receiverId);
      expect(result, false);
    });

    test('returns false and logs error on failure', () async {
      when(
        () => mockChatRepository.findExistingChatRoom(any()),
      ).thenAnswer((_) async => left(const Failure('error')));
      final result = await chatCubit.checkExistingChatRoom(receiverId);
      expect(result, false);
    });
  });

  // group('sendMessage', () {
  //   final chatRoom = ChatRoomModel(
  //     id: 'room1',
  //     participants: [currentUserId, receiverId],
  //   );
  //   setUp(() {
  //     when(
  //       () => mockChatRepository.findExistingChatRoom(any()),
  //     ).thenAnswer((_) async => right(false));
  //     when(
  //       () => mockChatRepository.getOrCreateChatRoom(any(), any()),
  //     ).thenAnswer((_) async => right(chatRoom));
  //     when(
  //       () => mockChatRepository.sendMessage(
  //         chatRoomId: any(named: 'chatRoomId'),
  //         senderId: any(named: 'senderId'),
  //         receiverId: any(named: 'receiverId'),
  //         content: any(named: 'content'),
  //       ),
  //     ).thenAnswer((_) async => right(unit));
  //   });

  //   blocTest<ChatCubit, ChatState>(
  //     'emits loading and loaded when sending message to new chat room',
  //     build: () => chatCubit,
  //     act: (cubit) => cubit.sendMessage(content: 'hi', receiverId: receiverId),
  //     expect: () => [
  //       chatCubit.state.copyWith(status: ChatStatus.loading),
  //       chatCubit.state.copyWith(
  //         chatRoomId: 'room1',
  //         receiverId: receiverId,
  //         status: ChatStatus.loaded,
  //       ),
  //     ],
  //   );

  //   blocTest<ChatCubit, ChatState>(
  //     'emits loading and error when getOrCreateChatRoom returns left',
  //     build: () => chatCubit,
  //     setUp: () {
  //       when(
  //         () => mockChatRepository.getOrCreateChatRoom(any(), any()),
  //       ).thenAnswer((_) async => left(const Failure('room error')));
  //     },
  //     act: (cubit) => cubit.sendMessage(content: 'hi', receiverId: receiverId),
  //     expect: () => [
  //       chatCubit.state.copyWith(status: ChatStatus.loading),
  //       chatCubit.state.copyWith(error: 'room error', status: ChatStatus.error),
  //     ],
  //   );

  //   blocTest<ChatCubit, ChatState>(
  //     'emits error when sendMessage throws',
  //     build: () => chatCubit,
  //     setUp: () {
  //       when(
  //         () => mockChatRepository.sendMessage(
  //           chatRoomId: any(named: 'chatRoomId'),
  //           senderId: any(named: 'senderId'),
  //           receiverId: any(named: 'receiverId'),
  //           content: any(named: 'content'),
  //         ),
  //       ).thenThrow(Exception('fail'));
  //     },
  //     act: (cubit) => cubit.sendMessage(content: 'hi', receiverId: receiverId),
  //     expect: () => [chatCubit.state.copyWith(error: "Failed to send message")],
  //   );
  // });

  // group('enterChat', () {
  //   final chatRoom = ChatRoomModel(
  //     id: 'room1',
  //     participants: [currentUserId, receiverId],
  //   );
  //   setUp(() {
  //     when(
  //       () => mockChatRepository.findExistingChatRoom(any()),
  //     ).thenAnswer((_) async => right(true));
  //     when(
  //       () => mockChatRepository.getOrCreateChatRoom(any(), any()),
  //     ).thenAnswer((_) async => right(chatRoom));
  //   });

  //   blocTest<ChatCubit, ChatState>(
  //     'emits loading and loaded when entering existing chat',
  //     build: () => chatCubit,
  //     act: (cubit) => cubit.enterChat(receiverId),
  //     expect: () => [
  //       chatCubit.state.copyWith(status: ChatStatus.loading),
  //       chatCubit.state.copyWith(
  //         chatRoomId: chatRoom.id,
  //         receiverId: receiverId,
  //         status: ChatStatus.error,
  //       ),
  //     ],
  //   );

  //   // blocTest<ChatCubit, ChatState>(
  //   //   'emits error when getOrCreateChatRoom returns left',
  //   //   build: () => chatCubit,
  //   //   setUp: () {
  //   //     when(
  //   //       () => mockChatRepository.getOrCreateChatRoom(any(), any()),
  //   //     ).thenAnswer((_) async => left(const Failure('room error')));
  //   //   },
  //   //   act: (cubit) => cubit.enterChat(receiverId),
  //   //   expect: () => [
  //   //     chatCubit.state.copyWith(status: ChatStatus.loading),
  //   //     chatCubit.state.copyWith(error: 'room error', status: ChatStatus.error),
  //   //   ],
  //   // );

  //   blocTest<ChatCubit, ChatState>(
  //     'emits error when exception thrown',
  //     build: () => chatCubit,
  //     setUp: () {
  //       when(
  //         () => mockChatRepository.findExistingChatRoom(any()),
  //       ).thenThrow(Exception('fail'));
  //     },
  //     act: (cubit) => cubit.enterChat(receiverId),
  //     expect: () => [
  //       chatCubit.state.copyWith(
  //         status: ChatStatus.error,
  //         error: "Failed to create chat room Exception: fail",
  //       ),
  //     ],
  //   );
  // });

  group('enterChat', () {
    final mockChatRoom = ChatRoomModel(
      id: 'room123',
      participants: [currentUserId, receiverId],
    );

    test('initial state is ChatState()', () {
      expect(chatCubit.state, const ChatState());
    });

    blocTest<ChatCubit, ChatState>(
      'emits [loading, loaded] when chat room exists',
      build: () {
        when(
          () => mockChatRepository.findExistingChatRoom(any()),
        ).thenAnswer((_) async => const Right(true));

        when(
          () =>
              mockChatRepository.getOrCreateChatRoom(currentUserId, receiverId),
        ).thenAnswer((_) async => Right(mockChatRoom));

        when(
          () => mockChatRepository.getMessages(any()),
        ).thenAnswer((_) => const Stream.empty());
        when(
          () => mockChatRepository.isUserBlocked(any(), any()),
        ).thenAnswer((_) => const Stream.empty());
        when(
          () => mockChatRepository.getUserInfo(any()),
        ).thenAnswer((_) => const Stream.empty());

        return chatCubit;
      },
      act: (cubit) => cubit.enterChat(receiverId),
      expect: () => [
        const ChatState(status: ChatStatus.loading),
        ChatState(
          status: ChatStatus.loaded,
          chatRoomId: mockChatRoom.id,
          receiverId: receiverId,
        ),
      ],
    );

    blocTest<ChatCubit, ChatState>(
      'does not emit anything when chat room does not exist',
      build: () {
        when(
          () => mockChatRepository.findExistingChatRoom(any()),
        ).thenAnswer((_) async => const Right(false));
        return chatCubit;
      },
      act: (cubit) => cubit.enterChat(receiverId),
      expect: () => [],
    );

    blocTest<ChatCubit, ChatState>(
      'emits error when exception occurs',
      build: () {
        when(
          () => mockChatRepository.findExistingChatRoom(any()),
        ).thenThrow(Failure('Failed to create chat room. Please try again.'));
        return chatCubit;
      },
      act: (cubit) => cubit.enterChat(receiverId),
      expect: () => [
        const ChatState(
          status: ChatStatus.error,
          error: 'Failed to create chat room. Please try again.',
        ),
      ],
    );

    blocTest<ChatCubit, ChatState>(
      'emits [loading, loaded] when chat room exists',
      build: () {
        when(
          () => mockChatRepository.findExistingChatRoom(any()),
        ).thenAnswer((_) async => const Right(true));

        when(
          () =>
              mockChatRepository.getOrCreateChatRoom(currentUserId, receiverId),
        ).thenAnswer((_) async => Right(mockChatRoom));

        final controller =
            StreamController<
              Either<Failure, PaginatedResult<ChatMessageModel>>
            >();
        when(
          () => mockChatRepository.getMessages(mockChatRoom.id),
        ).thenAnswer((_) => controller.stream);

        Future.microtask(() {
          controller.add(Right(PaginatedResult(items: [], lastDoc: null)));
        });

        when(
          () => mockChatRepository.isUserBlocked(any(), any()),
        ).thenAnswer((_) => const Stream.empty());

        when(
          () => mockChatRepository.getUserInfo(any()),
        ).thenAnswer((_) => const Stream.empty());

        return chatCubit;
      },
      act: (cubit) => cubit.enterChat(receiverId),
      expect: () => [
        const ChatState(status: ChatStatus.loading),
        ChatState(
          status: ChatStatus.loaded,
          chatRoomId: mockChatRoom.id,
          receiverId: receiverId,
        ),
      ],
    );

    blocTest<ChatCubit, ChatState>(
      'emits [loading, error] when getOrCreateChatRoom fails',
      build: () {
        when(
          () => mockChatRepository.findExistingChatRoom(any()),
        ).thenAnswer((_) async => const Right(true));

        when(
          () =>
              mockChatRepository.getOrCreateChatRoom(currentUserId, receiverId),
        ).thenAnswer(
          (_) async => const Left(Failure('Failed to get or create room')),
        );

        return chatCubit;
      },
      act: (cubit) => cubit.enterChat(receiverId),
      expect: () => [
        const ChatState(status: ChatStatus.loading),
        const ChatState(
          status: ChatStatus.error,
          error: 'Failed to get or create room',
        ),
      ],
    );
  });

  group('loadMoreMessages', () {
    test('does nothing if not loaded', () async {
      await chatCubit.loadMoreMessages();
      expect(chatCubit.state.isLoadingMore, false);
    });

    test('emits error if exception thrown', () async {
      chatCubit.emit(
        chatCubit.state.copyWith(
          status: ChatStatus.loaded,
          messages: [FakeChatMessageModel()],
          chatRoomId: 'room1',
        ),
      );
      when(
        () => mockChatRepository.getChatRoomMessages(any()),
      ).thenThrow(Failure('fail'));
      await chatCubit.loadMoreMessages();
      expect(chatCubit.state.isLoadingMore, false);
    });
  });

  group('blockUser', () {
    test('emits isUserBlocked true on success', () async {
      when(
        () => mockChatRepository.blockUser(any(), any()),
      ).thenAnswer((_) async => right(unit));
      await chatCubit.blockUser(receiverId);
      expect(chatCubit.state.isUserBlocked, true);
    });

    test('emits error on failure', () async {
      when(
        () => mockChatRepository.blockUser(any(), any()),
      ).thenAnswer((_) async => left(const Failure('fail')));
      await chatCubit.blockUser(receiverId);
      expect(chatCubit.state.status, ChatStatus.error);
      expect(chatCubit.state.error, 'fail');
    });
  });

  group('unBlockUser', () {
    test('emits isUserBlocked false on success', () async {
      when(
        () => mockChatRepository.unBlockUser(any(), any()),
      ).thenAnswer((_) async => right(unit));
      await chatCubit.unBlockUser(receiverId);
      expect(chatCubit.state.isUserBlocked, false);
    });

    test('emits error on failure', () async {
      when(
        () => mockChatRepository.unBlockUser(any(), any()),
      ).thenAnswer((_) async => left(const Failure('fail')));
      await chatCubit.unBlockUser(receiverId);
      expect(chatCubit.state.status, ChatStatus.error);
      expect(chatCubit.state.error, 'fail');
    });
  });

  group('leaveRoom', () {
    test('cancels subscriptions and resets _isInChat', () async {
      await chatCubit.leaveRoom();
      expect(chatCubit.state, isA<ChatState>());
    });
  });

  group('close', () {
    test('cancels subscriptions and resets _isInChat', () async {
      await chatCubit.close();
      expect(chatCubit.state, isA<ChatState>());
    });
  });
}

// class _FakeUser {
//   final String? avatarUrl;
//   _FakeUser({this.avatarUrl});
// }

// import 'package:bloc_test/bloc_test.dart';
// import 'package:chat_app/core/local_database/user_box.dart';
// import 'package:chat_app/models/chat_room_model.dart';
// import 'package:chat_app/repositories/chat_repository.dart';
// import 'package:chat_app/screens/chat/cubit/chat_cubit.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:fpdart/fpdart.dart';
// import 'package:mocktail/mocktail.dart';

// class MockChatRepository extends Mock implements ChatRepository {}

// class MockUserBox extends Mock implements UserBox {}

// void main() {
//   late MockChatRepository chatRepository;
//   late MockUserBox userBox;
//   late ChatCubit chatCubit;

//   const currentUserId = 'user1';
//   const receiverId = 'user2';

//   setUp(() {
//     chatRepository = MockChatRepository();
//     userBox = MockUserBox();
//     chatCubit = ChatCubit(
//       chatRepository: chatRepository,
//       currentUserId: currentUserId,
//       userBox: userBox,
//     );
//   });

//   tearDown(() {
//     chatCubit.close();
//   });

//   group('enterChat', () {
//     final mockChatRoom = ChatRoomModel(
//       id: 'room123',
//       participants: [currentUserId, receiverId],
//     );

//     test('initial state is ChatState()', () {
//       expect(chatCubit.state, const ChatState());
//     });

//     blocTest<ChatCubit, ChatState>(
//       'emits [loading, loaded] when chat room exists',
//       build: () {
//         when(
//           () => chatRepository.findExistingChatRoom(any()),
//         ).thenAnswer((_) async => const Right(true));

//         when(
//           () => chatRepository.getOrCreateChatRoom(currentUserId, receiverId),
//         ).thenAnswer((_) async => Right(mockChatRoom));

//         when(
//           () => chatRepository.getMessages(any()),
//         ).thenAnswer((_) => const Stream.empty());
//         when(
//           () => chatRepository.isUserBlocked(any(), any()),
//         ).thenAnswer((_) => const Stream.empty());
//         when(
//           () => chatRepository.getUserInfo(any()),
//         ).thenAnswer((_) => const Stream.empty());

//         return chatCubit;
//       },
//       act: (cubit) => cubit.enterChat(receiverId),
//       expect: () => [
//         const ChatState(status: ChatStatus.loading),
//         ChatState(
//           status: ChatStatus.loaded,
//           chatRoomId: mockChatRoom.id,
//           receiverId: receiverId,
//         ),
//       ],
//     );

//     blocTest<ChatCubit, ChatState>(
//       'does not emit anything when chat room does not exist',
//       build: () {
//         when(
//           () => chatRepository.findExistingChatRoom(any()),
//         ).thenAnswer((_) async => const Right(false));
//         return chatCubit;
//       },
//       act: (cubit) => cubit.enterChat(receiverId),
//       expect: () => [],
//     );

//     blocTest<ChatCubit, ChatState>(
//       'emits error when exception occurs',
//       build: () {
//         when(
//           () => chatRepository.findExistingChatRoom(any()),
//         ).thenThrow(Exception('test error'));
//         return chatCubit;
//       },
//       act: (cubit) => cubit.enterChat(receiverId),
//       expect: () => [
//         const ChatState(
//           status: ChatStatus.error,
//           error: 'Failed to create chat room Exception: test error',
//         ),
//       ],
//     );
//   });
// }

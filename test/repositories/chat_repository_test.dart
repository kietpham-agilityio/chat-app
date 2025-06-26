// ignore_for_file: subtype_of_sealed_class

import 'dart:async';

import 'package:chat_app/core/utils/failure.dart';
import 'package:chat_app/models/chat_message_model.dart';
import 'package:chat_app/models/chat_room_model.dart';
import 'package:chat_app/models/paginated_result.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/repositories/chat_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockQuery extends Mock implements Query<Map<String, dynamic>> {}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

class MockWriteBatch extends Mock implements WriteBatch {}

class FakeDocumentReference extends Fake
    implements DocumentReference<Map<String, dynamic>> {}

class MockUser extends Mock implements User {}

void main() {
  late MockFirebaseFirestore mockFirestore;
  late MockFirebaseAuth mockAuth;
  late ChatRepository chatRepository;
  late MockCollectionReference mockChatRoomCollection;
  late MockCollectionReference mockMessageCollection;
  late MockCollectionReference mockUsersCollection;
  late MockDocumentReference mockChatRoomDoc;
  late MockDocumentReference mockUserDoc;
  late MockQueryDocumentSnapshot mockMessageDoc;
  late MockWriteBatch mockBatch;
  late MockQuery mockQuery;
  late MockQuerySnapshot mockSnapshot;
  late MockDocumentSnapshot mockRoomSnapshot;
  late MockDocumentReference mockUserDoc1;
  late MockDocumentReference mockUserDoc2;
  late MockDocumentSnapshot mockUserSnapshot1;
  late MockDocumentSnapshot mockUserSnapshot2;

  setUpAll(() {
    registerFallbackValue(FakeDocumentReference());
  });

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockAuth = MockFirebaseAuth();
    chatRepository = ChatRepository(firestore: mockFirestore, auth: mockAuth);
    mockChatRoomCollection = MockCollectionReference();
    mockChatRoomDoc = MockDocumentReference();
    mockMessageCollection = MockCollectionReference();
    mockUsersCollection = MockCollectionReference();
    mockUserDoc = MockDocumentReference();
    mockMessageDoc = MockQueryDocumentSnapshot();
    mockBatch = MockWriteBatch();
    mockQuery = MockQuery();
    mockSnapshot = MockQuerySnapshot();
    mockRoomSnapshot = MockDocumentSnapshot();
    mockUserDoc1 = MockDocumentReference();
    mockUserDoc2 = MockDocumentReference();
    mockUserSnapshot1 = MockDocumentSnapshot();
    mockUserSnapshot2 = MockDocumentSnapshot();
  });

  group('searchUser', () {
    test('returns Right(PaginatedResult) when successful', () async {
      final mockCollection = MockCollectionReference();
      final mockQuery = MockQuery();
      final mockSnapshot = MockQuerySnapshot();
      final mockDoc = MockQueryDocumentSnapshot();
      final mockFirebaseUser = MockUser();

      // Stub Firestore
      when(() => mockFirestore.collection('users')).thenReturn(mockCollection);
      when(
        () => mockCollection.where(
          'fullName',
          isGreaterThanOrEqualTo: any(named: 'isGreaterThanOrEqualTo'),
        ),
      ).thenReturn(mockQuery);
      when(
        () => mockQuery.where(
          'fullName',
          isLessThanOrEqualTo: any(named: 'isLessThanOrEqualTo'),
        ),
      ).thenReturn(mockQuery);
      when(() => mockQuery.orderBy('fullName')).thenReturn(mockQuery);
      when(() => mockQuery.limit(any())).thenReturn(mockQuery);
      when(() => mockQuery.get()).thenAnswer((_) async => mockSnapshot);

      // Stub document
      when(() => mockSnapshot.docs).thenReturn([mockDoc]);
      when(() => mockDoc.id).thenReturn('user_123');
      when(() => mockDoc.data()).thenReturn({
        'uid': 'user_123',
        'fullName': 'Alice',
        'email': 'alice@example.com',
        'avatarUrl': '',
        'phoneNumber': '',
        'isOnline': true,
        'blockedUsers': [],
      });

      // Stub auth
      when(() => mockAuth.currentUser).thenReturn(mockFirebaseUser);
      when(() => mockFirebaseUser.uid).thenReturn('current_user');

      final result = await chatRepository.searchUser(searchText: 'Alice');

      expect(result.isRight(), true);
      result.match((_) => fail('Expected Right but got Left'), (r) {
        expect(r.items.length, 1);
        expect(r.items.first.fullName, 'Alice');
      });
    });

    test('returns Left(Failure) when throws exception', () async {
      final mockCollection = MockCollectionReference();

      when(() => mockFirestore.collection('users')).thenReturn(mockCollection);
      when(
        () => mockCollection.where(
          'fullName',
          isGreaterThanOrEqualTo: any(named: 'isGreaterThanOrEqualTo'),
        ),
      ).thenThrow(Exception('Failed'));

      final result = await chatRepository.searchUser(searchText: 'A');

      expect(result.isLeft(), isTrue);
    });
  });

  group('getChatRooms', () {
    final mockCollection = MockCollectionReference();

    test('emits Right(List<ChatRoomModel>) when successful', () async {
      const userId = 'user123';

      final mockQuery = MockQuery();
      final mockSnapshot = MockQuerySnapshot();
      final mockDoc = MockQueryDocumentSnapshot();

      // Setup firestore mocks
      when(
        () => mockFirestore.collection('chatRooms'),
      ).thenReturn(mockCollection);
      when(
        () => mockCollection.where('participants', arrayContains: userId),
      ).thenReturn(mockQuery);
      when(
        () => mockQuery.orderBy('lastMessageTime', descending: true),
      ).thenReturn(mockQuery);
      when(
        () => mockQuery.snapshots(),
      ).thenAnswer((_) => Stream.value(mockSnapshot));

      // Setup snapshot docs
      when(() => mockSnapshot.docs).thenReturn([mockDoc]);
      when(() => mockDoc.id).thenReturn('room_1');
      when(() => mockDoc.data()).thenReturn({
        'participants': [userId, 'user456'],
        'lastMessage': 'Hello',
        'lastMessageSenderId': 'user456',
        'lastMessageTime': Timestamp.now(),
        'participantsName': {userId: 'User 123', 'user456': 'User 456'},
        'participantsAvatar': {userId: '', 'user456': ''},
        'lastReadTime': {},
      });

      // Fake ChatRoomModel.fromFirestore
      registerFallbackValue(mockDoc);
      ChatRoomModel fakeRoom = ChatRoomModel(
        id: 'room_1',
        participants: [userId, 'user456'],
        lastMessage: 'Hello',
        lastMessageSenderId: 'user456',
        lastMessageTime: Timestamp.now(),
        participantsName: {userId: 'User 123', 'user456': 'User 456'},
        participantsAvatar: {userId: '', 'user456': ''},
        lastReadTime: {},
      );

      // Run test
      final stream = chatRepository.getChatRooms(userId);

      await expectLater(
        stream,
        emits(
          predicate<Either<Failure, List<ChatRoomModel>>>((either) {
            return either.isRight() &&
                either.getOrElse((_) => []).first.id == fakeRoom.id;
          }),
        ),
      );
    });
  });

  group('getMessages', () {
    const chatRoomId = 'room_123';

    test('emits Right(PaginatedResult) when successful', () async {
      final mockQuery = MockQuery();
      final mockSnapshot = MockQuerySnapshot();
      final mockDoc = MockQueryDocumentSnapshot();

      when(
        () => mockFirestore.collection('chatRooms'),
      ).thenReturn(mockChatRoomCollection);
      when(
        () => mockChatRoomCollection.doc(chatRoomId),
      ).thenReturn(mockChatRoomDoc);
      when(
        () => mockChatRoomDoc.collection('messages'),
      ).thenReturn(mockMessageCollection);

      when(
        () => mockMessageCollection.orderBy('timestamp', descending: true),
      ).thenReturn(mockQuery);
      when(() => mockQuery.limit(20)).thenReturn(mockQuery);
      when(
        () => mockQuery.snapshots(),
      ).thenAnswer((_) => Stream.value(mockSnapshot));

      when(() => mockSnapshot.docs).thenReturn([mockDoc]);

      when(() => mockDoc.id).thenReturn('msg_1');
      when(() => mockDoc.data()).thenReturn({
        'id': 'msg_1',
        'chatRoomId': chatRoomId,
        'senderId': 'user1',
        'receiverId': 'user2',
        'content': 'Hello',
        'timestamp': Timestamp.now(),
        'type': 'text',
        'readBy': ['user1'],
      });

      final stream = chatRepository.getMessages(chatRoomId);

      await expectLater(
        stream,
        emits(
          predicate<Either<Failure, PaginatedResult<ChatMessageModel>>>((
            either,
          ) {
            if (either.isRight()) {
              final result = either.getOrElse(
                (_) => PaginatedResult(items: [], lastDoc: null),
              );
              return result.items.isNotEmpty &&
                  result.items.first.id == 'msg_1';
            }
            return false;
          }),
        ),
      );
    });
  });

  group('getUserInfo', () {
    const userId = 'user_123';

    test('emits Right(UserModel) when successful', () async {
      final mockSnapshot = MockDocumentSnapshot();

      when(
        () => mockFirestore.collection('users'),
      ).thenReturn(mockUsersCollection);
      when(() => mockUsersCollection.doc(userId)).thenReturn(mockUserDoc);
      when(
        () => mockUserDoc.snapshots(),
      ).thenAnswer((_) => Stream.value(mockSnapshot));

      when(() => mockSnapshot.data()).thenReturn({
        'uid': userId,
        'email': 'user@example.com',
        'fullName': 'Test User',
        'avatarUrl': '',
        'blockedUsers': [],
      });

      when(() => mockSnapshot.id).thenReturn(userId);

      final stream = chatRepository.getUserInfo(userId);

      await expectLater(
        stream,
        emits(
          predicate<Either<Failure, UserModel>>((either) {
            return either.isRight() &&
                either.getOrElse((_) => UserModel.empty).uid == userId;
          }),
        ),
      );
    });
  });

  group('getMoreMessages', () {
    const chatRoomId = 'room_123';
    final mockLastDocument = MockDocumentSnapshot();

    test('returns Right(PaginatedResult) when successful', () async {
      final mockQuery = MockQuery();
      final mockSnapshot = MockQuerySnapshot();
      final mockDoc = MockQueryDocumentSnapshot();

      // Setup Firestore mocks
      when(
        () => mockFirestore.collection('chatRooms'),
      ).thenReturn(mockChatRoomCollection);
      when(
        () => mockChatRoomCollection.doc(chatRoomId),
      ).thenReturn(mockChatRoomDoc);
      when(
        () => mockChatRoomDoc.collection('messages'),
      ).thenReturn(mockMessageCollection);
      when(
        () => mockMessageCollection.orderBy('timestamp', descending: true),
      ).thenReturn(mockQuery);
      when(
        () => mockQuery.startAfterDocument(mockLastDocument),
      ).thenReturn(mockQuery);
      when(() => mockQuery.limit(20)).thenReturn(mockQuery);
      when(() => mockQuery.get()).thenAnswer((_) async => mockSnapshot);

      when(() => mockSnapshot.docs).thenReturn([mockDoc]);

      when(() => mockDoc.id).thenReturn('msg_1');
      when(() => mockDoc.data()).thenReturn({
        'id': 'msg_1',
        'chatRoomId': chatRoomId,
        'senderId': 'user1',
        'receiverId': 'user2',
        'content': 'Hi there!',
        'timestamp': Timestamp.now(),
        'type': 'text',
        'readBy': ['user1'],
      });

      final result = await chatRepository.getMoreMessages(
        chatRoomId,
        lastDocument: mockLastDocument,
      );

      expect(result.isRight(), true);
      final messages = result.getOrElse(
        (_) => PaginatedResult(items: [], lastDoc: null),
      );
      expect(messages.items.length, 1);
      expect(messages.items.first.id, 'msg_1');
    });

    test('returns Left(Failure) when exception is thrown', () async {
      final mockQuery = MockQuery();

      when(
        () => mockFirestore.collection('chatRooms'),
      ).thenReturn(mockChatRoomCollection);
      when(
        () => mockChatRoomCollection.doc(chatRoomId),
      ).thenReturn(mockChatRoomDoc);
      when(
        () => mockChatRoomDoc.collection('messages'),
      ).thenReturn(mockMessageCollection);
      when(
        () => mockMessageCollection.orderBy('timestamp', descending: true),
      ).thenReturn(mockQuery);
      when(
        () => mockQuery.startAfterDocument(mockLastDocument),
      ).thenReturn(mockQuery);
      when(() => mockQuery.limit(20)).thenReturn(mockQuery);
      when(() => mockQuery.get()).thenThrow(Exception('Firestore error'));

      final result = await chatRepository.getMoreMessages(
        chatRoomId,
        lastDocument: mockLastDocument,
      );

      expect(result.isLeft(), true);
    });
  });

  group('markMessagesAsRead', () {
    const chatRoomId = 'room_123';
    const userId = 'user_456';

    test('returns Right(unit) when batch update succeeds', () async {
      when(
        () => mockFirestore.collection('chatRooms'),
      ).thenReturn(mockChatRoomCollection);
      when(
        () => mockChatRoomCollection.doc(chatRoomId),
      ).thenReturn(mockChatRoomDoc);
      when(
        () => mockChatRoomDoc.collection('messages'),
      ).thenReturn(mockMessageCollection);

      when(
        () => mockMessageCollection.where("receiverId", isEqualTo: userId),
      ).thenReturn(mockQuery);
      when(
        () =>
            mockQuery.where('status', isEqualTo: MessageStatus.sent.toString()),
      ).thenReturn(mockQuery);

      when(() => mockQuery.get()).thenAnswer((_) async => mockSnapshot);

      when(() => mockSnapshot.docs).thenReturn([mockMessageDoc]);

      when(() => mockMessageDoc.reference).thenReturn(MockDocumentReference());

      when(() => mockFirestore.batch()).thenReturn(mockBatch);
      when(() => mockBatch.update(any(), any())).thenReturn(null);
      when(() => mockBatch.commit()).thenAnswer((_) async => {});

      final result = await chatRepository.markMessagesAsRead(
        chatRoomId,
        userId,
      );

      expect(result.isRight(), true);
    });

    test('returns Left(Failure) when exception is thrown', () async {
      when(
        () => mockFirestore.collection('chatRooms'),
      ).thenReturn(mockChatRoomCollection);
      when(
        () => mockChatRoomCollection.doc(chatRoomId),
      ).thenReturn(mockChatRoomDoc);
      when(
        () => mockChatRoomDoc.collection('messages'),
      ).thenReturn(mockMessageCollection);

      when(
        () => mockMessageCollection.where("receiverId", isEqualTo: userId),
      ).thenThrow(Exception('Firestore error'));

      final result = await chatRepository.markMessagesAsRead(
        chatRoomId,
        userId,
      );

      expect(result.isLeft(), true);
    });
  });

  group('getOrCreateChatRoom', () {
    const user1 = 'user_a';
    const user2 = 'user_b';
    final roomId = [user1, user2]..sort();
    final chatRoomId = roomId.join('_');

    test('returns Right(ChatRoomModel) if room exists', () async {
      when(
        () => mockFirestore.collection('chatRooms'),
      ).thenReturn(mockChatRoomCollection);
      when(
        () => mockChatRoomCollection.doc(chatRoomId),
      ).thenReturn(mockChatRoomDoc);
      when(
        () => mockChatRoomDoc.get(),
      ).thenAnswer((_) async => mockRoomSnapshot);
      when(() => mockRoomSnapshot.exists).thenReturn(true);
      when(() => mockRoomSnapshot.data()).thenReturn({
        'id': chatRoomId,
        'participants': roomId,
        'participantsName': {user1: 'A', user2: 'B'},
        'participantsAvatar': {user1: '', user2: ''},
        'lastReadTime': {},
      });
      when(() => mockRoomSnapshot.id).thenReturn(chatRoomId);

      final result = await chatRepository.getOrCreateChatRoom(user1, user2);

      final fakeChatRoom = ChatRoomModel(
        id: '',
        participants: [],
        participantsName: {},
        participantsAvatar: {},
        lastReadTime: {},
      );
      expect(result.isRight(), true);
      expect(result.getOrElse((_) => fakeChatRoom).id, chatRoomId);
    });

    test('creates new room if not exists', () async {
      when(
        () => mockFirestore.collection('chatRooms'),
      ).thenReturn(mockChatRoomCollection);
      when(
        () => mockChatRoomCollection.doc(chatRoomId),
      ).thenReturn(mockChatRoomDoc);
      when(
        () => mockChatRoomDoc.get(),
      ).thenAnswer((_) async => mockRoomSnapshot);
      when(() => mockRoomSnapshot.exists).thenReturn(false);

      // users collection
      when(
        () => mockFirestore.collection('users'),
      ).thenReturn(mockUsersCollection);
      when(() => mockUsersCollection.doc(user1)).thenReturn(mockUserDoc1);
      when(() => mockUsersCollection.doc(user2)).thenReturn(mockUserDoc2);

      when(() => mockUserDoc1.get()).thenAnswer((_) async => mockUserSnapshot1);
      when(() => mockUserDoc2.get()).thenAnswer((_) async => mockUserSnapshot2);

      when(() => mockUserSnapshot1.exists).thenReturn(true);
      when(() => mockUserSnapshot2.exists).thenReturn(true);

      when(
        () => mockUserSnapshot1.data(),
      ).thenReturn({'fullName': 'Alice', 'avatarUrl': ''});

      when(
        () => mockUserSnapshot2.data(),
      ).thenReturn({'fullName': 'Bob', 'avatarUrl': ''});

      when(() => mockChatRoomDoc.set(any())).thenAnswer((_) async => {});

      final result = await chatRepository.getOrCreateChatRoom(user1, user2);

      final fakeChatRoom = ChatRoomModel(
        id: '',
        participants: [],
        participantsName: {},
        participantsAvatar: {},
        lastReadTime: {},
      );
      expect(result.isRight(), true);
      expect(result.getOrElse((_) => fakeChatRoom).id, chatRoomId);
    });

    test('returns Left(Failure) if one user does not exist', () async {
      when(
        () => mockFirestore.collection('chatRooms'),
      ).thenReturn(mockChatRoomCollection);
      when(
        () => mockChatRoomCollection.doc(chatRoomId),
      ).thenReturn(mockChatRoomDoc);
      when(
        () => mockChatRoomDoc.get(),
      ).thenAnswer((_) async => mockRoomSnapshot);
      when(() => mockRoomSnapshot.exists).thenReturn(false);

      // users collection
      when(
        () => mockFirestore.collection('users'),
      ).thenReturn(mockUsersCollection);
      when(() => mockUsersCollection.doc(user1)).thenReturn(mockUserDoc1);
      when(() => mockUsersCollection.doc(user2)).thenReturn(mockUserDoc2);

      when(() => mockUserDoc1.get()).thenAnswer((_) async => mockUserSnapshot1);
      when(() => mockUserDoc2.get()).thenAnswer((_) async => mockUserSnapshot2);

      when(() => mockUserSnapshot1.exists).thenReturn(true);
      when(() => mockUserSnapshot2.exists).thenReturn(false); // user2 not found

      final result = await chatRepository.getOrCreateChatRoom(user1, user2);
      expect(result.isLeft(), true);
    });

    test('returns Left(Failure) on unexpected error', () async {
      when(
        () => mockFirestore.collection('chatRooms'),
      ).thenThrow(Exception('Unexpected'));

      final result = await chatRepository.getOrCreateChatRoom(user1, user2);
      expect(result.isLeft(), true);
    });
  });

  test('returns Right(true) if any document exists', () async {
    when(
      () => mockFirestore.collection('chatRooms'),
    ).thenReturn(mockChatRoomCollection);

    when(() => mockChatRoomCollection.doc(any())).thenReturn(mockChatRoomDoc);

    when(() => mockChatRoomDoc.get()).thenAnswer((_) async => mockRoomSnapshot);

    when(() => mockRoomSnapshot.exists).thenReturn(true);

    final result = await chatRepository.findExistingChatRoom([
      'room1',
      'room2',
    ]);

    expect(result.isRight(), true);
    expect(result.getOrElse((_) => false), true);
  });

  test('returns Right(false) if no documents exist', () async {
    when(
      () => mockFirestore.collection('chatRooms'),
    ).thenReturn(mockChatRoomCollection);

    when(() => mockChatRoomCollection.doc(any())).thenReturn(mockChatRoomDoc);

    when(() => mockChatRoomDoc.get()).thenAnswer((_) async => mockRoomSnapshot);

    when(() => mockRoomSnapshot.exists).thenReturn(false);

    final result = await chatRepository.findExistingChatRoom([
      'room1',
      'room2',
    ]);

    expect(result.isRight(), true);
    expect(result.getOrElse((_) => true), false);
  });

  test('returns Left(Failure) on exception', () async {
    when(
      () => mockFirestore.collection('chatRooms'),
    ).thenReturn(mockChatRoomCollection);

    when(
      () => mockChatRoomCollection.doc(any()),
    ).thenThrow(Exception('Firestore error'));

    final result = await chatRepository.findExistingChatRoom(['room1']);

    expect(result.isLeft(), true);
    result.match(
      (failure) => expect(
        failure.message,
        'Failed to find chat room existence. Please try again.',
      ),
      (_) => fail('Expected Left'),
    );
  });
}

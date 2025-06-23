// ignore_for_file: subtype_of_sealed_class
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/repositories/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockFirebaseStorage extends Mock implements FirebaseStorage {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockUploadTask extends Mock implements UploadTask {}

class MockTaskSnapshot extends Mock implements TaskSnapshot {}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

class FakeUserModel extends Fake implements UserModel {}

void main() {
  late FirebaseAuth mockAuth;
  late FirebaseFirestore mockFirestore;
  late FirebaseStorage mockStorage;
  late AuthRepository repository;

  setUpAll(() {
    registerFallbackValue(FakeUserModel());
  });

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    mockStorage = MockFirebaseStorage();

    repository = AuthRepository(
      auth: mockAuth,
      firestore: mockFirestore,
      firebaseStorage: mockStorage,
    );
  });

  group('signUp', () {
    test('returns right(UserModel) when successful', () async {
      final mockUserCredential = MockUserCredential();
      final mockUser = MockUser();

      when(
        () => mockAuth.createUserWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => mockUserCredential);

      when(() => mockUserCredential.user).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn('uid123');

      final result = await repository.signUp(
        fullName: 'John Doe',
        email: 'john@example.com',
        phoneNumber: '0123456789',
        password: 'password123',
      );

      expect(result.isRight(), true);
      expect(result.getRight().toNullable()!.uid, 'uid123');
    });

    test('returns left(Failure) when user is null', () async {
      final mockUserCredential = MockUserCredential();
      when(
        () => mockAuth.createUserWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => mockUserCredential);
      when(() => mockUserCredential.user).thenReturn(null);

      final result = await repository.signUp(
        fullName: 'John Doe',
        email: 'john@example.com',
        phoneNumber: '0123456789',
        password: 'password123',
      );

      expect(result.isLeft(), true);
    });

    test('returns left(Failure) when exception thrown', () async {
      when(
        () => mockAuth.createUserWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(Exception());

      final result = await repository.signUp(
        fullName: 'John Doe',
        email: 'john@example.com',
        phoneNumber: '0123456789',
        password: 'password123',
      );

      expect(result.isLeft(), true);
    });
  });

  group('signInWithEmailAndPassword', () {
    test('returns left(Failure) when exception thrown', () async {
      when(
        () => mockAuth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(Exception());

      final result = await repository.signInWithEmailAndPassword(
        email: 'john@example.com',
        password: 'password123',
      );

      expect(result.isLeft(), true);
    });
  });

  group('getUserData', () {
    test('returns left(Failure) when doc does not exist', () async {
      final mockSnapshot = MockDocumentSnapshot();
      final mockCollection = MockCollectionReference();
      final mockDoc = MockDocumentReference();

      when(() => mockFirestore.collection('users')).thenReturn(mockCollection);
      when(() => mockCollection.doc('uid123')).thenReturn(mockDoc);
      when(() => mockDoc.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.exists).thenReturn(false);

      final result = await repository.getUserData('uid123');
      expect(result.isLeft(), true);
    });

    test('returns left(Failure) on exception', () async {
      when(() => mockFirestore.collection('users')).thenThrow(Exception());

      final result = await repository.getUserData('uid123');
      expect(result.isLeft(), true);
    });
  });

  group('signOut', () {
    test('returns left(Failure) on exception', () async {
      when(() => mockAuth.signOut()).thenThrow(Exception());
      final result = await repository.signOut();
      expect(result.isLeft(), true);
    });
  });

  group('addFcmToken/removeFcmToken', () {
    test('addFcmToken success', () async {
      final mockCollection = MockCollectionReference();
      final mockDoc = MockDocumentReference();
      final user = MockUser();

      when(() => mockAuth.currentUser).thenReturn(user);
      when(() => user.uid).thenReturn('uid123');
      when(() => mockFirestore.collection('users')).thenReturn(mockCollection);
      when(() => mockCollection.doc('uid123')).thenReturn(mockDoc);
      when(() => mockDoc.update(any())).thenAnswer((_) async => {});

      final result = await repository.addFcmToken('abc');
      expect(result.isRight(), true);
    });

    test('removeFcmToken failure', () async {
      when(() => mockAuth.currentUser).thenThrow(Exception());
      final result = await repository.removeFcmToken('abc');
      expect(result.isLeft(), true);
    });
  });
}

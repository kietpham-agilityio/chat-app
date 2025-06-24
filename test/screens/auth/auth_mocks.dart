import 'package:chat_app/models/models.dart' show UserModel;
import 'package:chat_app/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth show User;
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUserModel extends Mock implements UserModel {}

class MockFirebaseUser extends Mock implements firebase_auth.User {}

class AuthMocks {
  static final mockFirebaseUser = MockFirebaseUser();

  static final mockUid = '1234567890';

  static final mockEmail = 'test@example.com';

  static final mockFullName = 'Test User';

  static final mockphoneNumber = '0123456789';

  static final mockPassword = 'password123';

  static final mockWrongPassword = 'wrongpassword';

  static final mockUserModel = UserModel(
    uid: mockUid,
    email: mockEmail,
    fullName: mockFullName,
    phoneNumber: mockphoneNumber,
    country: 'USA',
  );
}

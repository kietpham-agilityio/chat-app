import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:chat_app/core/utils/failure.dart';
import 'package:chat_app/core/utils/validations.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/repositories/auth_repository.dart';
import 'package:chat_app/screens/my_account/bloc/my_account_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class FakeUserModel extends Fake implements UserModel {}

class FakeFile extends Fake implements File {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

void main() {
  late MockAuthRepository authRepository;
  late MockFirebaseAuth firebaseAuth;
  late MockUser firebaseUser;

  setUpAll(() {
    registerFallbackValue(FakeUserModel());
    registerFallbackValue(FakeFile());
  });

  setUp(() {
    authRepository = MockAuthRepository();
    firebaseAuth = MockFirebaseAuth();
    firebaseUser = MockUser();

    when(() => firebaseAuth.currentUser).thenReturn(firebaseUser);
    when(() => firebaseUser.uid).thenReturn('123');
  });

  group('MyAccountBloc', () {
    blocTest<MyAccountBloc, MyAccountState>(
      'emits updated fullName when FullNameChangedEvent is added',
      build: () => MyAccountBloc(
        authRepository: authRepository,
        firebaseAuth: firebaseAuth,
      ),
      act: (bloc) => bloc.add(const FullNameChangedEvent('John Doe')),
      expect: () => [
        MyAccountState(
          fullName: FullName.pure('John Doe'),
          status: MyAccountStatus.success,
        ),
      ],
    );

    blocTest<MyAccountBloc, MyAccountState>(
      'validates fullName and emits updated isValidForm',
      build: () => MyAccountBloc(
        authRepository: authRepository,
        firebaseAuth: firebaseAuth,
      ),
      seed: () => MyAccountState(phoneNumber: PhoneNumber.dirty('0123456789')),
      act: (bloc) => bloc.add(const FullNameValidationEvent('John Doe')),
      expect: () => [
        MyAccountState(
          fullName: FullName.dirty('John Doe'),
          phoneNumber: PhoneNumber.dirty('0123456789'),
          isValidForm: false,
          status: MyAccountStatus.success,
        ),
      ],
    );

    blocTest<MyAccountBloc, MyAccountState>(
      'updates phoneNumber and emits updated isValidForm',
      build: () => MyAccountBloc(
        authRepository: authRepository,
        firebaseAuth: firebaseAuth,
      ),
      seed: () => MyAccountState(fullName: FullName.dirty('John Doe')),
      act: (bloc) => bloc.add(const PhoneNumberChangedEvent('0123456789')),
      expect: () => [
        MyAccountState(
          fullName: FullName.dirty('John Doe'),
          phoneNumber: PhoneNumber.pure('0123456789'),
          isValidForm: false,
          status: MyAccountStatus.success,
        ),
      ],
    );

    blocTest<MyAccountBloc, MyAccountState>(
      'validates phoneNumber and emits updated isValidForm',
      build: () => MyAccountBloc(
        authRepository: authRepository,
        firebaseAuth: firebaseAuth,
      ),
      seed: () => MyAccountState(fullName: FullName.dirty('John Doe')),
      act: (bloc) => bloc.add(const PhoneNumberValidationEvent('0123456789')),
      expect: () => [
        MyAccountState(
          fullName: FullName.dirty('John Doe'),
          phoneNumber: PhoneNumber.dirty('0123456789'),
          isValidForm: false,
          status: MyAccountStatus.success,
        ),
      ],
    );

    blocTest<MyAccountBloc, MyAccountState>(
      'emits loading and then success with initial values',
      build: () => MyAccountBloc(
        authRepository: authRepository,
        firebaseAuth: firebaseAuth,
      ),
      act: (bloc) => bloc.add(
        const InitialEvent(
          email: 'john@example.com',
          fullName: 'John Doe',
          phoneNumber: '0123456789',
          country: 'Vietnam',
          avatarUrl: 'https://avatar.png',
        ),
      ),
      expect: () => [
        const MyAccountState(status: MyAccountStatus.loading),
        MyAccountState(
          email: Email.pure('john@example.com'),
          fullName: FullName.pure('John Doe'),
          phoneNumber: PhoneNumber.pure('0123456789'),
          country: CountryInput.pure('Vietnam'),
          avatarUrl: 'https://avatar.png',
          isValidForm: false,
          status: MyAccountStatus.success,
        ),
      ],
    );

    blocTest<MyAccountBloc, MyAccountState>(
      'emits [loading, success] with initial state',
      build: () => MyAccountBloc(
        authRepository: authRepository,
        firebaseAuth: firebaseAuth,
      ),
      act: (bloc) => bloc.add(
        const InitialEvent(
          email: 'test@example.com',
          fullName: 'Test User',
          phoneNumber: '0123456789',
          country: 'Vietnam',
          avatarUrl: 'https://example.com/avatar.png',
        ),
      ),
      expect: () => [
        const MyAccountState(status: MyAccountStatus.loading),
        MyAccountState(
          email: Email.pure('test@example.com'),
          fullName: FullName.pure('Test User'),
          phoneNumber: PhoneNumber.pure('0123456789'),
          country: CountryInput.pure('Vietnam'),
          avatarUrl: 'https://example.com/avatar.png',
          isValidForm: false,
          status: MyAccountStatus.success,
        ),
      ],
    );

    blocTest<MyAccountBloc, MyAccountState>(
      'emits [success state] when CountryChangedEvent is added and value is different',
      build: () => MyAccountBloc(
        authRepository: authRepository,
        firebaseAuth: firebaseAuth,
      ),
      seed: () => MyAccountState(
        fullName: FullName.dirty('John Doe'),
        phoneNumber: PhoneNumber.dirty('123456'),
        country: CountryInput.dirty('USA'),
      ),
      act: (bloc) => bloc.add(const CountryChangedEvent('VietNam')),
      expect: () => [
        MyAccountState(
          fullName: FullName.dirty('John Doe'),
          phoneNumber: PhoneNumber.dirty('123456'),
          country: CountryInput.dirty('VietNam'),
          status: MyAccountStatus.success,
          isValidForm: false,
        ),
      ],
    );

    blocTest<MyAccountBloc, MyAccountState>(
      'no state emitted when CountryChangedEvent has the same value',
      build: () => MyAccountBloc(
        authRepository: authRepository,
        firebaseAuth: firebaseAuth,
      ),
      seed: () => MyAccountState(country: CountryInput.dirty('VietNam')),
      act: (bloc) => bloc.add(const CountryChangedEvent('VietNam')),
      expect: () => <MyAccountState>[],
    );

    blocTest<MyAccountBloc, MyAccountState>(
      'emits [countriesFetching, success] when CountryFetchingEvent is added',
      build: () => MyAccountBloc(
        authRepository: authRepository,
        firebaseAuth: firebaseAuth,
      ),
      act: (bloc) => bloc.add(const CountryFetchingEvent()),
      wait: const Duration(seconds: 2),
      expect: () => [
        const MyAccountState(status: MyAccountStatus.countriesFetching),
        const MyAccountState(
          countries: ['VietNam', 'USA'],
          status: MyAccountStatus.success,
        ),
      ],
    );

    blocTest<MyAccountBloc, MyAccountState>(
      'emits [loading, profileUpdated] when update is successful',
      build: () {
        when(
          () => authRepository.updateUserData(
            user: any(named: 'user'),
            avatar: any(named: 'avatar'),
          ),
        ).thenAnswer((_) async => const Right(unit));

        return MyAccountBloc(
          authRepository: authRepository,
          firebaseAuth: firebaseAuth,
        )..emit(
          MyAccountState(
            fullName: FullName.dirty('Test'),
            email: Email.dirty('test@example.com'),
            phoneNumber: PhoneNumber.dirty('0123456789'),
            isValidForm: true,
          ),
        );
      },
      act: (bloc) => bloc.add(UpdateUserInfoEvent()),
      expect: () => [
        MyAccountState(
          fullName: FullName.dirty('Test'),
          email: Email.dirty('test@example.com'),
          phoneNumber: PhoneNumber.dirty('0123456789'),
          isValidForm: true,
          status: MyAccountStatus.loading,
        ),
        MyAccountState(
          fullName: FullName.dirty('Test'),
          email: Email.dirty('test@example.com'),
          phoneNumber: PhoneNumber.dirty('0123456789'),
          isValidForm: false,
          status: MyAccountStatus.profileUpdated,
        ),
      ],
    );

    blocTest<MyAccountBloc, MyAccountState>(
      'emits [loading, failure] when update fails',
      build: () {
        when(
          () => authRepository.updateUserData(
            user: any(named: 'user'),
            avatar: any(named: 'avatar'),
          ),
        ).thenAnswer(
          (_) async =>
              Left(Failure('Failed to update user data. Please try again.')),
        );

        return MyAccountBloc(
          authRepository: authRepository,
          firebaseAuth: firebaseAuth,
        )..emit(
          MyAccountState(
            fullName: FullName.dirty('Test'),
            email: Email.dirty('test@example.com'),
            phoneNumber: PhoneNumber.dirty('0123456789'),
            isValidForm: true,
          ),
        );
      },
      act: (bloc) => bloc.add(UpdateUserInfoEvent()),
      expect: () => [
        MyAccountState(
          fullName: FullName.dirty('Test'),
          email: Email.dirty('test@example.com'),
          phoneNumber: PhoneNumber.dirty('0123456789'),
          isValidForm: true,
          status: MyAccountStatus.loading,
        ),
        MyAccountState(
          fullName: FullName.dirty('Test'),
          email: Email.dirty('test@example.com'),
          phoneNumber: PhoneNumber.dirty('0123456789'),
          isValidForm: true,
          status: MyAccountStatus.failure,
          errorMessage: 'Failed to update user data. Please try again.',
        ),
      ],
    );
  });
}

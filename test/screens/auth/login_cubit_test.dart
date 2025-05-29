import 'package:bloc_test/bloc_test.dart';
import 'package:chat_app/core/utils/validations.dart';
import 'package:chat_app/repositories/repositories.dart';
import 'package:chat_app/screens/auth/states/login_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_mocks.dart';

void main() {
  group('LoginCubit', () {
    late AuthRepository authRepository;

    setUp(() {
      authRepository = MockAuthRepository();
    });

    test('initial state is correct', () {
      expect(LoginCubit(authRepository).state, const LoginState());
    });

    blocTest<LoginCubit, LoginState>(
      'emits new email on emailChanged',
      build: () => LoginCubit(authRepository),
      act: (cubit) => cubit.emailChanged(AuthMocks.mockEmail),
      expect:
          () => [
            isA<LoginState>().having(
              (s) => s.email.value,
              'email',
              AuthMocks.mockEmail,
            ),
          ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits dirty email on emailValidation',
      build: () => LoginCubit(authRepository),
      act: (cubit) => cubit.emailValidation(AuthMocks.mockEmail),
      expect:
          () => [
            isA<LoginState>()
                .having((s) => s.email.value, 'email', AuthMocks.mockEmail)
                .having((s) => s.email.isPure, 'isPure', false),
          ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits dirty password on passwordChanged',
      build: () => LoginCubit(authRepository),
      act: (cubit) => cubit.passwordChanged(AuthMocks.mockPassword),
      expect:
          () => [
            isA<LoginState>()
                .having(
                  (s) => s.password.value,
                  'password',
                  AuthMocks.mockPassword,
                )
                .having((s) => s.password.isPure, 'isPure', false),
          ],
    );

    blocTest<LoginCubit, LoginState>(
      'toggles password visibility on passwordVisibilityChanged',
      build: () => LoginCubit(authRepository),
      act: (cubit) => cubit.passwordVisibilityChanged(),
      expect:
          () => [
            isA<LoginState>().having((s) => s.isObscured, 'isObscured', false),
          ],
    );

    blocTest<LoginCubit, LoginState>(
      'logInWithCredentials emits success when inputs are valid',
      build: () {
        final user = MockUserModel();

        when(
          () => authRepository.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => user);
        return LoginCubit(authRepository);
      },
      seed:
          () => LoginState(
            email: Email.dirty(AuthMocks.mockEmail),
            password: Password.dirty(AuthMocks.mockPassword),
          ),
      act: (cubit) => cubit.logInWithCredentials(),
      expect:
          () => [
            isA<LoginState>().having(
              (s) => s.status,
              'status',
              FormzSubmissionStatus.inProgress,
            ),
            isA<LoginState>().having(
              (s) => s.status,
              'status',
              FormzSubmissionStatus.success,
            ),
          ],
    );

    blocTest<LoginCubit, LoginState>(
      'logInWithCredentials emits failure with known error',
      build: () {
        when(
          () => authRepository.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(LogInWithEmailAndPasswordFailure('invalid credentials'));
        return LoginCubit(authRepository);
      },
      seed:
          () => LoginState(
            email: Email.dirty(AuthMocks.mockEmail),
            password: Password.dirty(AuthMocks.mockWrongPassword),
          ),
      act: (cubit) => cubit.logInWithCredentials(),
      expect: () => [],
    );

    blocTest<LoginCubit, LoginState>(
      'logInWithCredentials emits failure with unknown error on generic exception',
      build: () {
        when(
          () => authRepository.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(Exception('something went wrong'));
        return LoginCubit(authRepository);
      },
      seed:
          () => LoginState(
            email: Email.dirty(AuthMocks.mockEmail),
            password: Password.dirty(AuthMocks.mockPassword),
          ),
      act: (cubit) => cubit.logInWithCredentials(),
      expect:
          () => [
            isA<LoginState>().having(
              (s) => s.status,
              'status',
              FormzSubmissionStatus.inProgress,
            ),
            isA<LoginState>()
                .having(
                  (s) => s.status,
                  'status',
                  FormzSubmissionStatus.failure,
                )
                .having(
                  (s) => s.errorMessage,
                  'errorMessage',
                  'An unknown error occurred',
                ),
          ],
    );
    blocTest<LoginCubit, LoginState>(
      'logInWithCredentials emits failure with known error on known exception',
      build: () {
        when(
          () => authRepository.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(
          const LogInWithEmailAndPasswordFailure('invalid credentials'),
        );
        return LoginCubit(authRepository);
      },
      seed:
          () => LoginState(
            email: Email.dirty(AuthMocks.mockEmail),
            password: Password.dirty(AuthMocks.mockPassword),
          ),
      act: (cubit) => cubit.logInWithCredentials(),
      expect:
          () => [
            isA<LoginState>().having(
              (s) => s.status,
              'status',
              FormzSubmissionStatus.inProgress,
            ),
            isA<LoginState>()
                .having(
                  (s) => s.status,
                  'status',
                  FormzSubmissionStatus.failure,
                )
                .having(
                  (s) => s.errorMessage,
                  'errorMessage',
                  'invalid credentials',
                ),
          ],
    );

    blocTest<LoginCubit, LoginState>(
      'logInWithCredentials does nothing if form is invalid',
      build: () => LoginCubit(authRepository),
      act: (cubit) => cubit.logInWithCredentials(),
      expect: () => [],
    );
  });
}

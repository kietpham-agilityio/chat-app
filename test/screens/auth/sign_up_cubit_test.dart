import 'package:bloc_test/bloc_test.dart';
import 'package:chat_app/core/utils/validations.dart';
import 'package:chat_app/repositories/auth_repository.dart';
import 'package:chat_app/screens/auth/states/sign_up_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import 'auth_mocks.dart';

void main() {
  late AuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
  });

  group('SignUpCubit', () {
    test('initial state is correct', () {
      final cubit = SignUpCubit(authRepository);
      expect(cubit.state, const SignUpState());
    });

    blocTest<SignUpCubit, SignUpState>(
      'emits updated fullName when fullNameChanged is called',
      build: () => SignUpCubit(authRepository),
      act: (cubit) => cubit.fullNameChanged(AuthMocks.mockFullName),
      expect: () => [
        isA<SignUpState>().having(
          (s) => s.fullName.value,
          'fullname',
          AuthMocks.mockFullName,
        ),
      ],
    );

    blocTest<SignUpCubit, SignUpState>(
      'emits updated fullName when fullNameValidation is called',
      build: () => SignUpCubit(authRepository),
      act: (cubit) => cubit.fullNameValidation(AuthMocks.mockFullName),
      expect: () => [
        isA<SignUpState>().having(
          (s) => s.fullName.value,
          'fullName',
          AuthMocks.mockFullName,
        ),
      ],
    );

    blocTest<SignUpCubit, SignUpState>(
      'emits updated phoneNumber when phoneNumberChanged is called',
      build: () => SignUpCubit(authRepository),
      act: (cubit) => cubit.phoneNumberChanged(AuthMocks.mockphoneNumber),
      expect: () => [
        isA<SignUpState>().having(
          (s) => s.phoneNumber.value,
          'phoneNumber',
          AuthMocks.mockphoneNumber,
        ),
      ],
    );

    blocTest<SignUpCubit, SignUpState>(
      'emits updated phoneNumber when phoneNumberValidation is called',
      build: () => SignUpCubit(authRepository),
      act: (cubit) => cubit.phoneNumberValidation(AuthMocks.mockphoneNumber),
      expect: () => [
        isA<SignUpState>().having(
          (s) => s.phoneNumber.value,
          'phoneNumber',
          AuthMocks.mockphoneNumber,
        ),
      ],
    );

    blocTest<SignUpCubit, SignUpState>(
      'emits updated email when emailChanged is called',
      build: () => SignUpCubit(authRepository),
      act: (cubit) => cubit.emailChanged(AuthMocks.mockEmail),
      expect: () => [
        isA<SignUpState>().having(
          (s) => s.email.value,
          'email',
          AuthMocks.mockEmail,
        ),
      ],
    );

    blocTest<SignUpCubit, SignUpState>(
      'emits updated email when emailValidation is called',
      build: () => SignUpCubit(authRepository),
      act: (cubit) => cubit.emailValidation(AuthMocks.mockEmail),
      expect: () => [
        isA<SignUpState>().having(
          (s) => s.email.value,
          'email',
          AuthMocks.mockEmail,
        ),
      ],
    );

    blocTest<SignUpCubit, SignUpState>(
      'emits updated email when passwordChanged is called',
      build: () => SignUpCubit(authRepository),
      act: (cubit) => cubit.passwordChanged(AuthMocks.mockPassword),
      expect: () => [
        isA<SignUpState>().having(
          (s) => s.password.value,
          'password',
          AuthMocks.mockPassword,
        ),
      ],
    );

    blocTest<SignUpCubit, SignUpState>(
      'emits updated password.dirty, ConfirmedPassword.pure and confirmedPassword when passwordValidation is called',
      build: () => SignUpCubit(authRepository),
      seed: () => SignUpState(
        confirmedPassword: ConfirmedPassword.pure(
          password: '',
          value: AuthMocks.mockPassword,
        ),
      ),
      act: (cubit) => cubit.passwordValidation(AuthMocks.mockPassword),
      expect: () => [
        isA<SignUpState>()
            .having((s) => s.password.value, 'password', AuthMocks.mockPassword)
            .having((s) => s.password.isPure, 'isPure', false)
            .having(
              (s) => s.confirmedPassword.password,
              'confirmedPassword.password',
              AuthMocks.mockPassword,
            ),
      ],
    );

    blocTest<SignUpCubit, SignUpState>(
      'emits updated password.dirty, ConfirmedPassword.dirty and confirmedPassword when passwordValidation is called',
      build: () => SignUpCubit(authRepository),
      seed: () => SignUpState(
        confirmedPassword: ConfirmedPassword.dirty(
          password: '',
          value: AuthMocks.mockPassword,
        ),
      ),
      act: (cubit) => cubit.passwordValidation(AuthMocks.mockPassword),
      expect: () => [
        isA<SignUpState>()
            .having((s) => s.password.value, 'password', AuthMocks.mockPassword)
            .having((s) => s.password.isPure, 'isPure', false)
            .having(
              (s) => s.confirmedPassword.password,
              'confirmedPassword.password',
              AuthMocks.mockPassword,
            ),
      ],
    );

    blocTest<SignUpCubit, SignUpState>(
      'toggles isObscuredPassword when passwordVisibilityChanged is called',
      build: () => SignUpCubit(authRepository),
      act: (cubit) => cubit.passwordVisibilityChanged(),
      expect: () => [
        isA<SignUpState>().having(
          (s) => s.isObscuredPassword,
          'isObscuredPassword',
          false,
        ),
      ],
    );

    blocTest<SignUpCubit, SignUpState>(
      'emits updated confirmedPassword.pure when confirmedPasswordChanged is called',
      build: () => SignUpCubit(authRepository),
      seed: () => SignUpState(password: Password.pure(AuthMocks.mockPassword)),
      act: (cubit) => cubit.confirmedPasswordChanged(AuthMocks.mockPassword),
      expect: () => [
        isA<SignUpState>()
            .having(
              (s) => s.confirmedPassword.value,
              'value',
              AuthMocks.mockPassword,
            )
            .having((s) => s.confirmedPassword.isPure, 'isPure', true),
      ],
    );

    blocTest<SignUpCubit, SignUpState>(
      'emits updated confirmedPassword.dirty when confirmedPasswordValidation is called',
      build: () => SignUpCubit(authRepository),
      seed: () => SignUpState(password: Password.pure(AuthMocks.mockPassword)),
      act: (cubit) => cubit.confirmedPasswordValidation(AuthMocks.mockPassword),
      expect: () => [
        isA<SignUpState>()
            .having(
              (s) => s.confirmedPassword.value,
              'value',
              AuthMocks.mockPassword,
            )
            .having((s) => s.confirmedPassword.isPure, 'isPure', false),
      ],
    );

    blocTest<SignUpCubit, SignUpState>(
      'toggles isObscuredConfirmedPassword when confirmedPasswordVisibilityChanged is called',
      build: () => SignUpCubit(authRepository),
      act: (cubit) => cubit.confirmedPasswordVisibilityChanged(),
      expect: () => [
        isA<SignUpState>().having(
          (s) => s.isObscuredConfirmedPassword,
          'isObscuredConfirmedPassword',
          false,
        ),
      ],
    );

    // blocTest<SignUpCubit, SignUpState>(
    //   'signUpFormSubmitted emits success when inputs are valid',
    //   build: () {
    //     when(
    //       () => authRepository.signUp(
    //         fullName: any(named: 'fullName'),
    //         email: any(named: 'email'),
    //         phoneNumber: any(named: 'phoneNumber'),
    //         password: any(named: 'password'),
    //       ),
    //     ).thenAnswer((_) async => AuthMocks.mockUserModel);
    //     return SignUpCubit(authRepository);
    //   },
    //   seed:
    //       () => SignUpState(
    //         fullName: FullName.dirty(AuthMocks.mockFullName),
    //         email: Email.dirty(AuthMocks.mockEmail),
    //         phoneNumber: PhoneNumber.dirty(AuthMocks.mockphoneNumber),
    //         password: Password.dirty(AuthMocks.mockPassword),
    //         confirmedPassword: ConfirmedPassword.dirty(
    //           password: AuthMocks.mockPassword,
    //           value: AuthMocks.mockPassword,
    //         ),
    //       ),
    //   act: (cubit) => cubit.signUpFormSubmitted(),
    //   expect:
    //       () => [
    //         isA<SignUpState>().having(
    //           (s) => s.status,
    //           'status',
    //           FormzSubmissionStatus.inProgress,
    //         ),
    //         isA<SignUpState>().having(
    //           (s) => s.status,
    //           'status',
    //           FormzSubmissionStatus.success,
    //         ),
    //       ],
    // );

    // blocTest<SignUpCubit, SignUpState>(
    //   'signUpFormSubmitted emits failure on SignUpWithEmailAndPasswordFailure',
    //   build: () {
    //     when(
    //       () => authRepository.signUp(
    //         fullName: any(named: 'fullName'),
    //         email: any(named: 'email'),
    //         phoneNumber: any(named: 'phoneNumber'),
    //         password: any(named: 'password'),
    //       ),
    //     ).thenThrow(SignUpWithEmailAndPasswordFailure('email already used'));
    //     return SignUpCubit(authRepository);
    //   },
    //   seed: () => SignUpState(
    //     fullName: FullName.dirty(AuthMocks.mockFullName),
    //     email: Email.dirty(AuthMocks.mockEmail),
    //     phoneNumber: PhoneNumber.dirty(AuthMocks.mockphoneNumber),
    //     password: Password.dirty(AuthMocks.mockPassword),
    //     confirmedPassword: ConfirmedPassword.dirty(
    //       password: AuthMocks.mockPassword,
    //       value: AuthMocks.mockPassword,
    //     ),
    //   ),
    //   act: (cubit) => cubit.signUpFormSubmitted(),
    //   expect: () => [
    //     isA<SignUpState>().having(
    //       (s) => s.status,
    //       'status',
    //       FormzSubmissionStatus.inProgress,
    //     ),
    //     isA<SignUpState>()
    //         .having((s) => s.status, 'status', FormzSubmissionStatus.failure)
    //         .having(
    //           (s) => s.errorMessage,
    //           'errorMessage',
    //           'email already used',
    //         ),
    //   ],
    // );

    // blocTest<SignUpCubit, SignUpState>(
    //   'signUpFormSubmitted emits failure with unknown error on generic exception',
    //   build: () {
    //     when(
    //       () => authRepository.signUp(
    //         fullName: any(named: 'fullName'),
    //         email: any(named: 'email'),
    //         phoneNumber: any(named: 'phoneNumber'),
    //         password: any(named: 'password'),
    //       ),
    //     ).thenThrow(Exception('unexpected'));
    //     return SignUpCubit(authRepository);
    //   },
    //   seed: () => SignUpState(
    //     fullName: FullName.dirty(AuthMocks.mockFullName),
    //     email: Email.dirty(AuthMocks.mockEmail),
    //     phoneNumber: PhoneNumber.dirty(AuthMocks.mockphoneNumber),
    //     password: Password.dirty(AuthMocks.mockPassword),
    //     confirmedPassword: ConfirmedPassword.dirty(
    //       password: AuthMocks.mockPassword,
    //       value: AuthMocks.mockPassword,
    //     ),
    //   ),
    //   act: (cubit) => cubit.signUpFormSubmitted(),
    //   expect: () => [
    //     isA<SignUpState>().having(
    //       (s) => s.status,
    //       'status',
    //       FormzSubmissionStatus.inProgress,
    //     ),
    //     isA<SignUpState>()
    //         .having((s) => s.status, 'status', FormzSubmissionStatus.failure)
    //         .having(
    //           (s) => s.errorMessage,
    //           'errorMessage',
    //           'An unknown error occurred',
    //         ),
    //   ],
    // );
  });
}

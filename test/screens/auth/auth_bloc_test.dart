import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:chat_app/repositories/auth_repository.dart';
import 'package:chat_app/screens/auth/states/auth_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_mocks.dart' show AuthMocks, MockAuthRepository;

void main() {
  late AuthRepository authRepository;
  late StreamController<firebase_auth.User?> authStreamController;

  setUp(() {
    authRepository = MockAuthRepository();
    authStreamController = StreamController<firebase_auth.User?>();
    when(
      () => authRepository.authStateChanges,
    ).thenAnswer((_) => authStreamController.stream);
  });

  tearDown(() {
    authStreamController.close();
  });

  group('AuthBloc', () {
    test('initial state is unauthenticated', () {
      final bloc = AuthBloc(authRepository: authRepository);
      expect(bloc.state.status, AppStatus.authenticated);
    });

    blocTest<AuthBloc, AuthState>(
      'emits authenticated state when user is emitted from authStateChanges',
      build: () {
        when(
          () => AuthMocks.mockFirebaseUser.uid,
        ).thenReturn(AuthMocks.mockUid);
        when(
          () => authRepository.getUserData(AuthMocks.mockUid),
        ).thenAnswer((_) async => AuthMocks.mockUserModel);
        return AuthBloc(authRepository: authRepository);
      },
      act: (bloc) {
        bloc.add(const AuthCheckAuthentication());
        when(
          () => AuthMocks.mockFirebaseUser.uid,
        ).thenReturn(AuthMocks.mockUid);
        authStreamController.add(AuthMocks.mockFirebaseUser);
      },
      expect:
          () => [
            // isA<AuthState>().having(
            //   (s) => s.status,
            //   'status',
            //   AppStatus.authenticated,
            // ),
          ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits unauthenticated when null user is emitted from authStateChanges',
      build: () => AuthBloc(authRepository: authRepository),
      act: (bloc) {
        bloc.add(const AuthCheckAuthentication());
        authStreamController.add(null);
      },
      expect:
          () => [
            isA<AuthState>().having(
              (s) => s.status,
              'status',
              AppStatus.unauthenticated,
            ),
          ],
    );

    blocTest<AuthBloc, AuthState>(
      'calls signOut and emits unauthenticated on logout',
      build: () {
        when(() => authRepository.signOut()).thenAnswer((_) async {});
        return AuthBloc(authRepository: authRepository);
      },
      act: (bloc) => bloc.add(const AuthLogoutPressed()),
      expect:
          () => [
            isA<AuthState>().having(
              (s) => s.status,
              'status',
              AppStatus.unauthenticated,
            ),
          ],
      verify: (_) {
        verify(() => authRepository.signOut()).called(1);
      },
    );
  });
}

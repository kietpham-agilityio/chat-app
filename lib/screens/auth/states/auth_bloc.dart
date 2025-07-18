import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:chat_app/core/local_database/hive_local_db.dart';
import 'package:chat_app/models/models.dart' show UserModel;
import 'package:chat_app/repositories/repositories.dart' show AuthRepository;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthState()) {
    on<AuthCheckAuthentication>(
      _authCheckAuthentication,
      transformer: restartable(),
    );

    on<AuthLogoutPressed>(_onLogoutPressed);
  }

  final AuthRepository _authRepository;

  Future<void> _authCheckAuthentication(
    AuthCheckAuthentication event,
    Emitter<AuthState> emit,
  ) async {
    return emit.onEach(
      _authRepository.authStateChanges,
      onData: (user) async {
        if (user != null) {
          if (state.user?.uid != user.session?.user.id &&
              user.session != null) {
            final userData = await _authRepository.getUserData(
              user.session!.user.id,
            );

            userData.fold(
              (l) => emit(
                const AuthState(
                  user: UserModel.empty,
                  status: AuthStatus.unauthenticated,
                ),
              ),
              (r) => emit(AuthState(user: r, status: AuthStatus.authenticated)),
            );
          }
        } else {
          emit(
            const AuthState(
              user: UserModel.empty,
              status: AuthStatus.unauthenticated,
            ),
          );
        }
      },
      onError: (error, trace) => emit(
        const AuthState(
          user: UserModel.empty,
          status: AuthStatus.unauthenticated,
        ),
      ),
    );
  }

  void _onLogoutPressed(
    AuthLogoutPressed event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.signOut();
    await HiveLocalDb.instance.userBox.deleteUser();
    emit(
      const AuthState(
        user: UserModel.empty,
        status: AuthStatus.unauthenticated,
      ),
    );
  }
}

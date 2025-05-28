import 'package:chat_app/core/utils/validations.dart' show Email, Password;
import 'package:chat_app/repositories/repositories.dart'
    show AuthRepository, LogInWithEmailAndPasswordFailure;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart' show Formz, FormzSubmissionStatus;

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authRepository) : super(const LoginState());

  final AuthRepository _authRepository;

  void emailChanged(String email) {
    final newEmail = Email.pure(email);
    emit(
      state.copyWith(email: newEmail, status: FormzSubmissionStatus.success),
    );
  }

  void emailValidation(String email) => emit(
    state.copyWith(
      email: Email.dirty(email),
      status: FormzSubmissionStatus.success,
    ),
  );

  void passwordChanged(String password) => emit(
    state.copyWith(
      password: Password.dirty(password),
      status: FormzSubmissionStatus.success,
    ),
  );

  void passwordVisibilityChanged() {
    emit(
      state.copyWith(
        isObscured: !state.isObscured,
        status: FormzSubmissionStatus.success,
      ),
    );
  }

  Future<void> logInWithCredentials() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _authRepository.signInWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on LogInWithEmailAndPasswordFailure catch (e) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: 'An unknown error occurred',
        ),
      );
    }
  }
}

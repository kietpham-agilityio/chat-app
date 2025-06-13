import 'package:chat_app/core/utils/validations.dart' show Email, Password;
import 'package:chat_app/repositories/repositories.dart' show AuthRepository;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart' show Formz;

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authRepository) : super(const LoginState());

  final AuthRepository _authRepository;

  void emailChanged(String email) {
    final newEmail = Email.pure(email);
    emit(state.copyWith(email: newEmail, status: LoginStatus.success));
  }

  void emailValidation(String email) => emit(
    state.copyWith(email: Email.dirty(email), status: LoginStatus.success),
  );

  void passwordChanged(String password) => emit(
    state.copyWith(
      password: Password.dirty(password),
      status: LoginStatus.success,
    ),
  );

  void passwordVisibilityChanged() {
    emit(
      state.copyWith(
        isObscured: !state.isObscured,
        status: LoginStatus.success,
      ),
    );
  }

  Future<void> logInWithCredentials() async {
    if (!state.isValid) return;

    emit(state.copyWith(status: LoginStatus.inProgress));

    final res = await _authRepository.signInWithEmailAndPassword(
      email: state.email.value,
      password: state.password.value,
    );

    return res.fold(
      (l) => emit(
        state.copyWith(status: LoginStatus.failure, errorMessage: l.message),
      ),
      (r) => emit(state.copyWith(status: LoginStatus.success)),
    );
  }
}

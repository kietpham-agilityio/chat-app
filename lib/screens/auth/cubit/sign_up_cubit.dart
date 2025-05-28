import 'package:chat_app/core/utils/validations.dart'
    show ConfirmedPassword, Email, FullName, Password, PhoneNumber;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(const SignUpState());

  void fullNameChanged(String fullName) =>
      emit(state.copyWith(fullName: FullName.pure(fullName)));

  void fullNameValidation(String fullName) =>
      emit(state.copyWith(fullName: FullName.dirty(fullName)));

  void phoneNumberChanged(String phoneNumber) =>
      emit(state.copyWith(phoneNumber: PhoneNumber.pure(phoneNumber)));

  void phoneNumberValidation(String phoneNumber) =>
      emit(state.copyWith(phoneNumber: PhoneNumber.dirty(phoneNumber)));

  void emailChanged(String email) =>
      emit(state.copyWith(email: Email.pure(email)));

  void emailValidation(String email) =>
      emit(state.copyWith(email: Email.dirty(email)));

  void passwordChanged(String password) =>
      emit(state.copyWith(password: Password.pure(password)));

  void passwordValidation(String password) => emit(
    state.copyWith(
      password: Password.dirty(password),
      confirmedPassword:
          state.confirmedPassword.isPure
              ? ConfirmedPassword.pure(
                password: password,
                value: state.confirmedPassword.value,
              )
              : ConfirmedPassword.dirty(
                password: password,
                value: state.confirmedPassword.value,
              ),
    ),
  );

  void passwordVisibilityChanged() =>
      emit(state.copyWith(isObscuredPassword: !state.isObscuredPassword));

  void confirmedPasswordChanged(String confirmedPassword) => emit(
    state.copyWith(
      confirmedPassword: ConfirmedPassword.pure(
        password: state.password.value,
        value: confirmedPassword,
      ),
    ),
  );

  void confirmedPasswordValidation(String confirmedPassword) => emit(
    state.copyWith(
      confirmedPassword: ConfirmedPassword.dirty(
        password: state.password.value,
        value: confirmedPassword,
      ),
    ),
  );

  void confirmedPasswordVisibilityChanged() => emit(
    state.copyWith(
      isObscuredConfirmedPassword: !state.isObscuredConfirmedPassword,
    ),
  );
}

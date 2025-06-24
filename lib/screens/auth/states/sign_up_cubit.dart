import 'package:chat_app/core/utils/validations.dart'
    show
        ConfirmedPassword,
        CountryInput,
        Email,
        FullName,
        Password,
        PhoneNumber;
import 'package:chat_app/repositories/repositories.dart' show AuthRepository;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authRepository) : super(const SignUpState());

  final AuthRepository _authRepository;

  void fullNameChanged(String fullName) => emit(
    state.copyWith(
      fullName: FullName.pure(fullName),
      status: SignUpStatus.success,
    ),
  );

  void fullNameValidation(String fullName) => emit(
    state.copyWith(
      fullName: FullName.dirty(fullName),
      status: SignUpStatus.success,
    ),
  );

  void phoneNumberChanged(String phoneNumber) => emit(
    state.copyWith(
      phoneNumber: PhoneNumber.pure(phoneNumber),
      status: SignUpStatus.success,
    ),
  );

  void phoneNumberValidation(String phoneNumber) => emit(
    state.copyWith(
      phoneNumber: PhoneNumber.dirty(phoneNumber),
      status: SignUpStatus.success,
    ),
  );

  // void onCountryChanged(String value) {
  //   emit(
  //     state.copyWith(
  //       country: CountryInput.pure(value),
  //       status: SignUpStatus.success,
  //     ),
  //   );
  // }

  void onCountryChanged(String value) {
    if (state.country.value == value) return;
    final country = CountryInput.dirty(value);
    emit(state.copyWith(country: country, status: SignUpStatus.success));
  }

  Future<void> onFetchCountries() async {
    emit(state.copyWith(status: SignUpStatus.countriesFetching));
    await Future.delayed(Duration(seconds: 2));
    try {
      final items = ['VietNam', 'USA'];
      emit(state.copyWith(countries: items, status: SignUpStatus.success));
    } catch (_) {}
  }

  void emailChanged(String email) => emit(
    state.copyWith(email: Email.pure(email), status: SignUpStatus.success),
  );

  void emailValidation(String email) => emit(
    state.copyWith(email: Email.dirty(email), status: SignUpStatus.success),
  );

  void passwordChanged(String password) => emit(
    state.copyWith(
      password: Password.pure(password),
      status: SignUpStatus.success,
    ),
  );

  void passwordValidation(String password) => emit(
    state.copyWith(
      password: Password.dirty(password),
      confirmedPassword: state.confirmedPassword.isPure
          ? ConfirmedPassword.pure(
              password: password,
              value: state.confirmedPassword.value,
            )
          : ConfirmedPassword.dirty(
              password: password,
              value: state.confirmedPassword.value,
            ),
      status: SignUpStatus.success,
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
      status: SignUpStatus.success,
    ),
  );

  void confirmedPasswordValidation(String confirmedPassword) => emit(
    state.copyWith(
      confirmedPassword: ConfirmedPassword.dirty(
        password: state.password.value,
        value: confirmedPassword,
      ),
      status: SignUpStatus.success,
    ),
  );

  void confirmedPasswordVisibilityChanged() => emit(
    state.copyWith(
      isObscuredConfirmedPassword: !state.isObscuredConfirmedPassword,
      status: SignUpStatus.success,
    ),
  );

  Future<void> signUpFormSubmitted() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: SignUpStatus.loading));

    final res = await _authRepository.signUp(
      fullName: state.fullName.value,
      email: state.email.value,
      phoneNumber: state.phoneNumber.value,
      country: state.country.value,
      password: state.password.value,
    );

    res.fold(
      (l) => emit(
        state.copyWith(status: SignUpStatus.failure, errorMessage: l.message),
      ),
      (r) => emit(state.copyWith(status: SignUpStatus.success)),
    );
  }
}

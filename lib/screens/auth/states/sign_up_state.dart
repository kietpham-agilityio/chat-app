part of 'sign_up_cubit.dart';

final class SignUpState extends Equatable {
  const SignUpState({
    this.fullName = const FullName.pure(),
    this.email = const Email.pure(),
    this.phoneNumber = const PhoneNumber.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isObscuredPassword = true,
    this.isObscuredConfirmedPassword = true,
    this.errorMessage,
  });

  final FullName fullName;
  final Email email;
  final PhoneNumber phoneNumber;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final FormzSubmissionStatus status;
  final bool isObscuredPassword;
  final bool isObscuredConfirmedPassword;
  final String? errorMessage;

  SignUpState copyWith({
    FullName? fullName,
    Email? email,
    PhoneNumber? phoneNumber,
    Password? password,
    ConfirmedPassword? confirmedPassword,
    FormzSubmissionStatus? status,
    bool? isObscuredPassword,
    bool? isObscuredConfirmedPassword,
    String? errorMessage,
  }) {
    return SignUpState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      status: status ?? this.status,
      isObscuredPassword: isObscuredPassword ?? this.isObscuredPassword,
      isObscuredConfirmedPassword:
          isObscuredConfirmedPassword ?? this.isObscuredConfirmedPassword,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isValid =>
      confirmedPassword.value == password.value &&
      Formz.validate([
        fullName,
        phoneNumber,
        email,
        password,
        confirmedPassword,
      ]);

  @override
  List<Object?> get props => [
    fullName,
    phoneNumber,
    email,
    password,
    confirmedPassword,
    status,
    isObscuredPassword,
    isObscuredConfirmedPassword,
    errorMessage,
  ];
}

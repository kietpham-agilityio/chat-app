part of 'login_cubit.dart';

enum LoginStatus { initial, inProgress, success, failure }

final class LoginState extends Equatable {
  const LoginState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = LoginStatus.initial,
    this.isObscured = true,
    this.errorMessage,
  });

  final Email email;
  final Password password;
  final LoginStatus status;
  final String? errorMessage;
  final bool isObscured;

  LoginState copyWith({
    Email? email,
    Password? password,
    LoginStatus? status,
    bool? isObscured,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      isObscured: isObscured ?? this.isObscured,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isValid => Formz.validate([email, password]);

  @override
  List<Object?> get props => [
    email,
    password,
    status,
    errorMessage,
    isObscured,
  ];
}

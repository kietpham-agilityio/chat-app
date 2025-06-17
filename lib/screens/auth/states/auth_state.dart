part of 'auth_bloc.dart';

enum AuthStatus { authenticated, unauthenticated }

final class AuthState extends Equatable {
  const AuthState({
    UserModel? user,
    String? fcmToken,
    AuthStatus status = AuthStatus.unauthenticated,
  }) : this._(user: user, fcmToken: fcmToken, status: status);

  const AuthState._({
    this.user = UserModel.empty,
    this.fcmToken,
    this.status = AuthStatus.unauthenticated,
  });

  final UserModel? user;
  final String? fcmToken;
  final AuthStatus status;

  @override
  List<Object?> get props => [user, fcmToken, status];
}

part of 'auth_bloc.dart';

enum AppStatus { authenticated, unauthenticated }

final class AuthState extends Equatable {
  const AuthState({UserModel? user, String? fcmToken})
    : this._(user: user, fcmToken: fcmToken);

  const AuthState._({this.user = UserModel.empty, this.fcmToken});

  final String? fcmToken;
  final UserModel? user;

  @override
  List<Object?> get props => [user, fcmToken];
}

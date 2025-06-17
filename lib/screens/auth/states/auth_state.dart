part of 'auth_bloc.dart';

enum AuthStatus { authenticated, unauthenticated }

// final class AuthState extends Equatable {
//   const AuthState({UserModel? user, String? fcmToken})
//     : this._(user: user, fcmToken: fcmToken);

//   const AuthState._({this.user = UserModel.empty, this.fcmToken});

//   final String? fcmToken;
//   final UserModel? user;

//   @override
//   List<Object?> get props => [user, fcmToken];
// }

// final class AuthState extends Equatable {
//   const AuthState({UserModel user = UserModel.empty, String? fcmToken})
//     : this._(
//         status: user == UserModel.empty
//             ? AppStatus.unauthenticated
//             : AppStatus.authenticated,
//         user: user,
//         fcmToken: fcmToken,
//       );

//   const AuthState._({
//     required this.status,
//     this.user = UserModel.empty,
//     this.fcmToken,
//   });

//   final AppStatus status;
//   final UserModel user;
//   final String? fcmToken;

//   @override
//   List<Object> get props => [status, user];
// }

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

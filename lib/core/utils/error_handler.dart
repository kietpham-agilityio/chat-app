import 'package:chat_app/core/resources/l10n_generated/l10n.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ServerException implements Exception {
  const ServerException(this.message);

  final String message;
}

class CAError implements Exception {
  final String message;

  const CAError(this.message);

  @override
  String toString() => message;

  factory CAError.firebaseAuth(Object error) {
    if (error is FirebaseAuthException) {
      return CAError(_firebaseAuthMessage(error));
    }

    return CAError(error.toString());
  }

  static String _firebaseAuthMessage(FirebaseAuthException e) {
    return switch (e.code) {
      'user-disabled' => S.current.errorInvalidEmail,
      'email-already-in-use' => S.current.errorEmailAlreadyInUse,
      'user-not-found' => S.current.errorEmailNotFound,
      'wrong-password' => S.current.errorWrongPassword,
      'network-request-failed' =>
        'No Internet Connection. Check your network connection and try again.',
      _ => 'Authentication failed.',
    };
  }
}

class ErrorHandle implements Exception {
  const ErrorHandle(this.message);

  final String message;

  @override
  String toString() => message;
}

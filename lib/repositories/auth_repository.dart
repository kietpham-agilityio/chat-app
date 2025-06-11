import 'dart:developer' show log;
import 'dart:io';

import 'package:chat_app/core/local_database/hive_local_db.dart';
import 'package:chat_app/core/local_database/user_db_model.dart';
import 'package:chat_app/core/resources/l10n_generated/l10n.dart' show S;
import 'package:chat_app/models/models.dart' show UserModel;
import 'package:chat_app/repositories/base_repository.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuthException, User, FirebaseAuth;

class AuthRepository extends BaseRepository {
  Stream<User?> get authStateChanges => auth.authStateChanges();

  /// Signs up a new user with the given full name, email, phone number,
  /// and password.
  ///
  /// The phone number should be in the format `+1234567890`.
  ///
  /// If the email or phone number already exists, an [AppException] is
  /// thrown.
  ///
  /// If the user is successfully created, the user's data is saved to
  /// Firestore and the [UserModel] is returned.
  ///
  /// If there is an error, a [SignUpWithEmailAndPasswordFailure] is
  /// thrown.
  Future<UserModel> signUp({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      // Format the phone number to `+1234567890` format
      final formattedPhoneNumber = _formatPhoneNumber(phoneNumber);

      // Check if the email or phone number already exists
      final results = await Future.wait([
        checkEmailExists(email),
        checkPhoneExists(formattedPhoneNumber),
      ]);

      if (results[0]) {
        throw const AppException(
          "An account with the same email already exists",
        );
      }
      if (results[1]) {
        throw const AppException(
          "An account with the same phone already exists",
        );
      }

      // Create a new user with the given credentials
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user that was just created
      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw const SignUpWithEmailAndPasswordFailure();
      }

      // Create a new [UserModel] from the created user
      final user = UserModel(
        uid: firebaseUser.uid,
        fullName: fullName,
        email: email,
        phoneNumber: formattedPhoneNumber,
      );

      // Save the user's data to Firestore
      await saveUserData(user);

      // Return the created user
      return user;
    } on FirebaseAuthException catch (e) {
      // If there is an error, throw a [SignUpWithEmailAndPasswordFailure]
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (e) {
      // If there is an error that is not a [FirebaseAuthException], throw
      // a generic [SignUpWithEmailAndPasswordFailure]
      if (e is AppException) rethrow;
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  Future<UserModel> getUserData(String uid) async {
    try {
      final doc = await firestore.collection("users").doc(uid).get();

      if (!doc.exists) {
        throw const AppException("User data not found");
      }

      log('User id: ${doc.id}');

      final user = UserModel.fromFirestore(doc);

      await HiveLocalDb.instance.userBox.saveUser(
        UserDBModel.fromUserModel(user),
      );

      return user;
    } catch (e) {
      throw const AppException("Failed to get user data");
    }
  }

  /// Checks if an email already exists in the users collection.
  ///
  /// Returns `true` if the email exists, otherwise `false`.
  /// Logs any exceptions that occur during the process.
  Future<bool> checkEmailExists(String email) async {
    try {
      // Query the Firestore users collection for documents with the specified email
      final querySnapshot = await firestore
          .collection("users")
          .where("email", isEqualTo: email)
          .get();

      // Return true if any documents are found, indicating the email exists
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      // Log the error and return false if an exception occurs
      log("Error checking email: $e");
      return false;
    }
  }

  /// Checks if a phone number already exists in the users collection.
  ///
  /// Returns `true` if the phone number exists, otherwise `false`.
  /// Logs any exceptions that occur during the process.
  Future<bool> checkPhoneExists(String phoneNumber) async {
    try {
      // Format the input phone number to remove any whitespace characters
      final formattedPhoneNumber = _formatPhoneNumber(phoneNumber);

      // Query the Firestore users collection for documents with the specified phone number
      final querySnapshot = await firestore
          .collection("users")
          .where("phoneNumber", isEqualTo: formattedPhoneNumber)
          .get();

      // Return true if any documents are found, indicating the phone number exists
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      // Log the error and return false if an exception occurs
      log("Error checking phone: $e");
      return false;
    }
  }

  Future<void> saveUserData(UserModel user) async {
    try {
      await firestore.collection("users").doc(user.uid).set(user.toMap());
    } catch (e) {
      throw const AppException("Failed to save user data");
    }
  }

  Future<void> updateUserData({required UserModel user, File? avatar}) async {
    try {
      String? avatarUrl;
      if (avatar != null) {
        try {
          final ref = firebaseStorage.ref().child('avatars/${user.uid}.jpg');
          final task = await ref.putFile(avatar);
          final url = await task.ref.getDownloadURL();
          avatarUrl = url;
        } catch (e) {
          throw const AppException("Failed to upload avatar");
        }
      }

      final newUserData = UserModel(
        uid: user.uid,
        fullName: user.fullName,
        email: user.email,
        phoneNumber: user.phoneNumber,
        blockedUsers: user.blockedUsers,
        fcmToken: user.fcmToken,
        avatarUrl: avatarUrl,
      );

      await firestore
          .collection("users")
          .doc(user.uid)
          .update(newUserData.toMap());

      await HiveLocalDb.instance.userBox.updateUser(
        fullName: user.fullName,
        email: user.email,
        phoneNumber: user.phoneNumber,
        avatarUrl: avatarUrl,
        fcmToken: user.fcmToken,
      );
    } catch (e) {
      throw const AppException("Failed to save user data");
    }
  }

  String _formatPhoneNumber(String number) {
    return number.replaceAll(RegExp(r'\s+'), '');
  }

  Future<void> signOut() async {
    final user = await getUserData(FirebaseAuth.instance.currentUser!.uid);

    await updateUserData(user: user.copyWith(fcmToken: ''));

    await auth.signOut();
  }

  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw const LogInWithEmailAndPasswordFailure();
      }

      final userData = await getUserData(firebaseUser.uid);
      return userData;
    } on FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }
}

// Custom exception for general app-level errors
class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

/// Thrown if signing up with email and password fails.
///
/// Contains a human-readable message describing the error.
///
/// See [SignUpWithEmailAndPasswordFailure.fromCode] for creating an instance
/// from a [FirebaseAuthException.code].
class SignUpWithEmailAndPasswordFailure implements Exception {
  /// Creates a new [SignUpWithEmailAndPasswordFailure].
  ///
  /// If [message] is not provided, it defaults to
  /// 'An unknown exception occurred. Please try again.'.
  const SignUpWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred. Please try again.',
  ]);

  /// A human-readable message describing the error.
  final String message;

  /// Creates a new [SignUpWithEmailAndPasswordFailure] from a
  /// [FirebaseAuthException.code].
  factory SignUpWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'user-disabled':
        return SignUpWithEmailAndPasswordFailure(S.current.errorUserDisabled);
      case 'email-already-in-use':
        return SignUpWithEmailAndPasswordFailure(
          S.current.errorEmailAlreadyInUse,
        );
      case 'operation-not-allowed':
        return SignUpWithEmailAndPasswordFailure(
          S.current.errorOperationNotAllowed,
        );
      default:
        return SignUpWithEmailAndPasswordFailure(S.current.errorUnknown);
    }
  }
}

/// Thrown during the login process if a failure occurs.
///
/// Contains a human-readable message describing the error.
///
/// See [LogInWithEmailAndPasswordFailure.fromCode] for creating an instance
/// from a [FirebaseAuthException.code].
class LogInWithEmailAndPasswordFailure implements Exception {
  /// Creates a new [LogInWithEmailAndPasswordFailure].
  ///
  /// If [message] is not provided, it defaults to
  /// 'An unknown exception occurred. Please try again.'.
  const LogInWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred. Please try again.',
  ]);

  /// A human-readable message describing the error.
  final String message;

  /// Creates a new [LogInWithEmailAndPasswordFailure] from a
  /// [FirebaseAuthException.code].
  factory LogInWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'user-disabled':
        return LogInWithEmailAndPasswordFailure(S.current.errorUserDisabled);
      case 'user-not-found':
        return LogInWithEmailAndPasswordFailure(S.current.errorUserNotFound);
      case 'wrong-password':
        return LogInWithEmailAndPasswordFailure(S.current.errorWrongPassword);
      default:
        return LogInWithEmailAndPasswordFailure(S.current.errorUnknown);
    }
  }
}

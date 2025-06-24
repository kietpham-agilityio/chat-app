import 'dart:async';
import 'dart:developer' show log;
import 'dart:io';

import 'package:chat_app/core/local_database/hive_local_db.dart';
import 'package:chat_app/core/resources/l10n_generated/l10n.dart';
import 'package:chat_app/core/utils/failure.dart';
import 'package:chat_app/models/models.dart' show UserModel;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show User, FirebaseAuth;
import 'package:firebase_storage/firebase_storage.dart' show FirebaseStorage;
import 'package:fpdart/fpdart.dart';

class AuthRepository {
  const AuthRepository({
    required this.auth,
    required this.firestore,
    required this.firebaseStorage,
  });

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage firebaseStorage;

  Stream<User?> get authStateChanges => auth.authStateChanges();

  Future<Either<Failure, UserModel>> signUp({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required String country,
  }) async {
    final current = Platform.environment.containsKey('FLUTTER_TEST')
        ? S()
        : S.current;
    try {
      // Create a new user with the given credentials
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user that was just created
      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        return left(Failure(current.errorUserNotFound));
      }

      // Create a new [UserModel] from the created user
      final user = UserModel(
        uid: firebaseUser.uid,
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        country: country,
      );

      // Save the user's data to Firestore
      saveUserData(user);

      // Return the created user
      return right(user);
    } catch (_) {
      return left(Failure(current.errorFailedToSignUp));
    }
  }

  Future<Either<Failure, UserModel>> getUserData(String uid) async {
    final current = Platform.environment.containsKey('FLUTTER_TEST')
        ? S()
        : S.current;
    try {
      final doc = await firestore.collection('users').doc(uid).get();

      if (!doc.exists) {
        return left(Failure(current.errorUserDataNotFound));
      }

      log('User id: ${doc.id}');

      final user = UserModel.fromFirestore(doc);

      await HiveLocalDb.instance.userBox.updateUser(
        fullName: user.fullName,
        email: user.email,
        phoneNumber: user.phoneNumber,
        country: user.country,
        avatarUrl: user.avatarUrl,
      );

      return right(user);
    } catch (_) {
      return left(Failure(current.errorFailedToGetUserData));
    }
  }

  Future<Either<Failure, Unit>> saveUserData(UserModel user) async {
    final current = Platform.environment.containsKey('FLUTTER_TEST')
        ? S()
        : S.current;
    try {
      await firestore
          .collection('users')
          .doc(user.uid)
          .set(user.toMap())
          .timeout(const Duration(seconds: 5));
      return right(unit);
    } catch (_) {
      return left(Failure(current.errorFailedToGetUserData));
    }
  }

  Future<Either<Failure, Unit>> updateUserData({
    required UserModel user,
    File? avatar,
  }) async {
    final current = Platform.environment.containsKey('FLUTTER_TEST')
        ? S()
        : S.current;
    try {
      String? avatarUrl;
      if (avatar != null) {
        final ref = firebaseStorage.ref().child('avatars/${user.uid}.jpg');
        final task = await ref
            .putFile(avatar)
            .timeout(const Duration(seconds: 5));
        final url = await task.ref.getDownloadURL().timeout(
          const Duration(seconds: 5),
        );
        avatarUrl = url;
      }

      final newUserData = UserModel(
        uid: user.uid,
        fullName: user.fullName,
        email: user.email,
        phoneNumber: user.phoneNumber,
        country: user.country,
        blockedUsers: user.blockedUsers,
        fcmToken: user.fcmToken,
        avatarUrl: avatarUrl,
      );

      await firestore
          .collection('users')
          .doc(user.uid)
          .update(newUserData.toMap())
          .timeout(const Duration(seconds: 5));

      await HiveLocalDb.instance.userBox.updateUser(
        fullName: user.fullName,
        email: user.email,
        phoneNumber: user.phoneNumber,
        avatarUrl: avatarUrl,
      );

      // handle update user info in chatRooms(Client Side)
      final roomsSnapshot = await firestore
          .collection('chatRooms')
          .where('participants', arrayContains: user.uid)
          .get()
          .timeout(const Duration(seconds: 5));

      for (final doc in roomsSnapshot.docs) {
        final chatRoomRef = firestore.collection('chatRooms').doc(doc.id);

        await chatRoomRef
            .update({
              'participantsName.${user.uid}': user.fullName.toLowerCase(),
              if (avatarUrl != null)
                'participantsAvatar.${user.uid}': avatarUrl,
            })
            .timeout(const Duration(seconds: 5));
      }

      return right(unit);
    } catch (_) {
      return left(Failure(current.errorFailedToUpdateUserData));
    }
  }

  Future<Either<Failure, Unit>> signOut() async {
    final current = Platform.environment.containsKey('FLUTTER_TEST')
        ? S()
        : S.current;
    try {
      final userDB = await HiveLocalDb.instance.userBox.getUser();

      final fcmToken = userDB?.fcmToken;

      await removeFcmToken(fcmToken ?? '').timeout(const Duration(seconds: 5));

      await auth.signOut().timeout(const Duration(seconds: 5));

      return right(unit);
    } catch (_) {
      return left(Failure(current.errorFailedToSignOut));
    }
  }

  Future<Either<Failure, Unit>> addFcmToken(String token) async {
    final current = Platform.environment.containsKey('FLUTTER_TEST')
        ? S()
        : S.current;
    try {
      await firestore.collection('users').doc(auth.currentUser!.uid).update({
        'fcmToken': FieldValue.arrayUnion([token]),
      });
      return right(unit);
    } catch (_) {
      return left(Failure(current.errorFailedToAddFCMToken));
    }
  }

  Future<Either<Failure, Unit>> removeFcmToken(String token) async {
    final current = Platform.environment.containsKey('FLUTTER_TEST')
        ? S()
        : S.current;

    try {
      await firestore.collection('users').doc(auth.currentUser!.uid).update({
        'fcmToken': FieldValue.arrayRemove([token]),
      });
      return right(unit);
    } catch (_) {
      return left(Failure(current.errorFailedToRemoveFCMToken));
    }
  }

  Future<Either<Failure, UserModel>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final current = Platform.environment.containsKey('FLUTTER_TEST')
        ? S()
        : S.current;
    try {
      final userCredential = await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(const Duration(seconds: 5));

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        return left(Failure(current.errorUserNotFound));
      }

      final userData = await getUserData(
        firebaseUser.uid,
      ).timeout(const Duration(seconds: 5));

      return userData;
    } catch (_) {
      return left(Failure(current.errorFailedToSignIn));
    }
  }
}

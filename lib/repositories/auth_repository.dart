import 'dart:async';
import 'dart:developer' show log;
import 'dart:io';

import 'package:chat_app/core/local_database/hive_local_db.dart';
import 'package:chat_app/core/resources/l10n_generated/l10n.dart';
import 'package:chat_app/core/utils/failure.dart';
import 'package:chat_app/models/models.dart' show UserModel;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:firebase_storage/firebase_storage.dart' show FirebaseStorage;
import 'package:fpdart/fpdart.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  const AuthRepository({
    required this.auth,
    required this.firestore,
    required this.firebaseStorage,
    required this.supabase,
  });

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage firebaseStorage;
  final Supabase supabase;

  Stream<AuthState?> get authStateChanges =>
      supabase.client.auth.onAuthStateChange;

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
      final res = await supabase.client.auth.signUp(
        email: email,
        password: password,
      );

      // Get the user that was just created
      final supabaseUser = res.user;
      if (supabaseUser == null) {
        return left(Failure(current.errorUserNotFound));
      }

      // Create a new [UserModel] from the created user
      final user = UserModel(
        uid: supabaseUser.id,
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
      final doc = await supabase.client
          .from('profiles')
          .select()
          .eq('id', uid)
          .single();

      if (doc == {}) {
        return left(Failure(current.errorUserDataNotFound));
      }

      log('User id: ${doc['id']}');

      final user = UserModel.fromJson(doc);

      await HiveLocalDb.instance.userBox.updateUser(
        fullName: user.fullName,
        email: user.email,
        phoneNumber: user.phoneNumber,
        country: user.country,
        avatarUrl: user.avatarUrl,
      );

      return right(user);
    } catch (e) {
      return left(Failure(current.errorFailedToGetUserData));
    }
  }

  Future<Either<Failure, Unit>> saveUserData(UserModel user) async {
    final current = Platform.environment.containsKey('FLUTTER_TEST')
        ? S()
        : S.current;
    try {
      await supabase.client.from('profiles').insert(user.toMap()).select();

      return right(unit);
    } catch (e) {
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
      final supabase = Supabase.instance.client;

      String? avatarUrl;

      // 1. Upload avatar if provided
      if (avatar != null) {
        final fileExt = p.extension(avatar.path);
        final fileName = 'avatar$fileExt';
        final filePath = '${user.uid}/$fileName';
        final fileBytes = await avatar.readAsBytes();

        final contentType = lookupMimeType(avatar.path) ?? 'image/jpeg';

        await supabase.storage
            .from('avatars')
            .uploadBinary(
              filePath,
              fileBytes,
              fileOptions: FileOptions(upsert: true, contentType: contentType),
            );

        avatarUrl = supabase.storage.from('avatars').getPublicUrl(filePath);
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

      await supabase
          .from('profiles')
          .update(newUserData.toMap())
          .eq('id', user.uid);

      // 4. Update Hive local
      await HiveLocalDb.instance.userBox.updateUser(
        fullName: user.fullName,
        email: user.email,
        phoneNumber: user.phoneNumber,
        avatarUrl: avatarUrl,
      );

      return right(unit);
    } catch (e, _) {
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

      await removeFcmToken(fcmToken ?? '');

      await supabase.client.auth.signOut();

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
      final response = await supabase.client
          .from('profiles')
          .select('fcm_tokens')
          .eq('id', supabase.client.auth.currentUser?.id ?? '')
          .single();

      final List<dynamic> tokens = response['fcm_tokens'] ?? [];

      if (!tokens.contains(token)) {
        tokens.add(token);

        await supabase.client
            .from('profiles')
            .update({'fcm_tokens': tokens})
            .eq('id', supabase.client.auth.currentUser?.id ?? '');
      }

      return right(unit);
    } catch (e) {
      return left(Failure(current.errorFailedToAddFCMToken));
    }
  }

  Future<Either<Failure, Unit>> removeFcmToken(String token) async {
    final current = Platform.environment.containsKey('FLUTTER_TEST')
        ? S()
        : S.current;

    try {
      final response = await supabase.client
          .from('profiles')
          .select('fcm_tokens')
          .eq('id', supabase.client.auth.currentUser?.id ?? '')
          .single();

      final List<dynamic> tokens = response['fcm_tokens'] ?? [];

      if (tokens.contains(token)) {
        tokens.remove(token);

        await supabase.client
            .from('profiles')
            .update({'fcm_tokens': tokens})
            .eq('id', supabase.client.auth.currentUser?.id ?? '');
      }

      return right(unit);
    } catch (e) {
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
      final res = await supabase.client.auth.signInWithPassword(
        password: password,
        email: email,
      );

      final supabaseUser = res.user;
      if (supabaseUser == null) {
        return left(Failure(current.errorUserNotFound));
      }

      final userData = await getUserData(supabaseUser.id);

      return userData;
    } catch (e) {
      return left(Failure(current.errorFailedToSignIn));
    }
  }
}

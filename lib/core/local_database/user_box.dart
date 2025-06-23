import 'package:chat_app/core/local_database/user_db_model.dart';
import 'package:hive/hive.dart';

abstract class UserBox {
  Future<void> createEmptyUser();
  Future<UserDBModel?> getUser();
  Future<void> updateUser({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? avatarUrl,
    String? country,
    String? fcmToken,
  });
  Future<void> deleteUser();
  Future<void> clear();
}

class UserBoxImpl implements UserBox {
  final Box<UserDBModel> box;

  UserBoxImpl(this.box);

  static const _userKey = 'userBox';

  @override
  Future<void> createEmptyUser() async {
    await box.put(_userKey, UserDBModel.empty());
  }

  @override
  Future<UserDBModel?> getUser() async {
    final a = box.get(_userKey);
    return a;
  }

  @override
  Future<void> updateUser({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? avatarUrl,
    String? country,
    String? fcmToken,
  }) async {
    final userBox = Hive.box<UserDBModel>('userBox');

    if (userBox.isEmpty) return;

    final user = userBox.getAt(0);

    if (user == null) return;

    bool hasChanged = false;

    if (fullName != null && fullName != user.fullName) {
      user.fullName = fullName;
      hasChanged = true;
    }

    if (email != null && email != user.email) {
      user.email = email;
      hasChanged = true;
    }

    if (phoneNumber != null && phoneNumber != user.phoneNumber) {
      user.phoneNumber = phoneNumber;
      hasChanged = true;
    }

    if (country != null && country != user.country) {
      user.country = country;
      hasChanged = true;
    }

    if (avatarUrl != null && avatarUrl != user.avatarUrl) {
      user.avatarUrl = avatarUrl;
      hasChanged = true;
    }

    if (fcmToken != null && fcmToken != user.fcmToken) {
      user.fcmToken = fcmToken;
      hasChanged = true;
    }

    if (hasChanged) {
      await user.save();
    }
  }

  @override
  Future<void> deleteUser() async {
    await updateUser(
      fullName: '',
      email: '',
      phoneNumber: '',
      avatarUrl: '',
      fcmToken: '',
    );
  }

  @override
  Future<void> clear() async {
    await box.clear();
  }
}

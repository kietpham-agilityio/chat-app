import 'package:chat_app/core/local_database/user_db_model.dart';
import 'package:chat_app/models/models.dart' show UserModel;
import 'package:hive/hive.dart';

abstract class UserBox {
  Future<void> saveUser(UserDBModel user);
  Future<UserDBModel?> getUser();
  Future<void> updateUser(UserModel userModel);
  Future<void> deleteUser();
  Future<void> clear();
}

class UserBoxImpl implements UserBox {
  final Box<UserDBModel> box;

  UserBoxImpl(this.box);

  static const _userKey = 'userBox';

  @override
  Future<void> saveUser(UserDBModel user) async {
    await box.put(_userKey, user);
  }

  @override
  Future<UserDBModel?> getUser() async {
    return box.get(_userKey);
  }

  @override
  Future<void> updateUser(UserModel userModel) async {
    final userBox = Hive.box<UserDBModel>('userBox');

    if (userBox.isEmpty) return;

    final user = userBox.getAt(0);

    if (user == null) return;

    bool hasChanged = false;

    if (userModel.fullName != user.fullName) {
      user.fullName = userModel.fullName;
      hasChanged = true;
    }

    if (userModel.email != user.email) {
      user.email = userModel.email;
      hasChanged = true;
    }

    if (userModel.phoneNumber != user.phoneNumber) {
      user.phoneNumber = userModel.phoneNumber;
      hasChanged = true;
    }

    if (userModel.avatarUrl != null && userModel.avatarUrl != user.avatarUrl) {
      user.avatarUrl = userModel.avatarUrl!;
      hasChanged = true;
    }

    if (hasChanged) {
      await user.save();
    }
  }

  @override
  Future<void> deleteUser() async {
    await box.delete(_userKey);
  }

  @override
  Future<void> clear() async {
    await box.clear();
  }
}

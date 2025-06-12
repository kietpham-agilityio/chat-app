import 'package:chat_app/core/local_database/user_box.dart';
import 'package:chat_app/core/local_database/user_db_model.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveLocalDb {
  HiveLocalDb._internal();

  static final HiveLocalDb _instance = HiveLocalDb._internal();
  static HiveLocalDb get instance => _instance;

  static late final UserBox _userBox;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);

    Hive.registerAdapter(UserDBModelAdapter());

    final userBox = await Hive.openBox<UserDBModel>('userBox');

    _userBox = UserBoxImpl(userBox);
    if (userBox.values.isEmpty) {
      _userBox.createEmptyUser();
    }
  }

  UserBox get userBox => _userBox;

  Future<void> clearAll() async {
    await _userBox.clear();
  }

  Future<void> close() async {
    await Hive.close();
  }
}

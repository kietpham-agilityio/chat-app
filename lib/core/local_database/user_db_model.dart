import 'package:chat_app/models/models.dart' show UserModel;
import 'package:hive/hive.dart';

part 'user_db_model.g.dart';

@HiveType(typeId: 0)
class UserDBModel extends HiveObject {
  @HiveField(0)
  String uid;

  @HiveField(1)
  String fullName;

  @HiveField(2)
  String email;

  @HiveField(3)
  String phoneNumber;

  @HiveField(4)
  String country;

  @HiveField(5)
  String? avatarUrl;

  @HiveField(6)
  String? fcmToken;

  UserDBModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.country,
    this.avatarUrl,
    this.fcmToken,
  });

  factory UserDBModel.fromUserModel(UserModel userModel) {
    return UserDBModel(
      uid: userModel.uid,
      fullName: userModel.fullName,
      email: userModel.email,
      phoneNumber: userModel.phoneNumber,
      country: userModel.country,
      avatarUrl: userModel.avatarUrl,
    );
  }

  factory UserDBModel.empty() {
    return UserDBModel(
      uid: '',
      fullName: '',
      email: '',
      phoneNumber: '',
      country: '',
    );
  }
}

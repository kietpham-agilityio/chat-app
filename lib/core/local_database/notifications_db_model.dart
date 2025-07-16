import 'package:hive/hive.dart';

part 'notifications_db_model.g.dart';

@HiveType(typeId: 1)
class NotificationsDBModel extends HiveObject {
  NotificationsDBModel({
    this.currentChattingWithId = '',
    this.isNotificationEnabled,
  });

  @HiveField(0)
  String currentChattingWithId;

  @HiveField(1)
  bool? isNotificationEnabled;
}

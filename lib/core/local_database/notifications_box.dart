import 'dart:developer';

import 'package:chat_app/core/local_database/notifications_db_model.dart';
import 'package:hive/hive.dart';

abstract class NotificationsBox {
  Future<void> initial();

  Future<void> editBox({
    String? currentChattingWithId,
    bool? isNotificationEnabled,
  });

  Future<NotificationsDBModel?> getNotificationsBox();
}

class NotificationsBoxImpl implements NotificationsBox {
  NotificationsBoxImpl(this.box);

  final Box<NotificationsDBModel> box;

  static const _notifsKey = 'notificationsBox';

  @override
  Future<void> initial() async {
    log('NotificationsBox initial');
    await box.put(_notifsKey, NotificationsDBModel());
  }

  @override
  Future<void> editBox({
    String? currentChattingWithId,
    bool? isNotificationEnabled,
  }) async {
    final object = box.getAt(0);

    if (object == null) return;

    bool hasChanged = false;

    if (currentChattingWithId != null &&
        currentChattingWithId != object.currentChattingWithId) {
      object.currentChattingWithId = currentChattingWithId;
      hasChanged = true;
    }

    if (isNotificationEnabled != null &&
        isNotificationEnabled != object.isNotificationEnabled) {
      object.isNotificationEnabled = isNotificationEnabled;
      hasChanged = true;
    }

    if (hasChanged) {
      await object.save();
    }
  }

  @override
  Future<NotificationsDBModel?> getNotificationsBox() async {
    final object = box.get(_notifsKey);
    return object;
  }
}

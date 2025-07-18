import 'dart:developer';

import 'package:chat_app/core/local_database/hive_local_db.dart';
import 'package:chat_app/core/notifications/notifications_service.dart';
import 'package:chat_app/screens/profile/cubit/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this.hiveLocalDb) : super(const ProfileState());

  final HiveLocalDb hiveLocalDb;

  void fetchNotification() async {
    emit(state.copyWith(status: ProfileStatus.loading));
    log('State: ${state.status.name}');

    await Future.delayed(const Duration(seconds: 1), () async {
      bool isAllowed = await NotificationsService.awesomeNotifications
          .isNotificationAllowed();

      final notificationsBox = await hiveLocalDb.notificationsBox
          .getNotificationsBox();

      if (isAllowed) {
        emit(
          state.copyWith(
            isNotificationEnabled:
                notificationsBox?.isNotificationEnabled ?? false,
            status: ProfileStatus.success,
          ),
        );
        log('State: ${state.status.name}');
      } else {
        emit(
          state.copyWith(
            isNotificationEnabled: isAllowed,
            status: ProfileStatus.success,
          ),
        );
        log('State: ${state.status.name}');
      }
    });
  }

  void onPushNotificationToggleChanged(bool value) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    final status = await Permission.notification.status;

    if (status.isPermanentlyDenied || status.isDenied) {
      emit(state.copyWith(status: ProfileStatus.openSettings));
      return;
    }

    await hiveLocalDb.notificationsBox.editBox(isNotifsEnabledInApp: value);
    emit(
      state.copyWith(
        isNotificationEnabled: value,
        status: ProfileStatus.success,
      ),
    );
  }
}

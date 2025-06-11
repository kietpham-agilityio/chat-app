import 'dart:async';
import 'dart:developer' show log;
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:chat_app/core/notifications/notifications_controller.dart';
import 'package:chat_app/core/notifications/notifications_model.dart'
    show
        NotificationEntity,
        NotificationResponseData,
        NotificationsResponseEntity,
        ReplyNotification,
        NotificationType;
import 'package:chat_app/core/notifications/notifications_setup.dart';
import 'package:chat_app/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationsService {
  static NotificationEntity entity = NotificationEntity.initialize();

  static AwesomeNotifications awesomeNotifications = AwesomeNotifications();
  static AwesomeNotificationsFcm awesomeFCM = AwesomeNotificationsFcm();

  Future<void> initialize(AuthRepository authRepository) async {
    await _setupNotification();
    await _requestNotificationPermission();
    await _setupFCM();
    await getToken(authRepository);
    await awesomeNotifications.setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
    );
  }

  Future<void> _setupNotification() async {
    await awesomeNotifications.initialize(null, [
      NotificationChannel(
        channelKey: NotificationSetup.channelKey,
        channelName: NotificationSetup.channelName,
        channelDescription: NotificationSetup.channelDescription,
        playSound: true,
        importance: NotificationImportance.High,
        defaultPrivacy: NotificationPrivacy.Private,
        soundSource: 'resource://raw/notifications',
      ),
    ]);
  }

  NotificationsService configure({
    FutureOr<void> Function(NotificationsResponseEntity)? onMessageOpenedApp,
  }) {
    entity.setHandlers(onMessageOpenedApp: onMessageOpenedApp);
    return this;
  }

  Future<void> _setupFCM() async {
    await awesomeFCM.initialize(
      onFcmTokenHandle: myFcmTokenHandle,
      onFcmSilentDataHandle: mySilentDataHandle,
      onNativeTokenHandle: myNativeTokenHandle,
    );
  }

  Future<void> _requestNotificationPermission() async {
    bool isAllowed = await awesomeNotifications.isNotificationAllowed();
    if (!isAllowed) {
      // show a dialog to ask for permission
      awesomeNotifications.requestPermissionToSendNotifications();
    }
  }

  Future<void> getToken(AuthRepository authRepository) async {
    if (Platform.isAndroid) {
      String? token = await awesomeFCM.requestFirebaseAppToken();
      log('Token: $token');

      final user = await authRepository.getUserData(
        FirebaseAuth.instance.currentUser!.uid,
      );

      await authRepository.updateUserData(user: user.copyWith(fcmToken: token));
    }
  }

  // when receiving FCM token
  @pragma('vm:entry-point')
  static Future<void> myFcmTokenHandle(String token) async {
    log('FCM Token: $token');
  }

  // when receiving FCM silent data
  @pragma('vm:entry-point')
  static Future<void> mySilentDataHandle(FcmSilentData silentData) async {
    log('Silent Data: ${silentData.data}');
  }

  // when receiving native token
  @pragma('vm:entry-point')
  static Future<void> myNativeTokenHandle(String token) async {
    log('Native Token: $token');
  }
}

class NotificationHandler {
  static void handleTapNavigate(
    Map<String, dynamic> data,
    NotificationEntity entity,
  ) {
    final response = NotificationResponseData.fromJson(data);
    final type = response.type ?? '';

    if (type.isNotEmpty) {
      entity.onMessageOpenedApp?.call(
        NotificationsResponseEntity(
          type: type,
          accountId: response.accountId ?? '',
          accountName: response.accountName ?? '',
        ),
      );
    }
  }

  static void handleTapReply(
    Map<String, dynamic> data,
    NotificationEntity entity,
  ) {
    final response = NotificationResponseData.fromJson(data);
    final type = response.type ?? '';

    if (type.isNotEmpty) {
      entity.onReply?.call(
        ReplyNotification(replyText: type, accountId: response.accountId ?? ''),
      );
    }
  }

  static void navigate({
    required NotificationsResponseEntity notification,
    void Function(NotificationsResponseEntity)? onChatDetailsRedirect,
  }) {
    try {
      switch (notification.type) {
        case NotificationType.chatDetails:
          onChatDetailsRedirect?.call(notification);
          break;
        default:
          log('Unknown notification type: ${notification.type}');
      }
    } catch (e) {
      log('Navigation error: $e');
    }
  }
}

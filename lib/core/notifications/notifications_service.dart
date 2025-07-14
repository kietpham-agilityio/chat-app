import 'dart:async';
import 'dart:convert';
import 'dart:developer' show log;
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:chat_app/core/local_database/hive_local_db.dart';
import 'package:chat_app/core/notifications/notifications_model.dart'
    show
        NotificationEntity,
        NotificationResponseData,
        NotificationsResponseEntity,
        ReplyNotification,
        NotificationType;
import 'package:chat_app/core/notifications/notifications_setup.dart';
import 'package:chat_app/models/chat_message_model.dart';
import 'package:chat_app/repositories/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
class NotificationsService {
  static NotificationEntity entity = NotificationEntity.initialize();

  static AwesomeNotifications awesomeNotifications = AwesomeNotifications();

  static AwesomeNotificationsFcm awesomeFCM = AwesomeNotificationsFcm();

  static int badgeCount = 0;

  Future<void> initialize(AuthRepository authRepository) async {
    await _setupNotification();
    await _requestNotificationPermission();
    await _setupFCM();
    await getToken(authRepository);
  }

  static Future<void> setNotificationListeners() async {
    await awesomeNotifications.setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
    );
  }

  Future<void> _setupNotification() async {
    await awesomeNotifications.initialize(
      null,
      [
        NotificationChannel(
          channelKey: NotificationSetup.channelKey,
          channelName: NotificationSetup.channelName,
          channelDescription: NotificationSetup.channelDescription,
          channelGroupKey: NotificationSetup.channelGroupKey,
          playSound: true,
          importance: NotificationImportance.High,
          defaultPrivacy: NotificationPrivacy.Private,
          soundSource: 'resource://raw/notifications',
          channelShowBadge: true,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: NotificationSetup.channelGroupKey,
          channelGroupName: NotificationSetup.channelGroupName,
        ),
      ],
      debug: true,
    );
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
      // licenseKeys: null,
      debug: true,
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

      final userDB = await HiveLocalDb.instance.userBox.getUser();

      if (userDB?.fcmToken != token) {
        await authRepository.addFcmToken(token);
        await HiveLocalDb.instance.userBox.updateUser(fcmToken: token);
      }
    }
  }

  // when receiving FCM token
  @pragma('vm:entry-point')
  static Future<void> myFcmTokenHandle(String token) async {
    log('FCM Token Handle: $token');
  }

  // when receiving FCM silent data
  @pragma('vm:entry-point')
  static Future<void> mySilentDataHandle(FcmSilentData silentData) async {
    log('Silent Data: ${silentData.data}');
    final data = silentData.data;

    log(
      '[FCM Silent] Type: ${data?['type']}, accountId: ${data?['accountId']}, accountName: ${data?['accountName']}',
    );
    final prefs = await SharedPreferences.getInstance();
    log(
      'current_chatting_user_id: ${prefs.getString('current_chatting_user_id') ?? ''}',
    );

    if (silentData.createdLifeCycle == NotificationLifeCycle.Foreground &&
        (prefs.getString('current_chatting_user_id') ?? '') ==
            data?['accountId']) {
      return;
    }

    List<NotificationActionButton>? actionButtons;

    try {
      final actionBtnsRaw = data?['actionBtns'];
      if (actionBtnsRaw != null && actionBtnsRaw.isNotEmpty) {
        final decoded = jsonDecode(actionBtnsRaw);

        if (decoded is List) {
          actionButtons = decoded.map<NotificationActionButton>((item) {
            return NotificationActionButton(
              key: item['key'],
              label: item['label'],
              requireInputText: item['requireInputText'] ?? false,
              autoDismissible: item['autoDismissible'] ?? true,
              actionType: item['actionType'] == 'SilentAction'
                  ? ActionType.SilentAction
                  : ActionType.Default,
            );
          }).toList();
        }
      }
    } catch (e, st) {
      log('[FCM Silent] Failed to parse actionBtns: $e\n$st');
    }

    await awesomeNotifications.createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: NotificationSetup.channelKey,
        title: data?['title'],
        body: data?['body'],
        payload: {
          'accountId': data?['accountId'],
          'type': data?['type'],
          'accountName': data?['accountName'],
        },
        wakeUpScreen: true,
      ),
      actionButtons: actionButtons,
    );
  }

  // when receiving native token
  @pragma('vm:entry-point')
  static Future<void> myNativeTokenHandle(String token) async {
    log('Native Token Handle: $token');
  }

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    await Firebase.initializeApp();
    log('Received Action: ${receivedAction.toMap()}');
    switch (receivedAction.buttonKeyPressed) {
      case 'NAVIGATE':
        final data = receivedAction.payload ?? {};
        NotificationHandler.handleTapNavigate(data, entity);
        log('Navigate: ${data['type']}');
        break;
      case 'REPLY':
        final replyText = receivedAction.buttonKeyInput;
        log('Reply: $replyText');
        final receiverId = receivedAction.payload?['accountId'];
        final senderId = FirebaseAuth.instance.currentUser?.uid;

        if (replyText.isNotEmpty && receiverId != null && senderId != null) {
          final users = [senderId, receiverId]..sort();
          final chatRoomId = users.join("_");

          final batch = FirebaseFirestore.instance.batch();

          final chatroom = FirebaseFirestore.instance.collection("chatRooms");

          final messageRef = chatroom.doc(chatRoomId).collection('messages');

          final messageDoc = messageRef.doc();

          final message = ChatMessageModel(
            id: messageDoc.id,
            chatRoomId: chatRoomId,
            senderId: senderId,
            receiverId: receiverId,
            content: replyText,
            timestamp: Timestamp.now(),
            readByUserIds: [senderId],
          );

          //add message to sub collection
          batch.set(messageDoc, message.toMap());

          //update chatroom

          batch.update(chatroom.doc(chatRoomId), {
            "lastMessage": replyText,
            "lastMessageSenderId": senderId,
            "lastMessageTime": message.timestamp,
          });
          await batch.commit();
        }
        break;
      case 'LIKE':
        log('Ontap Like action button');
        break;
      default:
        final data = receivedAction.payload ?? {};
        NotificationHandler.handleTapNavigate(data, entity);
        log('Ontap notification: ${data['type']}');
        break;
    }
    await awesomeNotifications.decrementGlobalBadgeCounter();
    int badge = await awesomeNotifications.getGlobalBadgeCounter();
    log('🔢 Current Badge Count: $badge');
  }

  @pragma('vm:entry-point')
  static Future<void> onDismissActionReceivedMethod(
    ReceivedAction? receivedAction,
  ) async {
    await awesomeNotifications.decrementGlobalBadgeCounter();
    log('Dismissed Action: ${receivedAction?.toMap()}');
  }

  @pragma('vm:entry-point')
  static Future<void> onNotificationCreatedMethod(
    ReceivedNotification? receivedNotification,
  ) async {
    log('🔢 onNotificationCreatedMethod');
  }

  @pragma('vm:entry-point')
  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification? receivedNotification,
  ) async {
    int badge = await awesomeNotifications.getGlobalBadgeCounter();
    log('📛 Badge Counter: $badge');
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

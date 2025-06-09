import 'dart:async' show FutureOr;
import 'dart:developer' show log;

class NotificationResponseData {
  NotificationResponseData({
    this.type = '',
    this.accountId = '',
    this.accountName = '',
  });

  final String? type;
  final String? accountId;
  final String? accountName;

  factory NotificationResponseData.fromJson(Map<String, dynamic> json) {
    return NotificationResponseData(
      type: json['type'] as String?,
      accountId: json['accountId'] as String?,
      accountName: json['accountName'] as String?,
    );
  }
}

class NotificationsResponseEntity {
  NotificationsResponseEntity({
    required this.type,
    this.accountId = '',
    this.accountName = '',
  });

  final String type;
  final String accountId;
  final String accountName;
}

class ReplyNotification {
  ReplyNotification({required this.replyText, required this.accountId});

  final String replyText;
  final String accountId;
}

class NotificationEntity {
  NotificationEntity({this.onMessageOpenedApp, this.onReply});

  factory NotificationEntity.initialize() => NotificationEntity(
    onMessageOpenedApp: (message) => log('onMessageOpenedApp: $message'),
    onReply: (message) => log('onReply: $message'),
  );

  FutureOr<void> Function(NotificationsResponseEntity)? onMessageOpenedApp;
  FutureOr<void> Function(ReplyNotification)? onReply;

  void setHandlers({
    FutureOr<void> Function(ReplyNotification)? onReply,
    FutureOr<void> Function(NotificationsResponseEntity)? onMessageOpenedApp,
  }) {
    this.onReply = onReply ?? this.onReply;
    this.onMessageOpenedApp = onMessageOpenedApp ?? this.onMessageOpenedApp;
  }
}

class NotificationType {
  static const String chatDetails = 'chat.details';
}

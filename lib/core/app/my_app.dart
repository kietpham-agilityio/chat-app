import 'package:chat_app/core/app/app_provider.dart';
import 'package:chat_app/core/local_database/hive_local_db.dart';
import 'package:chat_app/core/notifications/notifications_service.dart';
import 'package:chat_app/core/resources/l10n_generated/l10n.dart';
import 'package:chat_app/core/router/app_router.dart';
import 'package:chat_app/core/themes/app_theme.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    final user = await HiveLocalDb.instance.userBox.getUser();
    if (state == AppLifecycleState.resumed &&
        (user?.fullName.isNotEmpty ?? false)) {
      final recheckPermission = await NotificationsService.awesomeNotifications
          .isNotificationAllowed();

      final notifisBox = await HiveLocalDb.instance.notificationsBox
          .getNotificationsBox();

      if (notifisBox?.isNotifsEnabledDevice != recheckPermission) {
        notifisBox?.isNotificationEnabled = recheckPermission;
        notifisBox?.isNotifsEnabledDevice = recheckPermission;
      }
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AppProvider(
      child: MaterialApp.router(
        theme: CATheme.light,
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
        locale: const Locale('en', 'US'),

        localizationsDelegates: const [S.delegate],
        supportedLocales: [
          ...S.delegate.supportedLocales,
          const Locale('en', ''),
        ],
      ),
    );
  }
}

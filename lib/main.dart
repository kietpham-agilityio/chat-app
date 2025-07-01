import 'package:chat_app/core/local_database/hive_local_db.dart';
import 'package:chat_app/core/notifications/notifications_service.dart';
import 'package:chat_app/core/resources/l10n_generated/l10n.dart' show S;
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/app/app_provider.dart';
import 'core/router/app_router.dart';
import 'core/themes/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await initializeDateFormatting('en');

  await HiveLocalDb.instance.init();

  await NotificationsService.setNotificationListeners();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

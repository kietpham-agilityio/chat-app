import 'package:chat_app/core/app/env.dart';
import 'package:chat_app/core/flavors/flavor_config.dart';
import 'package:chat_app/core/local_database/hive_local_db.dart';
import 'package:chat_app/core/notifications/notifications_service.dart';
import 'package:chat_app/main_common.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await initializeDateFormatting('en');

  await HiveLocalDb.instance.init();

  await NotificationsService.setNotificationListeners();

  final flavor = switch (CAEnv.env) {
    // final env means: final env = CAEnv.env
    final env when FlavorConfig.isDev(env) => Flavor.dev,
    final env when FlavorConfig.isStag(env) => Flavor.stag,
    _ => Flavor.prod,
  };

  mainCommon(flavor: flavor, baseUrl: '', name: CAEnv.env);
}

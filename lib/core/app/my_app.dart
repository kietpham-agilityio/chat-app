import 'dart:developer';

import 'package:chat_app/core/app/app_provider.dart';
import 'package:chat_app/core/resources/l10n_generated/l10n.dart';
import 'package:chat_app/core/router/app_router.dart';
import 'package:chat_app/core/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      // When app kill -> clear session
      ChatSessionManager.clearCurrentUser();
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

class ChatSessionManager {
  static const _storageKey = 'current_chatting_user_id';

  static String? _inMemoryUserId;

  /// Call when user join chat
  static Future<void> setCurrentUser(String userId) async {
    _inMemoryUserId = userId;

    // isolate (mySilentDataHandle) can read
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, userId);
    log(
      'current_chatting_user_id: ${prefs.getString('current_chatting_user_id') ?? ''}',
    );
  }

  /// Call when user leave chat
  static Future<void> clearCurrentUser() async {
    _inMemoryUserId = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    log(
      'current_chatting_user_id: ${prefs.getString('current_chatting_user_id') ?? ''}',
    );
  }

  /// Use in UI (RAM)
  static String? getCurrentUserInMemory() => _inMemoryUserId;

  /// Use in isolate
  static Future<String?> getCurrentUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    log(
      'current_chatting_user_id: ${prefs.getString('current_chatting_user_id') ?? ''}',
    );
    return prefs.getString(_storageKey);
  }
}

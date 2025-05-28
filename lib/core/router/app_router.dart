import 'package:chat_app/core/router/router_guard.dart' show RouterGuard;
import 'package:chat_app/screens/auth/views/login_screen.dart';
import 'package:chat_app/screens/auth/views/sign_up_screen.dart';
import 'package:chat_app/screens/chat/views/chat_screen.dart';
import 'package:chat_app/screens/home/views/home_screen.dart';
import 'package:chat_app/screens/my_account/views/my_account_screen.dart';
import 'package:chat_app/screens/profile/views/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final authNotifier = AuthNotifier();

  static final router = GoRouter(
    debugLogDiagnostics: kDebugMode,
    initialLocation: AppPaths.home.path,
    navigatorKey: rootNavigatorKey,
    refreshListenable: authNotifier,
    routes: [
      GoRoute(
        name: AppPaths.login.name,
        path: AppPaths.login.path,
        builder: (_, state) => const LoginScreen(),
      ),
      GoRoute(
        name: AppPaths.signUp.name,
        path: AppPaths.signUp.path,
        builder: (_, state) => const SignUpScreen(),
      ),
      GoRoute(
        name: AppPaths.home.name,
        path: AppPaths.home.path,
        builder: (_, state) => const HomeScreen(),
        routes: [
          GoRoute(
            name: AppPaths.chat.name,
            path: AppPaths.chat.path,
            builder: (_, state) => const ChatMessageScreen(),
          ),
          GoRoute(
            name: AppPaths.profile.name,
            path: AppPaths.profile.path,
            builder: (_, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                name: AppPaths.myAccount.name,
                path: AppPaths.myAccount.path,
                builder: (_, state) => const MyAccountScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder:
        (_, state) =>
            const Scaffold(body: Center(child: Text('Error: No route found'))),
    redirect: (_, state) {
      return RouterGuard.authGuard(state);
    },
  );
}

enum AppPaths {
  home(name: 'home', path: '/'),
  login(name: 'login', path: '/login'),
  signUp(name: 'sign-up', path: '/sign-up'),
  chat(name: 'chat', path: '/chat'),
  profile(name: 'profile', path: '/profile'),
  myAccount(name: 'my-account', path: '/my-account');

  const AppPaths({required this.name, required this.path});

  /// Represents the route name
  ///
  /// Example: `AppRoutes.login.name`
  /// Returns: 'login'
  final String name;

  /// Represents the route path
  ///
  /// Example: `AppRoutes.login.path`
  /// Returns: '/login'
  final String path;

  @override
  String toString() => name;
}

class AuthNotifier extends ChangeNotifier {
  AuthNotifier() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      notifyListeners();
    });
  }
}

import 'package:chat_app/core/router/app_router.dart' show AppPaths;
import 'package:go_router/go_router.dart' show GoRouterState;
import 'package:supabase_flutter/supabase_flutter.dart';

class RouterGuard {
  static Future<String?> authGuard(GoRouterState state) async {
    final unAuthenList = [
      state.namedLocation(AppPaths.login.name),
      state.namedLocation(AppPaths.signUp.name),
    ];

    // final currentUser = FirebaseAuth.instance.currentUser != null;
    final currentUser = Supabase.instance.client.auth.currentUser != null;

    if (currentUser && unAuthenList.contains(state.matchedLocation)) {
      return state.namedLocation(AppPaths.home.name);
    }

    if (unAuthenList.contains(state.matchedLocation)) {
      return null;
    }

    if (!currentUser) {
      return state.namedLocation(AppPaths.login.name);
    }
    return null;
  }
}

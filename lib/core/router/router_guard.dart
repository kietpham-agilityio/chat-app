import 'package:chat_app/core/router/app_router.dart' show AppPaths;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:go_router/go_router.dart' show GoRouterState;

class RouterGuard {
  static Future<String?> authGuard(GoRouterState state) async {
    final unAuthenList = [
      state.namedLocation(AppPaths.login.name),
      state.namedLocation(AppPaths.signUp.name),
    ];

    final currentUser = FirebaseAuth.instance.currentUser != null;

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

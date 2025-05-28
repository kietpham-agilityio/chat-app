import 'package:chat_app/core/resources/l10n_generated/l10n.dart' show S;
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/material.dart';

import 'core/app/app_provider.dart';
import 'core/router/app_router.dart';
import 'core/themes/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: AppProvider(
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
      ),
    );
  }
}

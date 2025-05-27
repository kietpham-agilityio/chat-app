import 'package:chat_app/core/router/app_router.dart' show AppPaths;
import 'package:chat_app/core/themes/app_palette.dart' show CAPalette;
import 'package:chat_app/core/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CAElevatedButton(
              text: 'Login',
              onPressed: () {
                context.pushReplacementNamed(AppPaths.home.name);
              },
            ),
            SizedBox(height: 16),
            CAElevatedButton(
              backgroundColor: CAPalette.grey[2],
              foregroundColor: CAPalette.grey[5],
              text: 'Create a new account',
              onPressed: () => context.pushNamed(AppPaths.signUp.name),
            ),
          ],
        ),
      ),
    );
  }
}

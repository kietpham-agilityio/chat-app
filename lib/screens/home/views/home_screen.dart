import 'package:chat_app/core/router/app_router.dart' show AppPaths;
import 'package:chat_app/core/widgets/buttons.dart';
import 'package:chat_app/core/widgets/widgets.dart'
    show CAAppBar, CATitleMediumText;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CAAppBar(title: CATitleMediumText(text: 'Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CAElevatedButton(
              text: 'Go to Chat',
              onPressed: () {
                context.pushNamed(AppPaths.chat.name);
              },
            ),
            SizedBox(height: 16),
            CAElevatedButton(
              text: 'Go to Profile',
              onPressed: () {
                context.pushNamed(AppPaths.profile.name);
              },
            ),
          ],
        ),
      ),
    );
  }
}

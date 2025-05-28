import 'package:chat_app/core/router/app_router.dart';
import 'package:chat_app/core/widgets/widgets.dart'
    show CAAppBar, CAAssets, CAElevatedButton, CAIconButtons, CATitleMediumText;
import 'package:chat_app/repositories/repositories.dart' show AuthRepository;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CAAppBar(
        title: CATitleMediumText(text: 'Profile'),
        leading: CAIconButtons(
          icon: CAAssets.arrowLeft(),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CAElevatedButton(
              text: 'Go to My Account',
              onPressed: () {
                context.pushNamed(AppPaths.myAccount.name);
              },
            ),
            SizedBox(height: 16),
            CAElevatedButton(
              text: 'Log Out',
              onPressed: () {
                context.read<AuthRepository>().signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}

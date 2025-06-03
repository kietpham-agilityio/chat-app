import 'package:chat_app/core/extensions/string_extensions.dart';
import 'package:chat_app/core/router/app_router.dart';
import 'package:chat_app/core/widgets/circle_avatar.dart';
import 'package:chat_app/core/widgets/list_tile.dart';
import 'package:chat_app/core/widgets/text.dart';
import 'package:chat_app/core/widgets/widgets.dart'
    show CAAppBar, CAAssets, CAIconButtons, CATitleMediumText;
import 'package:chat_app/screens/auth/states/auth_bloc.dart';
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 32),
            CACircleAvatar(url: '', avatarSize: 96),
            SizedBox(height: 6),
            CAHeadlineMediumText(
              text:
                  context
                      .read<AuthBloc>()
                      .state
                      .user
                      ?.fullName
                      .capitalizeEachWord() ??
                  '',
            ),
            SizedBox(height: 18),
            CABodyLargeText(
              text: context.read<AuthBloc>().state.user?.phoneNumber ?? '',
            ),
            SizedBox(height: 24),
            CAListTile(
              title: Text('My Account'),
              leading: CAAssets.user(),
              onTap: () => context.pushNamed(AppPaths.myAccount.name),
            ),
            CAListTile(
              title: Text('Log Out'),
              leading: CAAssets.logOut(),
              onTap:
                  () => context.read<AuthBloc>().add(const AuthLogoutPressed()),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:chat_app/core/extensions/string_extensions.dart';
import 'package:chat_app/core/local_database/user_db_model.dart';
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
import 'package:hive/hive.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hive = Hive.box<UserDBModel>('userBox');
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
            _Avatar(hive),
            SizedBox(height: 6),
            _FullName(hive),
            SizedBox(height: 18),
            _PhoneNumber(hive),
            SizedBox(height: 24),
            CAListTile(
              title: Text('My Account'),
              leading: CAAssets.user(),
              onTap: () {
                final user = hive.get('userBox');
                context.pushNamed(
                  AppPaths.myAccount.name,
                  queryParameters: {
                    'email': user?.email,
                    'fullName': user?.fullName,
                    'phoneNumber': user?.phoneNumber,
                    'avatarUrl': user?.avatarUrl,
                  },
                );
              },
            ),
            CAListTile(
              title: Text('Log Out'),
              leading: CAAssets.logOut(),

              onTap: () =>
                  context.read<AuthBloc>().add(const AuthLogoutPressed()),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhoneNumber extends StatelessWidget {
  const _PhoneNumber(this.hive);
  final Box<UserDBModel> hive;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BoxEvent>(
      stream: hive.watch(),
      builder: (context, snapshot) {
        final user = hive.get('userBox');

        return CABodyLargeText(text: user?.phoneNumber ?? '');
      },
    );
  }
}

class _FullName extends StatelessWidget {
  const _FullName(this.hive);
  final Box<UserDBModel> hive;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BoxEvent>(
      stream: hive.watch(),
      builder: (context, snapshot) {
        final user = hive.get('userBox');

        return CAHeadlineMediumText(
          text: user?.fullName.capitalizeEachWord() ?? '',
        );
      },
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar(this.hive);

  final Box<UserDBModel> hive;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BoxEvent>(
      stream: hive.watch(),
      builder: (context, snapshot) {
        final user = hive.get('userBox');

        return Hero(
          tag: 'avatar',
          child: Material(
            color: Colors.transparent,
            child: CACircleAvatar(url: user?.avatarUrl ?? '', avatarSize: 96),
          ),
        );
      },
    );
  }
}

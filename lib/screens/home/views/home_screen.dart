import 'package:chat_app/core/extensions/context_extensions.dart';
import 'package:chat_app/core/router/app_router.dart' show AppPaths;
import 'package:chat_app/core/themes/themes.dart' show CAPalette;
import 'package:chat_app/core/widgets/widgets.dart'
    show
        CAAppBar,
        CAAssets,
        CABodyLargeText,
        CACircleAvatar,
        CADivider,
        CAHeadlineMediumText,
        CAListTile,
        CATextField,
        CATitleMediumText;
import 'package:chat_app/repositories/repositories.dart' show ChatRepository;
import 'package:chat_app/screens/home/cubit/home_bloc.dart';
import 'package:chat_app/screens/search/views/search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocBuilder, BlocProvider, ReadContext;
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => HomeBloc(chatRepository: context.read<ChatRepository>())
            ..add(
              HomeInitializeEvent(FirebaseAuth.instance.currentUser?.uid ?? ''),
            ),
      child: Scaffold(
        appBar: CAAppBar(
          title: CATitleMediumText(text: 'Chats'),
          leading: CACircleAvatar(
            url:
                'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
            onTap: () => context.pushNamed(AppPaths.profile.name),
            avatarSize: 32,
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: 32),
            Hero(
              tag: 'searchInputHero',
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: CATextField(
                    hintText: 'Search',
                    readOnly: true,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: CAAssets.search(
                        width: 24,
                        height: 24,
                        color: CAPalette.grey[4],
                      ),
                    ),
                    ontap:
                        () => Navigator.of(context).push(
                          PageRouteBuilder(
                            opaque: false,
                            transitionDuration: const Duration(
                              milliseconds: 300,
                            ),
                            pageBuilder: (_, __, ___) => const SearchScreen(),
                            transitionsBuilder: (
                              context,
                              animation,
                              secondaryAnimation,
                              child,
                            ) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                          ),
                        ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state.status == HomeStatus.success &&
                      state.chats.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CAAssets.logo(),
                          SizedBox(height: 28),
                          CAHeadlineMediumText(text: 'Let\'s start chatting'),
                          CABodyLargeText(
                            text:
                                'Type in the search bar to find and select a contact to start a new chat.',
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 100),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: state.chats.length,
                    separatorBuilder:
                        (BuildContext context, int index) => CADivider(),
                    itemBuilder: (_, index) {
                      if (index == state.chats.length - 1) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CAListTile(
                              leading: CACircleAvatar(
                                url:
                                    'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
                                avatarSize: 48,
                              ),
                              trailing: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: context.colorScheme.primary,
                                ),
                                width: 10,
                                height: 10,
                              ),
                              title: Text('Title $index'),
                              subtitle: Text('Subtitle $index'),
                              onTap:
                                  () => context.pushNamed(AppPaths.chat.name),
                            ),
                            CADivider(),
                          ],
                        );
                      }

                      return CAListTile(
                        leading: CACircleAvatar(
                          url:
                              'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
                          avatarSize: 48,
                        ),
                        trailing: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: context.colorScheme.primary,
                          ),
                          width: 10,
                          height: 10,
                        ),
                        title: Text('Title $index'),
                        subtitle: Text('Subtitle $index'),
                        onTap: () => context.pushNamed(AppPaths.chat.name),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

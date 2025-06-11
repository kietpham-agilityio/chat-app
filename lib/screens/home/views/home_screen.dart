import 'package:chat_app/core/extensions/context_extensions.dart';
import 'package:chat_app/core/extensions/string_extensions.dart';
import 'package:chat_app/core/extensions/timestamp_extensions.dart';
import 'package:chat_app/core/local_database/user_db_model.dart';
import 'package:chat_app/core/notifications/notifications_service.dart';
import 'package:chat_app/core/router/app_router.dart' show AppPaths;
import 'package:chat_app/core/themes/themes.dart' show CAPalette;
import 'package:chat_app/core/widgets/widgets.dart'
    show
        CAAppBar,
        CAAssets,
        CABodyLargeText,
        CABodyMediumText,
        CACircleAvatar,
        CADivider,
        CAHeadlineMediumText,
        CAListTile,
        CATextField,
        CATitleMediumText,
        WzSnackBar,
        CAIconButtons;
import 'package:chat_app/models/models.dart' show ChatRoomModel;
import 'package:chat_app/repositories/repositories.dart'
    show AuthRepository, ChatRepository;
import 'package:chat_app/screens/home/cubit/home_bloc.dart';
import 'package:chat_app/screens/search/views/search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocBuilder, BlocProvider, ReadContext, BlocListener;
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:loader_overlay/loader_overlay.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: BlocProvider(
        create: (_) {
          final notificationsService = context.read<NotificationsService>();
          notificationsService.initialize(context.read<AuthRepository>());
          return HomeBloc(chatRepository: context.read<ChatRepository>())..add(
            HomeInitializeEvent(FirebaseAuth.instance.currentUser?.uid ?? ''),
          );
        },
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state.status == HomeStatus.loading) {
              context.loaderOverlay.show();
            } else {
              context.loaderOverlay.hide();
            }

            if (state.status == HomeStatus.failure &&
                state.errorMessage != '') {
              WzSnackBar.error(context, message: state.errorMessage ?? '');
            }
          },
          child: Scaffold(
            appBar: CAAppBar(
              title: CATitleMediumText(text: 'Chats'),
              leading: _Avatar(),
              trailing: [
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    return CAIconButtons(
                      icon: CAAssets.search(),
                      onPressed: () {
                        context.read<HomeBloc>().add(HomeCloseAllStreamEvent());
                      },
                    );
                  },
                ),
              ],
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
                        ontap: () => Navigator.of(context).push(
                          PageRouteBuilder(
                            opaque: false,
                            transitionDuration: const Duration(
                              milliseconds: 300,
                            ),
                            pageBuilder: (_, __, ___) => const SearchScreen(),
                            transitionsBuilder:
                                (
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
                              CAHeadlineMediumText(
                                text: 'Let\'s start chatting',
                              ),
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

                      return ListView.builder(
                        itemCount: state.chats.length,
                        itemBuilder: (_, index) {
                          return _ChatListTile(
                            chatRoom: state.chats[index],
                            currentUserId:
                                FirebaseAuth.instance.currentUser?.uid ?? '',
                            onTap: () {
                              final otherUserId = state
                                  .chats[index]
                                  .participants
                                  .firstWhere(
                                    (id) =>
                                        id !=
                                        FirebaseAuth.instance.currentUser?.uid,
                                  );
                              final outherUserName =
                                  state
                                      .chats[index]
                                      .participantsName?[otherUserId] ??
                                  "Unknown";
                              context.pushNamed(
                                AppPaths.chat.name,
                                queryParameters: {
                                  'receiverId': otherUserId,
                                  'receiverName': outherUserName,
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<UserDBModel>('userBox');
    final stream = box.watch();
    return StreamBuilder<BoxEvent>(
      stream: stream,
      builder: (context, snapshot) {
        final user = Hive.box<UserDBModel>('userBox').get('userBox');

        return Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Hero(
            tag: 'avatar',
            child: Material(
              color: Colors.transparent,
              child: CACircleAvatar(
                url: user?.avatarUrl ?? '',
                onTap: () => context.pushNamed(AppPaths.profile.name),
                avatarSize: 32,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ChatListTile extends StatelessWidget {
  const _ChatListTile({
    required this.chatRoom,
    required this.currentUserId,
    required this.onTap,
  });

  final ChatRoomModel chatRoom;
  final String currentUserId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isMe = chatRoom.lastMessageSenderId == currentUserId;

    String getOtherUsername() {
      try {
        final otherUserId = chatRoom.participants.firstWhere(
          (id) => id != currentUserId,
          orElse: () => 'Unknown User',
        );
        return chatRoom.participantsName?[otherUserId] ?? "Unknown User";
      } catch (e) {
        return "Unknown User";
      }
    }

    String getOtherUserAvatar() {
      try {
        final otherUserId = chatRoom.participants.firstWhere(
          (id) => id != currentUserId,
          orElse: () => 'Unknown User',
        );
        return chatRoom.participantsAvatar?[otherUserId] ?? "Unknown User";
      } catch (e) {
        return "Unknown User";
      }
    }

    return StreamBuilder<bool>(
      stream: context.read<ChatRepository>().checkUnread(
        chatRoom.id,
        FirebaseAuth.instance.currentUser?.uid ?? '',
      ),
      builder: (context, snapshot) {
        final hasUnread = snapshot.data == true;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CAListTile(
              leading: CACircleAvatar(
                url: getOtherUserAvatar(),
                avatarSize: 40,
              ),
              tileColor: hasUnread ? CAPalette.grey[1] : null,
              trailing: hasUnread
                  ? Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: context.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    )
                  : const SizedBox(),
              title: CATitleMediumText(
                text: getOtherUsername().capitalizeEachWord(),
              ),
              subtitle: Row(
                children: [
                  Flexible(
                    child: CABodyMediumText(
                      text: isMe
                          ? 'You: ${chatRoom.lastMessage ?? ''}'
                          : chatRoom.lastMessage ?? '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CABodyMediumText(
                    text: chatRoom.lastMessageTime?.timeAgo() ?? '',
                  ),
                ],
              ),
              onTap: onTap,
            ),
            const CADivider(),
          ],
        );
      },
    );
  }
}

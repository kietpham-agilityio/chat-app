import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chat_app/core/app/env.dart';
import 'package:chat_app/core/extensions/context_extensions.dart';
import 'package:chat_app/core/extensions/string_extensions.dart';
import 'package:chat_app/core/extensions/timestamp_extensions.dart';
import 'package:chat_app/core/local_database/user_db_model.dart';
import 'package:chat_app/core/notifications/notifications_service.dart';
import 'package:chat_app/core/notifications/notifications_setup.dart';
import 'package:chat_app/core/resources/l10n_generated/l10n.dart';
import 'package:chat_app/core/router/app_router.dart' show AppPaths;
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
        CASnackBar,
        CAIconButtons;
import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/models/models.dart' show ChatRoomModel;
import 'package:chat_app/repositories/repositories.dart'
    show AuthRepository, ChatRepository, ConversationRepository;
import 'package:chat_app/screens/chat/views/chat_screen.dart';
import 'package:chat_app/screens/home/cubit/home_cubit.dart';
import 'package:chat_app/screens/search/views/search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocBuilder, BlocProvider, ReadContext, BlocListener;
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeCubit _cubit;
  late final ConversationRepository _conversationRepository;

  @override
  void initState() {
    _conversationRepository = context.read<ConversationRepository>();
    _cubit = HomeCubit(conversationRepository: _conversationRepository);
    super.initState();
  }

  @override
  void dispose() {
    _cubit.dispose();
    _conversationRepository.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: LoaderOverlay(
        child: BlocProvider(
          create: (_) {
            final notificationsService = context.read<NotificationsService>();
            notificationsService.initialize(context.read<AuthRepository>());

            return _cubit
              ..start(Supabase.instance.client.auth.currentUser?.id ?? '');
          },
          child: BlocListener<HomeCubit, HomeState>(
            listener: (context, state) {
              if (state.status == HomeStatus.loading) {
                context.loaderOverlay.show();
              } else {
                context.loaderOverlay.hide();
              }

              if (state.status == HomeStatus.failure &&
                  state.errorMessage != '') {
                CASnackBar.error(context, message: state.errorMessage ?? '');
              }
            },
            child: Scaffold(
              appBar: CAAppBar(
                title: CATitleMediumText(text: S.of(context).homeTitle),
                leading: _Avatar(),
                actions: [
                  CAIconButtons(
                    icon: CAAssets.plus(),
                    onPressed: () async {
                      // Mock notification for iOS
                      if (Platform.isIOS) {
                        NotificationsService.awesomeNotifications
                            .createNotification(
                              content: NotificationContent(
                                id: 1,
                                channelKey: NotificationSetup.channelKey,
                                title: 'New message',
                                body: 'Hi Kiet!',
                                payload: {
                                  'accountId': CAEnv.accountId,
                                  'type': 'chat.details',
                                  'accountName': 'Kiet Pham',
                                },
                              ),
                              actionButtons: [
                                NotificationActionButton(
                                  key: 'REPLY',
                                  label: 'Reply',
                                  requireInputText: true,
                                  actionType: ActionType.SilentAction,
                                ),
                              ],
                            );
                      }
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
                          hintText: S.of(context).searchHint,
                          readOnly: true,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: CAAssets.search(
                              width: 24,
                              height: 24,
                              color: context.colorScheme.onSecondary,
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
                    child: BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        if (state.status == HomeStatus.success &&
                            state.conversations.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CAAssets.logo(),
                                SizedBox(height: 28),
                                CAHeadlineMediumText(
                                  text: S.of(context).homeSubTitle,
                                ),
                                CABodyLargeText(
                                  text: S.of(context).homeDescription,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 100),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: state.conversations.length,
                          itemBuilder: (_, index) {
                            return _ChatListTileSupabase(
                              conversation: state.conversations[index],

                              onTap: () {
                                context.pushNamed(
                                  AppPaths.chat.name,
                                  queryParameters: {
                                    'receiverId':
                                        state.conversations[index].partnerId,
                                    'receiverName':
                                        state.conversations[index].partnerName,
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
                semanticsLabel: 'Go to profile screen',
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
    required this.otherUserId,
    required this.onTap,
  });

  final ChatRoomModel chatRoom;
  final String currentUserId;
  final String otherUserId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isMe = chatRoom.lastMessageSenderId == currentUserId;

    String getOtherUsername() {
      try {
        final otherUserId = chatRoom.participants.firstWhere(
          (id) => id != currentUserId,
          orElse: () => S.of(context).generalUnknownUser,
        );
        return chatRoom.participantsName[otherUserId] ??
            S.of(context).generalUnknownUser;
      } catch (e) {
        return S.of(context).generalUnknownUser;
      }
    }

    String getOtherUserAvatar() {
      try {
        final otherUserId = chatRoom.participants.firstWhere(
          (id) => id != currentUserId,
          orElse: () => S.of(context).generalUnknownUser,
        );
        return chatRoom.participantsAvatar[otherUserId] ??
            S.of(context).generalUnknownUser;
      } catch (e) {
        return S.of(context).generalUnknownUser;
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
              semanticsLabel: S
                  .of(context)
                  .semanticChatWith(getOtherUsername()),
              leading: CACircleAvatar(
                url: getOtherUserAvatar(),
                avatarSize: 40,
              ),
              tileColor: hasUnread ? context.colorScheme.tertiary : null,
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
                text: getOtherUsername().capitalizeWords(),
              ),
              subtitle: chatRoom.isTypingByUser[otherUserId] ?? false
                  ? LoadingDots()
                  : Row(
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

class _ChatListTileSupabase extends StatelessWidget {
  const _ChatListTileSupabase({
    required this.conversation,
    required this.onTap,
  });

  final Conversation conversation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isMe = conversation.senderByMe();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CAListTile(
          semanticsLabel: S
              .of(context)
              .semanticChatWith(conversation.partnerName),
          leading: CACircleAvatar(
            url: conversation.partnerAvatar,
            avatarSize: 40,
          ),
          // tileColor: hasUnread ? context.colorScheme.tertiary : null,
          // trailing: hasUnread
          //     ? Container(
          //         height: 10,
          //         width: 10,
          //         decoration: BoxDecoration(
          //           color: context.colorScheme.primary,
          //           shape: BoxShape.circle,
          //         ),
          //       )
          //     : const SizedBox(),
          title: CATitleMediumText(
            text: conversation.partnerName.capitalizeWords(),
          ),
          // subtitle: conversation.isTypingByUser[otherUserId] ?? false
          //     ? LoadingDots()
          //     : Row(
          //         children: [
          //           Flexible(
          //             child: CABodyMediumText(
          //               text: isMe
          //                   ? 'You: ${conversation.lastMessage ?? ''}'
          //                   : conversation.lastMessage ?? '',
          //               overflow: TextOverflow.ellipsis,
          //               maxLines: 1,
          //             ),
          //           ),
          //           const SizedBox(width: 8),
          //           CABodyMediumText(
          //             text: conversation.lastMessageTime?.timeAgo() ?? '',
          //           ),
          //         ],
          //       ),
          subtitle: Row(
            children: [
              Flexible(
                child: CABodyMediumText(
                  text: isMe
                      ? 'You: ${conversation.lastMessageContent ?? ''}'
                      : conversation.lastMessageContent ?? '',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 8),
              CABodyMediumText(
                text: conversation.lastMessageAt?.timeAgo() ?? '',
              ),
            ],
          ),
          onTap: onTap,
        ),
        const CADivider(),
      ],
    );
  }
}

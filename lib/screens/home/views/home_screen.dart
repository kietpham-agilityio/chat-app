import 'package:chat_app/core/extensions/context_extensions.dart';
import 'package:chat_app/core/extensions/string_extensions.dart';
import 'package:chat_app/core/extensions/timestamp_extensions.dart';
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
        CATitleMediumText;
import 'package:chat_app/models/models.dart' show ChatRoomModel;
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

                  return ListView.builder(
                    itemCount: state.chats.length,
                    itemBuilder: (_, index) {
                      return _ChatListTile(
                        chatRoom: state.chats[index],
                        currentUserId:
                            FirebaseAuth.instance.currentUser?.uid ?? '',
                        onTap: () {
                          final otherUserId = state.chats[index].participants
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

    return StreamBuilder<bool>(
      stream: context.read<ChatRepository>().getUnreadCount(
        chatRoom.id,
        FirebaseAuth.instance.currentUser?.uid ?? '',
      ),
      builder: (context, snapshot) {
        final hasUnread = snapshot.data == true;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CAListTile(
              leading: const CACircleAvatar(
                url:
                    'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
                avatarSize: 40,
              ),
              tileColor: hasUnread ? CAPalette.grey[1] : null,
              trailing:
                  hasUnread
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
                      text:
                          isMe
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

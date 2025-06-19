import 'package:chat_app/core/extensions/context_extensions.dart';
import 'package:chat_app/core/extensions/datetime_extensions.dart';
import 'package:chat_app/core/extensions/string_extensions.dart';
import 'package:chat_app/core/local_database/hive_local_db.dart';
import 'package:chat_app/core/resources/l10n_generated/l10n.dart';
import 'package:chat_app/core/widgets/text.dart';
import 'package:chat_app/core/widgets/widgets.dart'
    show
        CAAppBar,
        CAAssets,
        CACircleAvatar,
        CADialog,
        CADialogManager,
        CADivider,
        CAElevatedButton,
        CAIconButtons,
        CATextField,
        CATitleMediumText;
import 'package:chat_app/models/chat_message_model.dart';
import 'package:chat_app/repositories/repositories.dart' show ChatRepository;
import 'package:chat_app/screens/chat/cubit/chat_cubit.dart'
    show ChatCubit, ChatState, ChatStatus;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ChatMessageScreen extends StatefulWidget {
  const ChatMessageScreen({
    required this.receiverId,
    required this.receiverName,
    super.key,
  });

  final String receiverId;
  final String receiverName;

  @override
  State<ChatMessageScreen> createState() => _ChatMessageScreenState();
}

class _ChatMessageScreenState extends State<ChatMessageScreen> {
  late ChatCubit _chatCubit;

  @override
  void initState() {
    _chatCubit = ChatCubit(
      currentUserId: FirebaseAuth.instance.currentUser?.uid ?? '',
      chatRepository: context.read<ChatRepository>(),
      userBox: HiveLocalDb.instance.userBox,
    )..getMyAvatarUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: LoaderOverlay(
        child: BlocProvider(
          create: (context) => _chatCubit,
          child: BlocListener<ChatCubit, ChatState>(
            listener: (context, state) {
              if (state.status == ChatStatus.loading) {
                context.loaderOverlay.show();
              } else {
                context.loaderOverlay.hide();
              }
            },
            child: Scaffold(
              appBar: CAAppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BlocBuilder<ChatCubit, ChatState>(
                      buildWhen: (previous, current) =>
                          previous.receiverAvatarUrl !=
                          current.receiverAvatarUrl,
                      builder: (context, state) {
                        return CACircleAvatar(
                          url: state.receiverAvatarUrl ?? '',
                          avatarSize: 32,
                        );
                      },
                    ),
                    BlocBuilder<ChatCubit, ChatState>(
                      buildWhen: (previous, current) =>
                          previous.receiverFullName != current.receiverFullName,
                      builder: (context, state) {
                        return CATitleMediumText(
                          text:
                              state.receiverFullName?.capitalizeWords() ??
                              widget.receiverName.capitalizeWords(),
                        );
                      },
                    ),
                    SizedBox(width: 32),
                  ],
                ),
                titleSpacing: 0,
                leading: CAIconButtons(
                  icon: CAAssets.arrowLeft(),
                  onPressed: () => context.pop(),
                ),
                actions: [
                  BlocBuilder<ChatCubit, ChatState>(
                    bloc: _chatCubit,
                    builder: (context, state) {
                      if (state.amIBlocked || state.isUserBlocked) {
                        return SizedBox(width: 48);
                      }

                      return PopupMenuButton<String>(
                        icon: CAAssets.moreHorizontal(),
                        onSelected: (value) async {
                          if (value == "block") {
                            CADialogManager.showDialog(
                              context: context,
                              dialog: CADialog(
                                title: S
                                    .of(context)
                                    .chatMessageDialogBlockUserTitle,
                                content: S
                                    .of(context)
                                    .chatMessageDialogBlockUserContent(
                                      widget.receiverName.capitalizeWords(),
                                    ),
                                confirmButtonTitle: S
                                    .of(context)
                                    .chatMessageBlockBtn,
                                cancelButtonTitle: S
                                    .of(context)
                                    .chatMessageCancelBtn,
                                onCancel: () => context.pop(),
                                onConfirm: () {
                                  context.pop();
                                  _chatCubit.blockUser(widget.receiverId);
                                },
                              ),
                            );
                          }
                        },
                        itemBuilder: (context) => <PopupMenuEntry<String>>[
                          PopupMenuItem(
                            value: 'block',
                            child: CABodyLargeText(
                              text: S.of(context).chatMessageBlockBtn,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              body: SafeArea(
                child: _View(
                  receiverId: widget.receiverId,
                  receiverName: widget.receiverName,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _View extends StatefulWidget {
  const _View({required this.receiverId, required this.receiverName});

  final String receiverId;
  final String receiverName;

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {
  late final ChatCubit _chatCubit;

  final _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();

  Future<void> _handleSendMessage() async {
    final messageText = _messageController.text.trim();
    _messageController.clear();
    _chatCubit.messageChanged(_messageController.text);
    await _chatCubit.sendMessage(
      content: messageText,
      receiverId: widget.receiverId,
    );
  }

  Future<void> _handleSendThumbUp() async {
    await _chatCubit.sendMessage(content: '👍', receiverId: widget.receiverId);
  }

  @override
  void initState() {
    _chatCubit = context.read<ChatCubit>();
    _chatCubit.enterChat(widget.receiverId);
    _scrollController.addListener(_onScroll);

    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _chatCubit.leaveRoom();

    super.dispose();
  }

  bool get isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onScroll() {
    if (isBottom) _chatCubit.loadMoreMessages();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    reverse: true,
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      final isMe = message.senderId == _chatCubit.currentUserId;
                      ChatMessageModel? nextMessage;
                      ChatMessageModel? prevMessage;

                      if (index + 1 < state.messages.length) {
                        nextMessage = state.messages[index + 1];
                      }
                      if (index - 1 >= 0) {
                        prevMessage = state.messages[index - 1];
                      }

                      bool showTimestamp = false;
                      bool isLastBeforeTimestamp = false;

                      final currentDate = message.timestamp.toDate();

                      if (nextMessage == null) {
                        showTimestamp = true;
                      } else {
                        final nextTime = nextMessage.timestamp.toDate();
                        final diff = currentDate.difference(nextTime).inMinutes;
                        showTimestamp =
                            diff >= 5 || !currentDate.isSameDay(nextTime);
                      }

                      if (index == 0) {
                        isLastBeforeTimestamp = true;
                      } else if (prevMessage != null) {
                        final prevDate = prevMessage.timestamp.toDate();
                        final prevDiff = prevDate
                            .difference(currentDate)
                            .inMinutes;
                        final prevShowTimestamp =
                            prevDiff >= 5 || !prevDate.isSameDay(currentDate);
                        isLastBeforeTimestamp =
                            prevShowTimestamp ||
                            prevMessage.senderId != message.senderId;
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (showTimestamp) ...[
                            SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: context.colorScheme.tertiaryFixedDim,
                                ),
                                color: context.colorScheme.tertiary,
                              ),
                              child: CABodyMediumText(
                                text: message.timestamp
                                    .toDate()
                                    .formatChatDateTime(),
                                color: context.colorScheme.tertiaryContainer,
                              ),
                            ),
                            SizedBox(height: 16),
                          ] else
                            SizedBox(height: 10),
                          MessageBubble(
                            message: message,
                            isMe: isMe,
                            receiverAvatarUrl: state.receiverAvatarUrl,
                            isLastBeforeTimestamp: isLastBeforeTimestamp,
                            myAvatar: state.myAvatarUrl,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                if (!state.amIBlocked && !state.isUserBlocked)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 8),
                            Expanded(
                              child: CATextField(
                                controller: _messageController,
                                keyboardType: TextInputType.multiline,
                                hasValidation: false,
                                onChanged: (value) {
                                  _chatCubit.messageChanged(value);
                                },
                                hintText: S
                                    .of(context)
                                    .chatMessageTextFieldHint,
                              ),
                            ),
                            const SizedBox(width: 8),
                            BlocSelector<ChatCubit, ChatState, bool>(
                              selector: (state) {
                                final isEnabled =
                                    state.message != null &&
                                    state.message != '';

                                return isEnabled;
                              },
                              builder: (context, isEnabled) {
                                return isEnabled
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.send,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                        onPressed: _handleSendMessage,
                                      )
                                    : CAIconButtons(
                                        icon: CAAssets.thumpsUp(),
                                        onPressed: _handleSendThumbUp,
                                      );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                else ...[
                  CADivider(),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CATitleMediumText(
                      text: state.isUserBlocked
                          ? S
                                .of(context)
                                .chatMessageBlockedByMeBannerTitle(
                                  widget.receiverName.capitalizeWords(),
                                )
                          : S
                                .of(context)
                                .chatMessageBlockedByOtherBannerTitle(
                                  widget.receiverName.capitalizeWords(),
                                ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CABodyMediumText(
                      text: S
                          .of(context)
                          .chatMessageBlockedByOtherBannerDescription(
                            widget.receiverName.capitalizeWords(),
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  if (state.isUserBlocked) ...[
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CAElevatedButton(
                        text: S.of(context).chatMessageUnblockBtn,
                        onPressed: () {
                          CADialogManager.showDialog(
                            context: context,
                            dialog: CADialog(
                              title: S.of(context).chatMessageUnblockBtn,
                              content: S
                                  .of(context)
                                  .chatMessageDialogUnblockUserContent(
                                    widget.receiverName.capitalizeWords(),
                                  ),
                              confirmButtonTitle: S
                                  .of(context)
                                  .chatMessageUnblockBtn,
                              cancelButtonTitle: S
                                  .of(context)
                                  .chatMessageCancelBtn,
                              onCancel: () => context.pop(),
                              onConfirm: () {
                                context.pop();
                                _chatCubit.unBlockUser(widget.receiverId);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ],
            ),
            if (state.isLoadingMore)
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: CupertinoActivityIndicator(),
              ),
          ],
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.message,
    required this.isMe,
    required this.isLastBeforeTimestamp,
    this.receiverAvatarUrl,
    this.myAvatar,
    super.key,
  });

  final ChatMessageModel message;
  final bool isMe;
  final String? receiverAvatarUrl;
  final String? myAvatar;
  final bool isLastBeforeTimestamp;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe && isLastBeforeTimestamp) ...[
            CACircleAvatar(url: receiverAvatarUrl ?? '', avatarSize: 32),
            SizedBox(width: 8),
          ] else ...[
            SizedBox(height: 32, width: 40),
          ],
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isMe
                  ? context.colorScheme.primary
                  : context.colorScheme.tertiary,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(8),
                topRight: const Radius.circular(8),
                bottomLeft: Radius.circular(isMe ? 8 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 8),
              ),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: CABodyLargeText(
                text: message.content,
                color: isMe
                    ? context.colorScheme.onPrimary
                    : context.colorScheme.tertiaryContainer,
                overflow: TextOverflow.visible,
              ),
            ),
          ),
          if (isMe && isLastBeforeTimestamp) ...[
            SizedBox(width: 8),
            CACircleAvatar(url: myAvatar ?? '', avatarSize: 24),
          ] else ...[
            SizedBox(height: 24, width: 32),
          ],
        ],
      ),
    );
  }
}

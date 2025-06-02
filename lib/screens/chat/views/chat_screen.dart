import 'package:chat_app/core/extensions/string_extensions.dart';
import 'package:chat_app/core/themes/themes.dart';
import 'package:chat_app/core/widgets/text.dart';
import 'package:chat_app/core/widgets/widgets.dart'
    show
        CAAppBar,
        CAAssets,
        CACircleAvatar,
        CAIconButtons,
        CATextField,
        CATitleMediumText;
import 'package:chat_app/models/chat_message.dart';
import 'package:chat_app/repositories/repositories.dart' show ChatRepository;
import 'package:chat_app/screens/chat/cubit/chat_cubit.dart'
    show ChatCubit, ChatState, ChatStatus;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ChatMessageScreen extends StatelessWidget {
  const ChatMessageScreen({
    required this.receiverId,
    required this.receiverName,
    super.key,
  });

  final String receiverId;
  final String receiverName;

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: BlocProvider(
        create:
            (context) => ChatCubit(
              currentUserId: FirebaseAuth.instance.currentUser?.uid ?? '',
              chatRepository: context.read<ChatRepository>(),
            ),
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
                  CACircleAvatar(
                    url:
                        'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
                    avatarSize: 32,
                  ),
                  CATitleMediumText(text: receiverName.capitalizeEachWord()),
                  SizedBox(width: 32),
                ],
              ),
              titleSpacing: 0,
              leading: CAIconButtons(
                icon: CAAssets.arrowLeft(),
                onPressed: () => context.pop(),
              ),
              trailing: [
                CAIconButtons(
                  icon: CAAssets.moreHorizontal(),
                  onPressed: () {},
                ),
              ],
            ),
            body: SafeArea(
              child: _View(receiverId: receiverId, receiverName: receiverName),
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

    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatTimestampWithDateCondition(DateTime time) {
    final now = DateTime.now();
    final timeStr =
        "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

    if (_isSameDay(time, now)) {
      return timeStr;
    } else {
      return "$timeStr • ${time.day.toString().padLeft(2, '0')}/${time.month.toString().padLeft(2, '0')}/${time.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        return Column(
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
                  ChatMessage? nextMessage;
                  if (index + 1 < state.messages.length) {
                    nextMessage = state.messages[index + 1];
                  }

                  bool showTimestamp = false;

                  final currentDate = message.timestamp.toDate();

                  if (nextMessage == null) {
                    showTimestamp = true;
                  } else {
                    final nextDate = nextMessage.timestamp.toDate();
                    final diff = currentDate.difference(nextDate).inMinutes;

                    // Display if the difference is >= 60 minutes or different day
                    showTimestamp =
                        diff >= 5 || !_isSameDay(currentDate, nextDate);
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (showTimestamp) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: CAPalette.grey[3]!),
                            color: CAPalette.grey[1],
                          ),
                          child: CABodyMediumText(
                            text: _formatTimestampWithDateCondition(
                              currentDate,
                            ),
                            color: CAPalette.grey[5],
                          ),
                        ),
                        SizedBox(height: 16),
                      ] else
                        SizedBox(height: 10),
                      MessageBubble(message: message, isMe: isMe),
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
                            hintText: "Start typing...",
                          ),
                        ),
                        const SizedBox(width: 8),
                        BlocSelector<ChatCubit, ChatState, bool>(
                          selector: (state) {
                            final isEnabled =
                                state.message != null && state.message != '';

                            return isEnabled;
                          },
                          builder: (context, isEnabled) {
                            return isEnabled
                                ? IconButton(
                                  icon: Icon(
                                    Icons.send,
                                    color:
                                        Theme.of(context).colorScheme.primary,
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
              ),
          ],
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({required this.message, required this.isMe, super.key});

  final ChatMessage message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CACircleAvatar(
              url:
                  'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
              avatarSize: 32,
            ),
            SizedBox(width: 8),
          ],
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color:
                  isMe
                      ? Theme.of(context).colorScheme.primary
                      : CAPalette.grey[1],
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
                color: isMe ? CAPalette.genericWhite : CAPalette.grey[5],
                overflow: TextOverflow.visible,
              ),
            ),
          ),
          if (isMe) ...[
            SizedBox(width: 8),
            CACircleAvatar(
              url:
                  'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
              avatarSize: 24,
            ),
          ],
        ],
      ),
    );
  }
}

import 'package:chat_app/core/widgets/widgets.dart'
    show CAAppBar, CAAssets, CAIconButtons, CATitleMediumText;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatMessageScreen extends StatelessWidget {
  const ChatMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CAAppBar(
        title: CATitleMediumText(text: 'Chat'),
        leading: CAIconButtons(
          icon: CAAssets.arrowLeft(),
          onPressed: () => context.pop(),
        ),
      ),
    );
  }
}

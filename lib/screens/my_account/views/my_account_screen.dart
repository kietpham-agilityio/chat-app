import 'package:chat_app/core/widgets/widgets.dart'
    show CAAppBar, CAAssets, CAIconButtons, CATitleMediumText;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CAAppBar(
        title: CATitleMediumText(text: 'My Account'),
        leading: CAIconButtons(
          icon: CAAssets.arrowLeft(),
          onPressed: () => context.pop(),
        ),
      ),
    );
  }
}

import 'package:chat_app/core/widgets/widgets.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CAAppBar(
        title: CATitleMediumText(text: 'Create account'),
        leading: CAIconButtons(
          icon: CAAssets.arrowLeft(),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      // body: ,
    );
  }
}

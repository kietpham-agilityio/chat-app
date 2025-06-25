import 'dart:ui';

import 'package:chat_app/core/extensions/context_extensions.dart';
import 'package:chat_app/core/widgets/buttons.dart';
import 'package:chat_app/core/widgets/text.dart';
import 'package:flutter/material.dart';

class CADialog extends StatelessWidget {
  const CADialog({
    required this.title,
    this.content,
    this.confirmButtonTitle,
    this.cancelButtonTitle,
    this.onConfirm,
    this.onCancel,
    this.textAlignContent,
    super.key,
  });

  final String title;
  final String? content;
  final String? confirmButtonTitle;
  final String? cancelButtonTitle;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final TextAlign? textAlignContent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: AlertDialog(
        backgroundColor: context.colorScheme.surfaceContainerLowest,
        title: Align(
          child: CATitleLargeText(
            text: title,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),
        ),
        content: CABodyMediumText(
          text: content ?? '',
          textAlign: textAlignContent ?? TextAlign.center,
        ),
        actions: <Widget>[
          if (confirmButtonTitle != null)
            CAElevatedButton(
              onPressed: onConfirm,
              text: confirmButtonTitle ?? '',
              minHeight: 40,
            ),
          SizedBox(height: 8),
          if (cancelButtonTitle != null)
            CAElevatedButton(
              minHeight: 40,
              onPressed: onCancel ?? () => Navigator.pop(context),
              text: cancelButtonTitle!,
              backgroundColor: context.colorScheme.secondary,
              foregroundColor: context.colorScheme.tertiaryContainer,
            ),
        ],
      ),
    );
  }
}

class CADialogManager {
  static Future<void> showDialog({
    required BuildContext context,
    required Widget dialog,
  }) {
    return showGeneralDialog(
      context: context,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, _, __) {
        final opacity = animation.value;
        final blur = 8.0 * opacity;

        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Stack(
              children: [
                Opacity(
                  opacity: opacity,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                    child: Container(
                      color: context.colorScheme.onSecondaryContainer
                          .withValues(alpha: 0.2 * opacity),
                    ),
                  ),
                ),

                FadeTransition(
                  opacity: animation,
                  child: Center(child: dialog),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

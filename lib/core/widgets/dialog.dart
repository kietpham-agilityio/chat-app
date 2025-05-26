import 'dart:ui';

import 'package:chat_app/core/extensions/context_extensions.dart';
import 'package:chat_app/core/themes/app_palette.dart';
import 'package:chat_app/core/widgets/buttons.dart';
import 'package:chat_app/core/widgets/text.dart';
import 'package:flutter/material.dart';

class CADialog extends StatelessWidget {
  const CADialog({
    required this.title,
    this.content,
    this.confirmButton,
    this.cancelButton,
    this.onConfirm,
    this.onCancel,
    this.textAlignContent,
    super.key,
  });

  final String title;
  final String? content;
  final String? confirmButton;
  final String? cancelButton;
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
          if (confirmButton != null)
            CAElevatedButton(
              onPressed: onConfirm,
              text: confirmButton ?? '',
              minHeight: 40,
            ),
          SizedBox(height: 2),
          if (cancelButton != null)
            CAElevatedButton(
              minHeight: 40,
              onPressed: onCancel ?? () => Navigator.pop(context),
              text: cancelButton!,
              backgroundColor: CAPalette.grey[2],
              foregroundColor: CAPalette.grey[5],
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
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            final opacity = animation.value;
            final blur = 8.0 * opacity;
            return Stack(
              children: [
                Opacity(
                  opacity: opacity,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                    child: Container(
                      color: CAPalette.genericBlack.withValues(
                        alpha: 0.2 * opacity,
                      ),
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

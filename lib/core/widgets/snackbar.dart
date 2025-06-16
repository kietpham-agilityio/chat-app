import 'package:chat_app/core/extensions/context_extensions.dart';
import 'package:chat_app/core/widgets/text.dart';
import 'package:flutter/material.dart';

class CASnackBar {
  static void error(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(CASnackBarContentError(context, message: message));
  }

  static void success(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(CASnackBarContentSuccess(context, message: message));
  }
}

/// A snack bar widget for displaying error messages.
///
/// This widget provides a predefined style for error messages with an icon,
/// text, and background color.
class CASnackBarContentError extends SnackBar {
  CASnackBarContentError(BuildContext context, {String message = '', super.key})
    : super(
        padding: EdgeInsets.zero,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 24),
        content: _SnackBarContent(
          leading: Icon(Icons.error_outline, color: Colors.white, size: 20),
          text: message,
          textColor: Colors.white,
          backgroundColor: context.colorScheme.error,
        ),
        backgroundColor: Colors.transparent,
        duration: const Duration(seconds: 5),
      );
}

/// A snack bar widget for displaying success messages.
///
/// This widget provides a predefined style for success messages with a check
/// icon, text, and background color.
class CASnackBarContentSuccess extends SnackBar {
  CASnackBarContentSuccess(
    BuildContext context, {
    String message = '',
    super.key,
  }) : super(
         padding: EdgeInsets.zero,
         behavior: SnackBarBehavior.floating,
         elevation: 0,
         margin: const EdgeInsets.symmetric(horizontal: 24),
         content: _SnackBarContent(
           leading: Icon(Icons.check, color: Colors.white, size: 20),
           text: message,
           textColor: Colors.white,
           backgroundColor: Colors.green,
         ),
         backgroundColor: Colors.transparent,
         duration: const Duration(seconds: 5),
       );
}

/// A snack bar content widget for displaying messages.
///
/// This widget provides a predefined style for snack bar messages with a text,
/// background color, and icon.
class _SnackBarContent extends StatelessWidget {
  const _SnackBarContent({
    this.text = '',
    this.textColor = Colors.white,
    this.backgroundColor,
    this.leading,
  });

  /// The text to be displayed in the snack bar.
  final String text;

  /// The color of the text.
  final Color textColor;

  /// The snack bar's background color.
  final Color? backgroundColor;

  /// The snack bar's icon leading.
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: backgroundColor ?? context.colorScheme.primary,
      ),
      child: ListTile(
        leading: leading,
        horizontalTitleGap: 12,
        minLeadingWidth: 4,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        title: CABodyMediumText(text: text, color: textColor),
      ),
    );
  }
}

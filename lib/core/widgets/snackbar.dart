import 'package:chat_app/core/themes/app_palette.dart';
import 'package:chat_app/core/widgets/text.dart';
import 'package:flutter/material.dart';

/// A utility class for displaying snack bars with different styles.
///
/// Contains static methods for displaying snack bars with [error] and
/// [success] styles.
class CASnackBar {
  /// Displays a snack bar with the error style.
  ///
  /// The [message] parameter is the text to be displayed in the snack bar.
  static void error(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(CASnackBarContentError(context, message: message));
  }

  /// Displays a snack bar with the success style.
  ///
  /// The [message] parameter is the text to be displayed in the snack bar.
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
  /// Constructs a [CASnackBarContentError].
  ///
  /// The [context] is used to find the [ScaffoldMessenger] and display the
  /// snack bar. The [message] is the text to be displayed in the snack bar.
  /// Defaults to an empty string if not provided.
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
          backgroundColor: CAPalette.error,
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
  /// Constructs a [CASnackBarContentSuccess].
  ///
  /// The [context] is used to find the [ScaffoldMessenger] and display the
  /// snack bar. The [message] is the text to be displayed in the snack bar.
  /// Defaults to an empty string if not provided.
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
  /// Constructs a [_SnackBarContent].
  ///
  /// The [text] will default to the empty string if not supplied.
  /// The [textColor] will default to `Colors.white` if not supplied.
  /// The [backgroundColor] will default to `CAPalette.primaryBlue` if not
  /// supplied.
  /// The [leading] will default to `null` if not supplied.
  const _SnackBarContent({
    this.text = '',
    this.textColor = Colors.white,
    this.backgroundColor = CAPalette.primaryBlue,
    this.leading,
  });

  /// The text to be displayed in the snack bar.
  final String text;

  /// The color of the text.
  final Color textColor;

  /// The snack bar's background color.
  final Color backgroundColor;

  /// The snack bar's icon leading.
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: backgroundColor,
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

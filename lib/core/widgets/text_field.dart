import 'package:chat_app/core/themes/themes.dart';
import 'package:chat_app/core/widgets/assets.dart';
import 'package:chat_app/core/widgets/text.dart';
import 'package:flutter/material.dart';

class CATextField extends StatefulWidget {
  const CATextField({
    this.errorMessage,
    this.title,
    this.hintText,
    this.suffixIcon,
    super.key,
  });

  /// The title of the text field, displayed above the input field.
  final String? title;

  /// The hint text of the text field, displayed as a Material Design label.
  final String? hintText;

  /// The error message of the text field, displayed as a Material Design
  /// error message.
  final String? errorMessage;

  /// The suffix icon of the text field, displayed as an icon suffix.
  final Widget? suffixIcon;

  @override
  State<CATextField> createState() => _CATextFieldState();
}

class _CATextFieldState extends State<CATextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          CATitleMediumText(text: widget.title!),
          SizedBox(height: 8),
        ],
        TextField(
          decoration: InputDecoration(
            hintText: widget.hintText,
            errorText: widget.errorMessage == null ? null : '',
            suffixIcon: widget.suffixIcon,
          ),
        ),
        if (widget.errorMessage != null) ...[
          SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CAAssets.error(),
              SizedBox(width: 8),
              CABodyMediumText(
                text: widget.errorMessage!,
                color: CAPalette.error,
              ),
            ],
          ),
        ] else
          SizedBox(height: 28),
      ],
    );
  }
}

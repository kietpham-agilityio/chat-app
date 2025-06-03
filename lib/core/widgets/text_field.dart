import 'package:chat_app/core/themes/themes.dart';
import 'package:chat_app/core/widgets/assets.dart';
import 'package:chat_app/core/widgets/text.dart';
import 'package:flutter/material.dart';

class CATextField extends StatefulWidget {
  const CATextField({
    this.obscureText = false,
    this.readOnly = false,
    this.autofocus = false,
    this.hasValidation = true,
    this.enabled = true,
    this.errorMessage,
    this.title,
    this.hintText,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.focusNode,
    this.onFocusLost,
    this.ontap,
    this.controller,
    this.initValue,
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

  /// A callback that is called when the text changes.
  ///
  /// This callback is useful for validating the user's input or for
  /// performing some action when the text changes.
  final ValueChanged<String>? onChanged;

  /// A callback that is called when the text is submitted.
  ///
  /// This callback is useful for submitting the user's input or for
  /// performing some action when the text is submitted.
  final ValueChanged<String>? onSubmitted;

  /// The type of keyboard to display for the text field.
  ///
  /// This value is useful for constraining the user's input to a specific
  /// type of data, such as a phone number or a password.
  final TextInputType? keyboardType;

  /// The focus node of the text field.
  ///
  /// This value is useful for customizing the focus behavior of the text
  /// field or for observing the focus state of the text field.
  final FocusNode? focusNode;

  /// A callback that is called when the text field loses focus.
  ///
  /// This callback is useful for performing some action when the text
  /// field loses focus, such as validating the user's input.
  final VoidCallback? onFocusLost;

  /// A boolean that indicates whether the text is obscured or not.
  ///
  /// This value is useful for creating password fields that obscure the
  /// user's input.
  final bool obscureText;

  /// A boolean that indicates whether the text field is read-only or not.
  ///
  /// If this value is `true`, the text field is read-only and the user
  /// cannot edit the text. If this value is `false`, the text field is
  /// editable and the user can edit the text.
  final bool readOnly;

  /// A boolean that indicates whether the text field should receive focus
  /// immediately when it is created.
  ///
  /// If this value is `true`, the text field receives focus immediately when
  /// it is created. If this value is `false`, the text field does not receive
  /// focus immediately when it is created.
  final bool autofocus;

  /// A callback that is called when the user taps on the text field.
  ///
  /// This callback is useful for customizing the behavior of the text field
  /// when the user taps on it.
  final VoidCallback? ontap;

  final TextEditingController? controller;

  final bool hasValidation;

  final bool enabled;

  final String? initValue;

  @override
  State<CATextField> createState() => _CATextFieldState();
}

class _CATextFieldState extends State<CATextField> {
  late final FocusNode? _focusNode;
  late final TextEditingController? _controller;

  @override
  void initState() {
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.controller ?? TextEditingController();

    if (widget.initValue != null && widget.controller == null) {
      _controller?.text = widget.initValue!;
    }
    _focusNode?.addListener(() {
      if (!_focusNode.hasFocus) {
        widget.onFocusLost?.call();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    super.dispose();
  }

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
          focusNode: widget.focusNode,
          controller: _controller,
          obscureText: widget.obscureText,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          decoration: InputDecoration(
            hintText: widget.hintText,
            errorText: widget.errorMessage == null ? null : '',
            suffixIcon: widget.suffixIcon,
          ),
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          keyboardType: widget.keyboardType,
          style: TextStyle(
            fontFamily: CATypography.fontSFProText,
            fontSize: CATypography.fontSizeBodyLarge,
            fontWeight: FontWeight.w400,
            height: CATypography.heightBodyLarge,
            color: CAPalette.grey[5],
          ),
          onTap: widget.ontap,
        ),
        if (widget.hasValidation) ...[
          if (widget.errorMessage != null) ...[
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
            SizedBox(height: 20),
        ],
      ],
    );
  }
}

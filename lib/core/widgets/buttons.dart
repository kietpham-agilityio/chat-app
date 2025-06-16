import 'package:flutter/material.dart';

// MARK: - ElevatedButton
/// A convenience wrapper around the [ElevatedButton] widget.
///
/// This widget exposes the main properties of the [ElevatedButton] widget, but
/// with some changes to make it easier to use:
///
/// * The button's text font size is customizable.
/// * The button can be disabled.
class CAElevatedButton extends StatefulWidget {
  const CAElevatedButton({
    required this.text,
    this.isDisabled = false,
    this.onPressed,
    this.value,
    this.backgroundColor,
    this.foregroundColor,
    this.minHeight,
    super.key,
  });

  /// The button's text.
  final String text;

  /// Whether the button is disabled.
  final bool isDisabled;

  /// The callback to be called when the button is pressed.
  final VoidCallback? onPressed;

  /// The button's text font size.
  final double? value;

  final Color? backgroundColor;

  final Color? foregroundColor;

  final double? minHeight;

  @override
  State<CAElevatedButton> createState() => _CAElevatedButtonState();
}

class _CAElevatedButtonState extends State<CAElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.isDisabled ? null : widget.onPressed,
      style: ButtonStyle(
        backgroundColor: widget.backgroundColor != null
            ? WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.disabled)) {
                  return widget.backgroundColor!.withValues(
                    alpha: 0.5, // Fully opaque
                  );
                }

                return widget.backgroundColor!;
              })
            : null,
        foregroundColor: widget.foregroundColor != null
            ? WidgetStatePropertyAll<Color>(widget.foregroundColor!)
            : null,
      ),
      child: Text(widget.text, style: TextStyle(fontSize: widget.value)),
    );
  }
}

// MARK: IconButton
/// A convenience wrapper around the [IconButton] widget.
///
/// This widget exposes the main properties of the [IconButton] widget, but
/// with some changes to make it easier to use:
///
/// * The button's background color is customizable.
/// * The button's size is customizable.
class CAIconButtons extends StatelessWidget {
  const CAIconButtons({
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.size,
    super.key,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(backgroundColor: backgroundColor),
      constraints: BoxConstraints(maxWidth: size ?? 40, maxHeight: size ?? 40),
      icon: icon,
      onPressed: onPressed,
    );
  }
}

// MARK: TextButton
/// A convenience wrapper around the [TextButton] widget.
///
/// This widget exposes the main properties of the [TextButton] widget, but
/// with some changes to make it easier to use:
///
/// * The button's text color is customizable.
/// * The button's press color is customizable.
/// * The button's overlay color is set to transparent.
class CATextButtons extends StatelessWidget {
  const CATextButtons({
    required this.text,
    this.onPressed,
    this.color,
    super.key,
  });

  final String text;
  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: onPressed, child: Text(text));
  }
}

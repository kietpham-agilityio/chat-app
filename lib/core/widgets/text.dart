import 'package:chat_app/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

//MARK: - Text Widget
/// A widget that displays text with customizable styling, alignment, and line constraints.
///
/// The [CAText] widget is a wrapper around the [Text] widget, allowing you to specify
/// the text to display, optional styling, text alignment, and the maximum number of lines
/// to display.
class CAText extends StatelessWidget {
  const CAText({
    required this.text,
    this.style,
    this.textAlign,
    this.maxLines,
    super.key,
  });

  /// The text to display.
  final String text;

  /// The style to use for the text.
  ///
  /// If null, the text will use the default text style from the [TextTheme].
  final TextStyle? style;

  /// How the text should be aligned horizontally.
  ///
  /// If null, the text will be aligned according to the default alignment.
  final TextAlign? textAlign;

  /// The maximum number of lines for the text to span, wrapping if necessary.
  ///
  /// If null, the text will be allowed to display across as many lines as necessary.
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      textAlign: textAlign,
      key: key,
      style: style,
    );
  }
}

//MARK: - Headline Small Text
/// A widget that displays text in the headline small style.
///
/// The [CAHeadlineSmallText] widget is a convenience wrapper around the [CAText]
/// widget, using the headline small style from the [TextTheme].
///
/// You can customize the text color, alignment, font weight, and overflow
/// behavior of the widget.
class CAHeadlineSmallText extends StatelessWidget {
  const CAHeadlineSmallText({
    required this.text,
    this.color,
    this.textAlign,
    this.fontWeight,
    this.overflow,
    super.key,
  });

  /// The text to display.
  final String text;

  /// The color to use for the text.
  ///
  /// If null, the text will use the default text color from the [TextTheme].
  final Color? color;

  /// How the text should be aligned horizontally.
  ///
  /// If null, the text will be aligned according to the default alignment.
  final TextAlign? textAlign;

  /// The font weight to use for the text.
  ///
  /// If null, the text will use the default font weight from the [TextTheme].
  final FontWeight? fontWeight;

  /// The behavior to use when the text overflows the available space.
  ///
  /// If null, the text will use the default overflow behavior from the [TextTheme].
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return CAText(
      text: text,
      textAlign: textAlign,
      style: context.textTheme.headlineSmall?.copyWith(
        color: color,
        fontWeight: fontWeight,
        overflow: overflow,
        fontSize: context.textTheme.headlineSmall?.fontSize ?? 24,
      ),
    );
  }
}

//MARK: - Title Large Text
/// A widget that displays text in the title large style.
///
/// The [CATitleLargeText] widget is a convenience wrapper around the [CAText]
/// widget, using the headline small style from the [TextTheme].
///
/// You can customize the text color, alignment, font weight, and overflow
/// behavior of the widget.
class CATitleLargeText extends StatelessWidget {
  const CATitleLargeText({
    required this.text,
    this.color,
    this.textAlign,
    this.fontWeight,
    this.overflow,
    super.key,
  });

  /// The text to display.
  final String text;

  /// The color to use for the text.
  ///
  /// If null, the text will use the default text color from the [TextTheme].
  final Color? color;

  /// How the text should be aligned horizontally.
  ///
  /// If null, the text will be aligned according to the default alignment.
  final TextAlign? textAlign;

  /// The font weight to use for the text.
  ///
  /// If null, the text will use the default font weight from the [TextTheme].
  final FontWeight? fontWeight;

  /// The behavior to use when the text overflows the available space.
  ///
  /// If null, the text will use the default overflow behavior from the [TextTheme].
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return CAText(
      text: text,
      textAlign: textAlign,
      style: context.textTheme.titleLarge?.copyWith(
        color: color,
        fontWeight: fontWeight,
        overflow: overflow,
        fontSize: context.textTheme.titleLarge?.fontSize ?? 20,
      ),
    );
  }
}

//MARK: - Title Medium Text
/// A widget that displays text in the title medium style.
///
/// The [CATitleMediumText] widget is a convenience wrapper around the [CAText]
/// widget, using the headline small style from the [TextTheme].
///
/// You can customize the text color, alignment, font weight, and overflow
/// behavior of the widget.
class CATitleMediumText extends StatelessWidget {
  const CATitleMediumText({
    required this.text,
    this.color,
    this.textAlign,
    this.fontWeight,
    this.overflow,
    super.key,
  });

  /// The text to display.
  final String text;

  /// The color to use for the text.
  ///
  /// If null, the text will use the default text color from the [TextTheme].
  final Color? color;

  /// How the text should be aligned horizontally.
  ///
  /// If null, the text will be aligned according to the default alignment.
  final TextAlign? textAlign;

  /// The font weight to use for the text.
  ///
  /// If null, the text will use the default font weight from the [TextTheme].
  final FontWeight? fontWeight;

  /// The behavior to use when the text overflows the available space.
  ///
  /// If null, the text will use the default overflow behavior from the [TextTheme].
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return CAText(
      text: text,
      textAlign: textAlign,
      style: context.textTheme.titleMedium?.copyWith(
        color: color,
        fontWeight: fontWeight,
        overflow: overflow,
        fontSize: context.textTheme.titleMedium?.fontSize ?? 20,
      ),
    );
  }
}

//MARK: - Body Large Text
/// A widget that displays text in the body large style.
///
/// The [CABodyLargeText] widget is a convenience wrapper around the [CAText]
/// widget, using the headline small style from the [TextTheme].
///
/// You can customize the text color, alignment, font weight, and overflow
/// behavior of the widget.
class CABodyLargeText extends StatelessWidget {
  const CABodyLargeText({
    required this.text,
    this.color,
    this.textAlign,
    this.fontWeight,
    this.overflow,
    super.key,
  });

  /// The text to display.
  final String text;

  /// The color to use for the text.
  ///
  /// If null, the text will use the default text color from the [TextTheme].
  final Color? color;

  /// How the text should be aligned horizontally.
  ///
  /// If null, the text will be aligned according to the default alignment.
  final TextAlign? textAlign;

  /// The font weight to use for the text.
  ///
  /// If null, the text will use the default font weight from the [TextTheme].
  final FontWeight? fontWeight;

  /// The behavior to use when the text overflows the available space.
  ///
  /// If null, the text will use the default overflow behavior from the [TextTheme].
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return CAText(
      text: text,
      textAlign: textAlign,
      style: context.textTheme.bodyLarge?.copyWith(
        color: color,
        fontWeight: fontWeight,
        overflow: overflow,
        fontSize: context.textTheme.bodyLarge?.fontSize ?? 20,
      ),
    );
  }
}

//MARK: - Body Medium Text
/// A widget that displays text in the body medium style.
///
/// The [CABodyMediumText] widget is a convenience wrapper around the [CAText]
/// widget, using the headline small style from the [TextTheme].
///
/// You can customize the text color, alignment, font weight, and overflow
/// behavior of the widget.
class CABodyMediumText extends StatelessWidget {
  const CABodyMediumText({
    required this.text,
    this.color,
    this.textAlign,
    this.fontWeight,
    this.overflow,
    super.key,
  });

  /// The text to display.
  final String text;

  /// The color to use for the text.
  ///
  /// If null, the text will use the default text color from the [TextTheme].
  final Color? color;

  /// How the text should be aligned horizontally.
  ///
  /// If null, the text will be aligned according to the default alignment.
  final TextAlign? textAlign;

  /// The font weight to use for the text.
  ///
  /// If null, the text will use the default font weight from the [TextTheme].
  final FontWeight? fontWeight;

  /// The behavior to use when the text overflows the available space.
  ///
  /// If null, the text will use the default overflow behavior from the [TextTheme].
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return CAText(
      text: text,
      textAlign: textAlign,
      style: context.textTheme.bodyMedium?.copyWith(
        color: color,
        fontWeight: fontWeight,
        overflow: overflow,
        fontSize: context.textTheme.bodyMedium?.fontSize ?? 20,
      ),
    );
  }
}

//MARK: - Body Small Text
/// A widget that displays text in the body small style.
///
/// The [CABodySmallText] widget is a convenience wrapper around the [CAText]
/// widget, using the headline small style from the [TextTheme].
///
/// You can customize the text color, alignment, font weight, and overflow
/// behavior of the widget.
class CABodySmallText extends StatelessWidget {
  const CABodySmallText({
    required this.text,
    this.color,
    this.textAlign,
    this.fontWeight,
    this.overflow,
    super.key,
  });

  /// The text to display.
  final String text;

  /// The color to use for the text.
  ///
  /// If null, the text will use the default text color from the [TextTheme].
  final Color? color;

  /// How the text should be aligned horizontally.
  ///
  /// If null, the text will be aligned according to the default alignment.
  final TextAlign? textAlign;

  /// The font weight to use for the text.
  ///
  /// If null, the text will use the default font weight from the [TextTheme].
  final FontWeight? fontWeight;

  /// The behavior to use when the text overflows the available space.
  ///
  /// If null, the text will use the default overflow behavior from the [TextTheme].
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return CAText(
      text: text,
      textAlign: textAlign,
      style: context.textTheme.bodySmall?.copyWith(
        color: color,
        fontWeight: fontWeight,
        overflow: overflow,
        fontSize: context.textTheme.bodySmall?.fontSize ?? 20,
      ),
    );
  }
}

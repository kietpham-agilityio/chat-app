import 'package:chat_app/core/themes/app_palette.dart';
import 'package:flutter/material.dart';

class CAColor {
  static ColorScheme light = ColorScheme(
    brightness: Brightness.light,
    primary: CAPalette.primaryBlue,
    onPrimary: CAPalette.genericWhite,
    secondary: CAPalette.grey[2]!,
    onSecondary: CAPalette.genericBlack,
    error: CAPalette.error,
    onError: CAPalette.genericWhite,
    surface: CAPalette.genericWhite,
    onSurface: CAPalette.genericBlack,
    tertiary: CAPalette.grey[1]!,
    tertiaryFixedDim: CAPalette.grey[3]!,
    tertiaryFixed: CAPalette.grey[4]!,
    tertiaryContainer: CAPalette.grey[5]!,
    scrim: CAPalette.grey[6]!,
  );
}

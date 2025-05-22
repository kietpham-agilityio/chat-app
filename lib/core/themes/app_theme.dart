import 'package:flutter/material.dart';

import 'themes.dart';

class CATheme {
  static ThemeData get light {
    final defaultTheme = ThemeData.light(useMaterial3: true);

    return defaultTheme.copyWith(
      brightness: Brightness.light,
      colorScheme: CAColor.light,

      scaffoldBackgroundColor: CAPalette.genericWhite,

      /// Icon Theme
      iconTheme: _iconTheme,

      // / Text Theme
      textTheme: _textTheme,
    );
  }

  static final _iconTheme = IconThemeData(size: 24, color: CAPalette.grey[6]);

  static final _textTheme = TextTheme(
    headlineSmall: TextStyle(
      fontFamily: CATypography.fontSFProText,
      fontSize: CATypography.fontSizeTitleLarge,
      fontWeight: FontWeight.w600,
      height: CATypography.heightHeadlineSmall,
      color: CAPalette.genericBlack,
    ),
    titleLarge: TextStyle(
      fontFamily: CATypography.fontSFProText,
      fontSize: CATypography.fontSizeTitleLarge,
      fontWeight: FontWeight.w600,
      height: CATypography.heightTitleLarge,
      color: CAPalette.genericBlack,
    ),
    titleMedium: TextStyle(
      fontFamily: CATypography.fontSFProText,
      fontSize: CATypography.fontSizeTitleMedium,
      fontWeight: FontWeight.w600,
      height: CATypography.heightTitleMedium,
      color: CAPalette.genericBlack,
    ),
    bodyLarge: TextStyle(
      fontFamily: CATypography.fontSFProText,
      fontSize: CATypography.fontSizeBodyLarge,
      fontWeight: FontWeight.w400,
      height: CATypography.heightBodyLarge,
      color: CAPalette.genericBlack,
    ),
    bodyMedium: TextStyle(
      fontFamily: CATypography.fontSFProText,
      fontSize: CATypography.fontSizeBodyMedium,
      fontWeight: FontWeight.w400,
      height: CATypography.heightBodyMedium,
      color: CAPalette.genericBlack,
    ),
    bodySmall: TextStyle(
      fontFamily: CATypography.fontSFProText,
      fontSize: CATypography.fontSizeBodySmall,
      fontWeight: FontWeight.w400,
      height: CATypography.heightBodySmall,
      color: CAPalette.genericBlack,
    ),
  );
}

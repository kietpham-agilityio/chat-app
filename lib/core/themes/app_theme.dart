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

      /// Button Theme
      elevatedButtonTheme: _buttonTheme,

      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.pressed)) {
              return CAPalette.primaryBlue.withValues(alpha: 0.5);
            }
            return CAPalette.primaryBlue;
          }),
        ),
      ),
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

  static final _buttonTheme = ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return CAPalette.primaryBlue.withValues(
            alpha: 0.5, // Fully opaque
          );
        }

        return CAPalette.primaryBlue; // Default background color
      }),
      overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.pressed)) {
          return CAPalette.genericWhite.withValues(alpha: 0.12);
        }

        return null;
      }),
      foregroundColor: WidgetStatePropertyAll<Color>(CAPalette.genericWhite),
      minimumSize: WidgetStatePropertyAll<Size>(Size.fromHeight(48)),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // 12px radius for corners
        ),
      ),
      elevation: WidgetStateProperty.all<double>(0), // No built-in elevation
      textStyle: WidgetStateProperty.all<TextStyle>(
        TextStyle(
          fontFamily: CATypography.fontSFProText,
          fontSize: CATypography.fontSizeTitleMedium,
          fontWeight: FontWeight.w700,
          height: CATypography.heightTitleMedium,
          color: CAPalette.genericWhite,
        ),
      ),
    ),
  );
}

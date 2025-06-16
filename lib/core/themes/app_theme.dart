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
          textStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
            return TextStyle(
              fontFamily: CATypography.fontSFProText,
              fontSize: CATypography.fontSizeTitleMedium,
              fontWeight: FontWeight.w600,
              height: CATypography.heightTitleMedium,
              color: CAPalette.primaryBlue,
            );
          }),
        ),
      ),

      /// Divider Theme
      dividerTheme: _dividerTheme,

      /// ListTile Theme
      listTileTheme: _listTileTheme,

      /// AppBar Theme
      appBarTheme: _appBarTheme,

      /// Input decoration Theme
      inputDecorationTheme: _inputDecorationTheme,
    );
  }

  static final _iconTheme = IconThemeData(size: 24, color: CAPalette.grey[6]);

  static final _textTheme = TextTheme(
    headlineMedium: TextStyle(
      fontFamily: CATypography.fontSFProText,
      fontSize: CATypography.fontSizeHeadlineMedium,
      fontWeight: FontWeight.w600,
      height: CATypography.heightHeadlineMedium,
      color: CAPalette.genericBlack,
    ),
    headlineSmall: TextStyle(
      fontFamily: CATypography.fontSFProText,
      fontSize: CATypography.fontSizeHeadlineSmall,
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
        // if (states.contains(WidgetState.pressed)) {
        //   return CAPalette.primaryBlue.withValues(alpha: 0.5);
        // }
        if (states.contains(WidgetState.disabled)) {
          return CAPalette.primaryBlue.withValues(alpha: 0.5);
        }

        return CAPalette.primaryBlue;
      }),
      overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.pressed)) {
          return CAPalette.genericWhite.withValues(alpha: 0.12);
        }

        return null;
      }),
      // foregroundColor: WidgetStatePropertyAll<Color>(CAPalette.genericWhite),
      foregroundColor: WidgetStatePropertyAll<Color>(CAPalette.grey[1]!),
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

  static final _dividerTheme = DividerThemeData(color: CAPalette.grey[2]);

  static final _listTileTheme = ListTileThemeData(
    horizontalTitleGap: 8,
    titleTextStyle: TextStyle(
      fontFamily: CATypography.fontSFProText,
      fontSize: CATypography.fontSizeBodyLarge,
      fontWeight: FontWeight.w400,
      height: CATypography.heightBodyLarge,
      color: CAPalette.grey[5],
    ),
    subtitleTextStyle: TextStyle(
      fontFamily: CATypography.fontSFProText,
      fontSize: CATypography.fontSizeBodyMedium,
      fontWeight: FontWeight.w400,
      height: CATypography.heightBodyMedium,
      color: CAPalette.grey[4],
    ),
    leadingAndTrailingTextStyle: TextStyle(
      fontFamily: CATypography.fontSFProText,
      fontSize: CATypography.fontSizeBodyMedium,
      fontWeight: FontWeight.w400,
      height: CATypography.heightBodyMedium,
      color: CAPalette.grey[4],
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 24),
  );

  static final _appBarTheme = AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0,
    foregroundColor: CAPalette.grey[6],
    titleTextStyle: TextStyle(
      fontFamily: CATypography.fontSFProText,
      fontSize: CATypography.fontSizeTitleMedium,
      fontWeight: FontWeight.w700,
      height: CATypography.heightTitleMedium,
      color: CAPalette.grey[6],
    ),
  );

  static final _inputDecorationTheme = InputDecorationTheme(
    /// The Cursor color use the value of ColorScheme.primary
    filled: true,
    fillColor: CAPalette.grey[7],
    prefixIconColor: CAPalette.genericWhite,
    suffixIconColor: CAPalette.genericWhite,
    constraints: BoxConstraints.tight(const Size.fromHeight(48)),

    contentPadding: const EdgeInsets.symmetric(horizontal: 16),

    suffixIconConstraints: const BoxConstraints(minWidth: 24, minHeight: 24),

    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: CAPalette.grey[3]!),
      borderRadius: const BorderRadius.all(Radius.circular(8)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: CAPalette.grey[3]!),
      borderRadius: const BorderRadius.all(Radius.circular(8)),
    ),
    floatingLabelBehavior: FloatingLabelBehavior.never,
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: CAPalette.error, width: 2),
      borderRadius: const BorderRadius.all(Radius.circular(8)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: CAPalette.error, width: 2),
      borderRadius: const BorderRadius.all(Radius.circular(8)),
    ),
    hintStyle: TextStyle(
      fontFamily: CATypography.fontSFProText,
      fontSize: CATypography.fontSizeBodyLarge,
      fontWeight: FontWeight.w400,
      height: CATypography.heightBodyLarge,
      color: CAPalette.grey[4],
    ),
    errorStyle: TextStyle(height: -1),
  );
}

import 'package:flutter/material.dart';

import 'themes.dart';

class CATheme {
  static ThemeData get light {
    final defaultTheme = ThemeData.light(useMaterial3: true);

    return defaultTheme.copyWith(
      brightness: Brightness.light,
      colorScheme: CAColor.light,

      scaffoldBackgroundColor: CAPalette.genericWhite,
    );
  }
}

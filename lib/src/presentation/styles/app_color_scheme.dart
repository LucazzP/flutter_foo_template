import 'package:flutter/material.dart';

import 'app_theme_data.dart';

class AppColorScheme {
  static ColorScheme get colorScheme => AppThemeData.isDark ? colorSchemeDark : colorSchemeLight;

  static final ColorScheme colorSchemeLight = ColorScheme.fromSwatch(
    backgroundColor: const Color(0xffFFFFFF),
    accentColor: accentColor,
    primarySwatch: primarySwatch,
    errorColor: feedbackDangerBase,
  ).copyWith(onPrimary: white);

  static final ColorScheme colorSchemeDark = ColorScheme.fromSwatch(
    brightness: Brightness.dark,
    backgroundColor: const Color(0xff32353D),
    accentColor: accentColor,
    primarySwatch: primarySwatch,
    errorColor: feedbackDangerDark,
  ).copyWith(onPrimary: white);

  /// http://mcg.mbitson.com/
  static const MaterialColor primarySwatch = MaterialColor(0xff00b1e4, <int, Color>{
    50: primaryLightest,
    100: Color(0xFFB3E8F7),
    200: primaryLight,
    300: Color(0xFF4DC8EC),
    400: Color(0xFF26BDE8),
    500: primaryDefault,
    600: primaryMedium,
    700: Color(0xFF00A1DD),
    800: primaryDark,
    900: Color(0xFF0088D1),
  });

  static const MaterialColor accentColor = MaterialColor(0xffda609f, <int, Color>{
    100: accentLighest,
    200: accentLight,
    300: accentDefault,
    400: primaryMedium,
    700: primaryDark,
  });

  static const Color black = Color(0xff000000);
  static const Color white = Color(0xffFFFFFF);

  static const primaryDefault = Color(0xff00b1e4);
  static const primaryLightest = Color(0xffdef5fc);
  static const primaryLight = Color(0xff99e0f4);
  static const primaryMedium = Color(0xff66d0ef);
  static const primaryDark = Color(0xff009cc9);
  static const accentDefault = Color(0xffda609f);
  static const accentLighest = Color(0xfffde9f3);
  static const accentLight = Color(0xfff7bbd9);

  static const neutralDark = Color(0xff1f2933);
  static const feedbackDangerBase = Color(0xfff23548);
  static const feedbackDangerDark = Color(0xffcc2d3d);
  static const googleButton = Color.fromRGBO(231, 77, 60, 1);
  static const facebookButton = Color.fromRGBO(66, 103, 178, 1);
  static const appleButton = Color.fromRGBO(0, 0, 0, 1);
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_color_scheme.dart';
import 'app_text_theme.dart';

/// https://medium.com/flutter-community/page-transitions-using-themedata-in-flutter-c24afadb0b5d
class AppThemeData {
  static late bool _isDark;

  static void setIsDark(BuildContext context, {bool? isDark}) {
    _isDark = isDark ?? MediaQuery.maybeOf(context)?.platformBrightness == Brightness.dark;
  }

  static bool get isDark => _isDark;

  static ThemeData get themeData => isDark ? themeDataDark : themeDataLight;

  static final ThemeData themeDataLight = ThemeData(
    scaffoldBackgroundColor: AppColorScheme.primaryDefault,
    primaryTextTheme: const TextTheme(
      headline6: TextStyle(color: Colors.white),
    ),
    primaryColorBrightness: Brightness.dark,
    brightness: Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: AppTextTheme.textTheme,
    backgroundColor: AppColorScheme.primaryDefault,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
      },
    ),
    cupertinoOverrideTheme: const CupertinoThemeData(
      brightness: Brightness.light,
    ),
    iconTheme: IconThemeData(
      color: AppColorScheme.primarySwatch[500],
    ),
    buttonTheme: ButtonThemeData(
      colorScheme: AppColorScheme.colorSchemeLight,
      textTheme: ButtonTextTheme.primary,
      buttonColor: AppColorScheme.accentColor,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColorScheme.neutralDark,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
    ),
    colorScheme: AppColorScheme.colorSchemeLight.copyWith(
      primary: AppColorScheme.primarySwatch,
      secondary: AppColorScheme.accentColor,
    ),
  );

  static final ThemeData themeDataDark = ThemeData(
    primaryTextTheme: const TextTheme(
      headline6: TextStyle(color: Colors.white),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    brightness: Brightness.dark,
    textTheme: AppTextTheme.textTheme,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
      },
    ),
    cupertinoOverrideTheme: const CupertinoThemeData(
      brightness: Brightness.dark,
    ),
    iconTheme: IconThemeData(
      color: AppColorScheme.primarySwatch[500],
    ),
    buttonTheme: ButtonThemeData(
      colorScheme: AppColorScheme.colorSchemeDark,
      textTheme: ButtonTextTheme.primary,
      buttonColor: AppColorScheme.accentColor,
    ),
    colorScheme: AppColorScheme.colorSchemeDark.copyWith(
      primary: AppColorScheme.primarySwatch,
      secondary: AppColorScheme.accentColor,
    ),
  );
}

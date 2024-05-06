import 'package:flutter/material.dart';

// light
// onSurface = Colors.black
// onInverseSurface = surface = Colors.white
class AppTheme {
  static MaterialColor? colorSchemeSeed;
  //
  static ThemeData _lightTheme() {
    final colorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.green,
      errorColor: Colors.red,
    ).copyWith(
      surfaceTint: Colors.white, // ArlertDialog background
    );
    const hintColor = Colors.grey;

    return ThemeData.light().copyWith(
      colorScheme: colorScheme,
      primaryColor: colorScheme.primary,
      scaffoldBackgroundColor: colorScheme.surface,
      hintColor: hintColor,
    );
  }

  static ThemeData _darkTheme() {
    return ThemeData.dark();
  }

  static ThemeData lightTheme = _lightTheme();
  static ThemeData darkTheme = _darkTheme();
}

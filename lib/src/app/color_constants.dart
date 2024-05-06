import 'dart:math';

import 'package:flutter/material.dart';

import '../extensions/app_extensions.dart';

mixin class ColorConstants {
  //0xFF vao` hex
  // static final MaterialColor primaryColor = getMaterialColor(Colors.amber);
  // static final MaterialColor primaryDeepColor = getMaterialColor(const Color(0xFED67000));
  // Colors.grey.shade200
  static Color? disableFillColor(BuildContext context) {
    final fillColor = Theme.of(context).inputDecorationTheme.fillColor;
    if (fillColor == null) return null;
    return ColorConstants.getMaterialColor(fillColor).shade600.withOpacity(0.4);
  }

  //

  static Color hexToColor(String hex) {
    assert(hex.isHexColor, 'hex color must be #rrggbb or #rrggbbaa');

    return Color(
      int.parse(hex.substring(1), radix: 16) + (hex.length == 7 ? 0xff000000 : 0x00000000),
    );
  }

  //

  static MaterialColor getMaterialColor(Color color) {
    return MaterialColor(color.value, {
      50: tintColor(color, 0.9),
      100: tintColor(color, 0.8),
      200: tintColor(color, 0.6),
      300: tintColor(color, 0.4),
      400: tintColor(color, 0.2),
      500: color,
      600: shadeColor(color, 0.1),
      700: shadeColor(color, 0.2),
      800: shadeColor(color, 0.3),
      900: shadeColor(color, 0.4),
    });
  }

  static int tintValue(int value, double factor) => max(0, min((value + ((255 - value) * factor)).round(), 255));

  static Color tintColor(Color color, double factor) =>
      Color.fromRGBO(tintValue(color.red, factor), tintValue(color.green, factor), tintValue(color.blue, factor), 1);

  static int shadeValue(int value, double factor) => max(0, min(value - (value * factor).round(), 255));

  static Color shadeColor(Color color, double factor) =>
      Color.fromRGBO(shadeValue(color.red, factor), shadeValue(color.green, factor), shadeValue(color.blue, factor), 1);
}

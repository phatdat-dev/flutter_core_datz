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
    return ColorConstants.getMaterialColor(fillColor).shade600.withValues(alpha: 0.4);
  }

  //

  static Color hexToColor(String hex) {
    assert(hex.isHexColor, 'hex color must be #rrggbb or #rrggbbaa');

    return Color(int.parse(hex.substring(1), radix: 16) + (hex.length == 7 ? 0xff000000 : 0x00000000));
  }

  //

  static MaterialColor getMaterialColor(Color color) {
    return MaterialColor(color.toARGB32(), <int, Color>{
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

  //! https://stackoverflow.com/questions/79278159/warnings-after-upgrading-to-flutter-3-27-0-value-and-green-are-deprecated
  static Color tintColor(Color color, double factor) {
    return Color.fromRGBO(
      color.redd + ((255 - color.redd) * factor).round(),
      color.greenn + ((255 - color.greenn) * factor).round(),
      color.bluee + ((255 - color.bluee) * factor).round(),
      1,
    );
  }

  static Color shadeColor(Color color, double factor) {
    return Color.fromRGBO((color.redd * (1 - factor)).round(), (color.greenn * (1 - factor)).round(), (color.bluee * (1 - factor)).round(), 1);
  }
}

extension _ColorUtils on Color {
  int get redd => (r * 255).toInt();
  int get greenn => (g * 255).toInt();
  int get bluee => (b * 255).toInt();
  int get alphaa => (a * 255).toInt();

  // Combine the components into a single int using bit shifting
  // ignore: unused_element
  int toInt() => (alphaa << 24) | (redd << 16) | (greenn << 8) | bluee;
}

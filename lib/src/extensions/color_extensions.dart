import 'package:flutter/material.dart';

import '../app/color_constants.dart';

extension ColorExtension on Color {
  ColorFilter toColorFilter() => ColorFilter.mode(this, BlendMode.srcIn);

  MaterialColor toMaterialColor() => ColorConstants.getMaterialColor(this);
}

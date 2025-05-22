import 'package:flutter/material.dart';

import '../app/color_constants.dart';

extension ColorSchemeExtension on ColorScheme {
  MaterialColor get primaryMaterialColor =>
      ColorConstants.getMaterialColor(primary);
}

import 'package:material_ui/material_ui.dart';

import '../app/color_constants.dart';

extension ColorSchemeExtension on ColorScheme {
  MaterialColor get primaryMaterialColor =>
      ColorConstants.getMaterialColor(primary);
}

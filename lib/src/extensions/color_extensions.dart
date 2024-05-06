import 'package:flutter/material.dart';

extension ColorExtension on Color {
  ColorFilter toColorFilter() => ColorFilter.mode(this, BlendMode.srcIn);
}

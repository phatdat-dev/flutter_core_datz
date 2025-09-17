import 'package:flutter/material.dart';
import 'package:flutter_core_datz/flutter_core_datz.dart';

extension ScrollControllerExtension on ScrollController {
  bool get isScrolledToBottom => position.pixels >= position.maxScrollExtent;

  bool get isNearBottom => position.pixels >= (position.maxScrollExtent * 0.9);

  bool isNearBottomByThreshold(double threshold) {
    if (position.pixels == position.maxScrollExtent) return true;
    final double positionThreshold = position.maxScrollExtent - threshold;
    if (positionThreshold < 0) return false;

    Printt.cyan("${position.pixels}/$positionThreshold [$threshold/${position.maxScrollExtent}]");
    return position.pixels >= positionThreshold;
  }

  double get scrollPercentage {
    if (position.maxScrollExtent == 0) return 0;
    return (position.pixels / position.maxScrollExtent).clamp(0.0, 1.0);
  }

  void scrollToTopAnimated({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOut,
  }) {
    animateTo(
      0,
      duration: duration,
      curve: curve,
    );
  }
}

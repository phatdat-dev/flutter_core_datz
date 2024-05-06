import 'package:flutter/material.dart';

extension DateTimeRangeExtension on DateTimeRange {
  static DateTimeRange fromString(String value) {
    final dateRange = value.split(' - ');
    return DateTimeRange(
      start: DateTime.parse(dateRange[0]),
      end: DateTime.parse(dateRange[1]),
    );
  }
}

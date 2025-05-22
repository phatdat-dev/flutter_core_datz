import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

extension ValueListenableExtension<T> on ValueListenable<T> {
  Widget builder(
    Widget Function(BuildContext context, T value) builder, {

    /// Loading widget when value is null
    Widget? ifNull,
  }) {
    return ValueListenableBuilder<T>(
      valueListenable: this,
      builder: (context, value, child) {
        if (value == null) return ifNull ?? const Center(child: CircularProgressIndicator());
        return builder(context, value);
      },
    );
  }
}

extension FutureExtension<T> on Future<T> {
  Widget builder(
    AsyncWidgetBuilder<T> builder,
  ) {
    return FutureBuilder<T>(
      future: this,
      builder: builder,
    );
  }
}

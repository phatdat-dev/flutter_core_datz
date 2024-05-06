import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

extension ValueListenableExtension<T> on ValueListenable<T> {
  Widget builder(
    Widget Function(BuildContext context, T value) builder,
  ) {
    return ValueListenableBuilder<T>(
      valueListenable: this,
      builder: (context, value, child) => builder(context, value),
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

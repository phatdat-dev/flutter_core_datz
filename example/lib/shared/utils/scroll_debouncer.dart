import 'dart:async';

import 'package:flutter/foundation.dart';

class ScrollDebouncer {
  final Duration delay;
  Timer? _timer;

  ScrollDebouncer({this.delay = const Duration(milliseconds: 100)});

  void call(VoidCallback callback) {
    _timer?.cancel();
    _timer = Timer(delay, callback);
  }

  void dispose() {
    _timer?.cancel();
  }
}

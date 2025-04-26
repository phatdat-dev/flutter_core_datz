import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class Globals {
  static final kTestMode = !kIsWeb ? Platform.environment.containsKey('FLUTTER_TEST') : false;

  /// The key for the root navigator used in the app.
  /// Needed add it to the app_router.dart file.
  /// To use this key, you need to add it to the constructor of your AppRouter.
  /// Example:
  /// ```dart
  /// AppRouter() : super(navigatorKey: Globals.rootNavigatorKey);
  /// ```
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static BuildContext get context => rootNavigatorKey.currentContext!;
  static String lastCallUrlApi = "";
}

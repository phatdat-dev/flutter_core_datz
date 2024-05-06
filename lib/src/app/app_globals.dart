import 'dart:io';

import 'package:flutter/material.dart';

abstract class AppGlobals {
  static final kTestMode = Platform.environment.containsKey('FLUTTER_TEST');
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static BuildContext get context => rootNavigatorKey.currentContext!;
  static String lastCallUrlApi = "";
}

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class AppGlobals {
  static final kTestMode = !kIsWeb ? Platform.environment.containsKey('FLUTTER_TEST') : false;
  static late BuildContext context;
  static String lastCallUrlApi = "";
}

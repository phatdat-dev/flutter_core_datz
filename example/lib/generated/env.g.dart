// ignore_for_file: non_constant_identifier_names, unused_field

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppENV {
  static String get BASE_URL_PROD => dotenv.env['BASE_URL_PROD']!;
  static String get BASE_URL_DEV => dotenv.env['BASE_URL_DEV']!;
}

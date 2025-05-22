import 'package:flutter/foundation.dart';
import 'package:flutter_core_datz/flutter_core_datz.dart';

import '../../../generated/env.g.dart';

class DioNetworkService extends BaseDioNetworkService
    with DioNetworkServiceMixin, NetworkExceptionHandleMixin {
  //instance iniit dio
  DioNetworkService() {
    onInit();
  }

  @override
  String get baseUrl => kDebugMode ? AppENV.BASE_URL_DEV : AppENV.BASE_URL_PROD;

  @override
  String get apiKey => '';
}

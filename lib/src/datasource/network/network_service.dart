import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../flutter_core_datz.dart';

abstract interface class NetworkService {
  String get baseUrl;

  String get apiKey;

  Map<String, Object> get headers;

  int get timeOutSecond;
}

mixin NetworkExceptionHandleMixin on NetworkService {
  @protected
  void defaultLog(Response? response) {
    if (response == null) return;
    String message = '[${response.statusCode}]:\n${response.statusMessage}';
    HelperWidget.showToastError(message);
    Printt.red(message);
  }

  Future<void> handleErrorStatus(Response? response) async {
    if (response == null) return;

    switch (response.statusCode) {
      // case 400 || 500:
      case 500:
        final message = AppException.toMessageError(response.data!);

        HelperWidget.showToastError('[${response.statusCode}]:\n$message');
        break;

      case 400 || 404:
        // ko làm gì hết để trả về AppException
        break;

      case 401:
        await onUnauthorized(response);
        break;

      default:
        defaultLog(response);
        break;
    }
  }

  Future<void> onUnauthorized(Response? response) async {
    //Remove token
    // Global.StorageServiceerences.remove(StorageConstants.userAccount);
    // AuthenticationController.userAccount = null;
    // Global.rootNavigatorKey.currentContext!.go(Routes.LOGIN());
  }
}

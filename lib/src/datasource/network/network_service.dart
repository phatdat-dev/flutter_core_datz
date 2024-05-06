import 'package:dio/dio.dart';

import '../../utils/helper.dart';
import '../../utils/helper_widget.dart';
import '../../utils/utils.dart';

abstract interface class NetworkService {
  String get baseUrl;

  String get apiKey;

  Map<String, Object> get headers;

  int get timeOutSecond;
}

mixin NetworkExceptionHandleMixin on NetworkService {
  Future<void> handleErrorStatus(Response? response) async {
    if (response == null) return;
    void defaultLog() {
      String message = 'CODE (${response.statusCode}):\n${response.statusMessage}';
      HelperWidget.showToastError(message);
      Printt.red(message);
    }

    switch (response.statusCode) {
      // case 400 || 500:
      case 500:
        final message = Helper.toMessageError(response.data!);

        HelperWidget.showToastError('CODE (${response.statusCode}):\n$message');
        break;

      case 400 || 404:
        // ko làm gì hết để trả về AppException
        break;

      case 401:
        //401: Print token expired
        defaultLog();
        await onUnauthorized();
        break;

      default:
        defaultLog();
        break;
    }
  }

  Future<void> onUnauthorized() async {
    //Remove token
    // Global.StorageServiceerences.remove(StorageConstants.userAccount);
    // AuthenticationController.userAccount = null;
    // Global.rootNavigatorKey.currentContext!.go(Routes.LOGIN());
  }
}

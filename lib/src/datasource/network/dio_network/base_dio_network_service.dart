import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../app/globals.dart';
import '../../../models/base_model.dart';
import '../../../widgets/loadding_widget.dart';
import '../network_service.dart';
import 'my_log_interceptor.dart';

part 'dio_network_service_mixin.dart';

abstract class BaseDioNetworkService
    implements NetworkService, NetworkExceptionHandleMixin {
  //create dio
  late final Dio dio;

  @override
  Map<String, Object> get headers => {
    "Accept": "application/json, text/plain, */*",
    "Access-Control-Allow-Origin": "*",
    // "Access-Control-Allow-Methods": "GET,PUT,PATCH,POST,DELETE",
    // "Access-Control-Allow-Headers": "Origin, X-Requested-With, Content-Type, Accept",
    "Content-Type":
        "application/json;charset=UTF-8", // HttpHeaders.contentTypeHeader
  };
  @override
  int get timeOutSecond => 60;

  bool _isShowLoading = false;

  void onInit() {
    dio = Dio(
      BaseOptions(
        // Cấu hình đường path để call api, thành phần gồm
        // - options.path: đường dẫn cụ thể API. Ví dụ: "user/user-info"
        baseUrl: baseUrl,

        // Dùng để config timeout api từ phía client, tránh việc call 1 API
        // bị lỗi trả response quá lâu.
        sendTimeout: Duration(seconds: timeOutSecond),
        connectTimeout: Duration(seconds: timeOutSecond),
        receiveTimeout: Duration(seconds: timeOutSecond),

        headers: headers,
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (_isShowLoading) Loadding.show();

          // Gắn access_token vào header, gửi kèm access_token trong header mỗi khi call API
          if (apiKey.isNotEmpty) {
            options.headers["Authorization"] = apiKey;
          }
          // Update static lần cuối gọi API là gì...
          Globals.lastCallUrlApi = options.path;

          return handler.next(options);
        },
        onResponse: (Response response, handler) {
          Loadding.dismiss();
          return handler.next(response);
        },
        onError: (error, handler) async {
          Loadding.dismiss();
          await handleErrorStatus(error.response);
          return handler.next(error);
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(MyLogInterceptor());
    }
  }
}

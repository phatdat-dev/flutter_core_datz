import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../models/base_model.dart';
import '../network_service.dart';
import 'loading_interceptor.dart';
import 'my_log_interceptor.dart';

part 'dio_network_service_mixin.dart';

abstract class BaseDioNetworkService implements NetworkService, NetworkExceptionHandleMixin {
  //create dio
  late final Dio dio;

  bool _isShowLoading = false;

  bool get addLogInterceptor => kDebugMode;

  @override
  Map<String, Object> get headers => {
    "Accept": "application/json, text/plain, */*",
    "Access-Control-Allow-Origin": "*",
    "Content-Type": "application/json;charset=UTF-8", // HttpHeaders.contentTypeHeader
  };

  @override
  int get timeOutSecond => 60;

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
      LoadingInterceptor(
        isShowLoading: _isShowLoading,
        apiKey: apiKey,
        handleErrorStatus: handleErrorStatus,
      ),
    );

    if (addLogInterceptor) {
      dio.interceptors.add(MyLogInterceptor());
    }
  }
}

// ignore_for_file: use_build_context_synchronously, deprecated_member_use_from_same_package

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../flutter_core_datz.dart';

class AppException implements Exception, BaseModel<AppException> {
  DateTime? time;

  /// Milliseconds
  int? timeProcess;
  String? userName;
  String message;
  int? statusCode;
  String? urlApi;

  /// identifier is used to identify the exception
  String? identifier;

  String? infoDevice;

  /// route of app
  String? route;

  AppException({
    this.time,
    this.timeProcess,
    this.userName,
    this.message = "",
    this.statusCode,
    this.identifier,
    this.infoDevice,
    this.urlApi,
    this.route,
  }) {
    onInit();
  }

  void onInit() {
    Helper.getInfoDevice().then((value) => infoDevice = value);
    route = GoRouter.of(AppGlobals.context).location;
    time = DateTime.now();
  }

  factory AppException.fromJson(Map<String, dynamic> json) => AppException(
        time: DateTime.tryParse(json['time']),
        timeProcess: json['timeProcess'],
        userName: json['userName'],
        message: json['message'],
        statusCode: json['statusCode'],
        identifier: json['identifier'],
        infoDevice: json['infoDevice'],
        urlApi: json['urlApi'],
        route: json['route'],
      );

  @override
  AppException fromJson(Map<String, dynamic> json) => AppException.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    return {
      'time': time?.toIso8601String(),
      'timeProcess': timeProcess,
      'userName': userName,
      'message': message,
      'statusCode': statusCode,
      'identifier': identifier,
      'infoDevice': infoDevice,
      'urlApi': urlApi,
      'route': route,
    };
  }

  @override
  String toString() => jsonEncode(toJson());

  static String toMessageError(dynamic errorMessage) {
    String message = '';
    if (errorMessage is Map) {
      if (errorMessage.containsKey('error') || errorMessage.containsKey('message')) {
        if (errorMessage['error'] is Map) {
          //cho nay` bat' loi~ OpenAI
          message = errorMessage['error']['message'];
        } else {
          message = (errorMessage['message'] ?? errorMessage['error']).toString();
        }
      } else {
        errorMessage.forEach((key, value) {
          if (value is List) {
            message += '${value.join('\n')}\n';
          } else {
            message += value.toString();
          }
        });
      }
    } else {
      message = errorMessage.toString();
    }
    return message;
  }

  Future<Either<AppException, T>> handleExceptionAsync<T>(Future<T> Function() handler, {bool showToastError = true}) async {
    final stopWatch = Stopwatch();
    stopWatch.start();
    try {
      final val = await handler();

      // if (val == null) {
      //   message = 'Data is null';
      //   statusCode = 0;
      //   return Left(this);
      // }
      //
      stopWatch.stop();
      timeProcess = stopWatch.elapsed.inMilliseconds;
      return Right(val);
    } catch (ex) {
      // khi có lỗi tạo ra thì lưu lại
      GetIt.instance<AppExceptionController>().state.insert(0, this);
      onExceptionAsync(ex, stopWatch, showToastError);

      return Left(this);
    }
  }

  void onExceptionAsync(final Object ex, final Stopwatch stopWatch, bool showToastError) {
    if (ex is TimeoutException) {
      message = ex.message.toString();
      statusCode = 1;
    } else if (ex is SocketException) {
      message = ex.message;
      statusCode = 2;
    } else if (ex is DioException) {
      message = toMessageError(ex.response?.data);
      if (message == "null") message = ex.toString();
      statusCode = ex.response?.statusCode ?? 3;
      urlApi = ex.response?.requestOptions.uri.toString();
      //LINK - lib/shared/network/network_exception_handle_mixin.dart:20
    } else {
      message = ex.toString();
      statusCode = -1;
      urlApi = AppGlobals.lastCallUrlApi;
    }
    identifier = (identifier ?? "") + ex.runtimeType.toString();
    stopWatch.stop();
    timeProcess = stopWatch.elapsed.inMilliseconds;
    //
    if (showToastError) HelperWidget.showToastError('[$statusCode]:\n$message');
    //
    Printt.red(Helper.formatJsonString(toString()));
  }

  Either<AppException, T> handleException<T>(T Function() handler, {bool showToastError = true}) {
    final stopWatch = Stopwatch();
    stopWatch.start();
    try {
      final val = handler();

      stopWatch.stop();
      timeProcess = stopWatch.elapsed.inMilliseconds;
      return Right(val);
    } catch (ex) {
      // khi có lỗi tạo ra thì lưu lại
      GetIt.instance<AppExceptionController>().state.insert(0, this);
      onException(ex, stopWatch, showToastError);
      return Left(this);
    }
  }

  void onException(final Object ex, final Stopwatch stopWatch, bool showToastError) {
    message = ex.toString();
    statusCode = -1;
    urlApi = AppGlobals.lastCallUrlApi;
    //
    identifier = (identifier ?? "") + ex.runtimeType.toString();
    stopWatch.stop();
    timeProcess = stopWatch.elapsed.inMilliseconds;
    //
    if (showToastError) HelperWidget.showToastError('[$statusCode]:\n$message');
    //
    Printt.red(Helper.formatJsonString(toString()));
  }
}

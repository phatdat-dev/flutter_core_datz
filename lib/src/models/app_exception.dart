// ignore_for_file: use_build_context_synchronously, deprecated_member_use_from_same_package

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

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
    try {
      route = AutoRouter.of(Globals.context).currentPath;
    } catch (e) {
      route = Globals.lastCallUrlApi;
    }
    time = DateTime.now();
  }

  factory AppException.fromJson(Map<String, dynamic> json) => AppException(
    time: DateTime.tryParse(json['time'] ?? ''),
    timeProcess: json['timeProcess'],
    userName: json['userName'],
    message: json['message'] ?? '',
    statusCode: json['statusCode'],
    identifier: json['identifier'],
    infoDevice: json['infoDevice'],
    urlApi: json['urlApi'],
    route: json['route'],
  );

  @override
  AppException fromJson(Map<String, dynamic> json) =>
      AppException.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
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

  @override
  String toString() => jsonEncode(toJson());

  static String toMessageError(dynamic errorMessage) {
    if (errorMessage is Map) {
      if (errorMessage.containsKey('error') ||
          errorMessage.containsKey('message')) {
        final error = errorMessage['error'];
        return error is Map
            ? error['message'] ?? ''
            : (errorMessage['message'] ?? error).toString();
      }
      return errorMessage.entries
          .map((e) => e.value is List ? e.value.join('\n') : e.value.toString())
          .join('\n');
    }
    return errorMessage.toString();
  }

  Future<Either<AppException, T>> handleExceptionAsync<T>(
    Future<T> Function() handler, {
    bool showToastError = true,
  }) async {
    final stopWatch = Stopwatch()..start();
    try {
      final val = await handler();
      timeProcess = stopWatch.elapsedMilliseconds;
      return Right(val);
    } catch (ex) {
      return onException(ex, stopWatch, showToastError);
    }
  }

  Either<AppException, T> handleException<T>(
    T Function() handler, {
    bool showToastError = true,
  }) {
    final stopWatch = Stopwatch()..start();
    try {
      final val = handler();
      timeProcess = stopWatch.elapsedMilliseconds;
      return Right(val);
    } catch (ex) {
      return onException(ex, stopWatch, showToastError);
    }
  }

  Either<AppException, T> onException<T>(
    Object ex,
    Stopwatch stopWatch,
    bool showToastError,
  ) {
    stopWatch.stop();
    timeProcess = stopWatch.elapsedMilliseconds;
    message = onExtractMessageFromException(ex);
    identifier = (identifier ?? "") + ex.runtimeType.toString();

    if (showToastError &&
        GetIt.instance<NetworkConnectivityService>().isOnline) {
      HelperWidget.showToastError('[$statusCode]:\n$message');
    }

    Printt.red(Helper.formatJsonString(toString()));
    GetIt.instance<AppExceptionController>().state.insert(0, this);

    return Left(this);
  }

  String onExtractMessageFromException(Object ex) {
    if (ex is TimeoutException) {
      statusCode = 1;
      return ex.message ?? 'Timeout error';
    } else if (ex is SocketException) {
      statusCode = 2;
      return ex.message;
    } else if (ex is DioException) {
      statusCode = ex.response?.statusCode ?? 3;
      urlApi = ex.response?.requestOptions.uri.toString();
      var message = toMessageError(ex.response?.data);
      if (message == "null") message = ex.toString();
      return message;
    }
    statusCode = -1;
    urlApi = Globals.lastCallUrlApi;
    return ex.toString();
  }
}

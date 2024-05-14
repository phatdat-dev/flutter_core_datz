// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_core_datz/src/app/base_configs.dart';
import 'package:flutter_core_datz/src/utils/utils.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../app/app_globals.dart';
import '../extensions/app_extensions.dart';
import '../features/app_exception/app_exception_controller.dart';
import '../utils/helper.dart';
import '../utils/helper_widget.dart';
import 'base_model.dart';

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
    Helper.getInfoDevice().then((value) => infoDevice = value);
    route = GoRouter.of(AppGlobals.context).location;
    time = DateTime.now();
    baseConfigs.onCreateAppException?.call(this);
  }

  @override
  AppException fromJson(Map<String, dynamic> json) {
    return AppException(
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
  }

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

  Future<Either<AppException, T>> handleExceptionAsync<T>(Future<T> Function() handler, {bool showToast = true}) async {
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
      //
      if (ex is TimeoutException) {
        message = ex.message.toString();
        statusCode = 1;
      } else if (ex is SocketException) {
        message = ex.message;
        statusCode = 2;
      } else if (ex is DioException) {
        message = Helper.toMessageError(ex.response?.data);
        if (message == "null") message = "Server/Parse error";
        statusCode = ex.response?.statusCode ?? 3;
        urlApi = ex.response?.requestOptions.uri.toString();
        //
        if (statusCode == 404) showToast = false; //LINK - lib/shared/network/network_exception_handle_mixin.dart:20
      } else {
        message = ex.toString();
        statusCode = -1;
        urlApi = AppGlobals.lastCallUrlApi;
        Future.delayed(const Duration(seconds: 1), () {
          HelperWidget.showToastError("Có lỗi xảy ra, nhấn để xem >>");
        });
      }
      identifier = (identifier ?? "") + ex.runtimeType.toString();
      stopWatch.stop();
      timeProcess = stopWatch.elapsed.inMilliseconds;
      //
      if (showToast) HelperWidget.showToastError('[$statusCode]:\n$message');
      //
      Printt.red(Helper.formatJsonString(toString()));
      return Left(this);
    }
  }

  Either<AppException, T> handleException<T>(T Function() handler) {
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
      message = ex.toString();
      statusCode = -1;
      urlApi = AppGlobals.lastCallUrlApi;
      identifier = (identifier ?? "") + ex.runtimeType.toString();
      stopWatch.stop();
      timeProcess = stopWatch.elapsed.inMilliseconds;
      Printt.red(Helper.formatJsonString(toString()));
      return Left(this);
    }
  }
}

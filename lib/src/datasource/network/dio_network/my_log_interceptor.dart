import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../flutter_core_datz.dart';

/// [MyLogInterceptor] is used to print logs during network requests.
/// It should be the last interceptor added,
/// otherwise modifications by following interceptors will not be logged.
/// This is because the execution of interceptors is in the order of addition.
///
/// **Note**
/// When used in Flutter, make sure to use `debugPrint` to print logs.
/// Alternatively `dart:developer`'s `log` function can also be used.
///
/// ```dart
/// dio.interceptors.add(
///   MyLogInterceptor(
///    Printt.defaultt: (o) => debugPrint(o.toString()),
///   ),
/// );
/// ```
class MyLogInterceptor extends Interceptor {
  MyLogInterceptor({
    this.showTimeStamp = true,
    this.request = false,
    this.requestHeader = false,
    this.requestBody = true,
    //
    this.responseHeader = false,
    this.responseBody = true,
    //
    this.error = true,
  });

  /// show TimeStamp in logs
  bool showTimeStamp;

  /// Print request [Options]
  bool request;

  /// Print request header [Options.headers]
  bool requestHeader;

  /// Print request data [Options.data]
  bool requestBody;

  /// Print [Response.data]
  bool responseBody;

  /// Print [Response.headers]
  bool responseHeader;

  /// Print error message
  bool error;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final buffer = StringBuffer();

    buffer.writeln(StringPrintColor.defaultt('*** Request ***'));
    buffer.writeln(
      StringPrintColor.yellow('${showTimeStampString()}${options.method}: ${options.uri}'),
    );

    if (request) {
      buffer.writeln(StringPrintColor.defaultt('responseType: ${options.responseType.toString()}'));
      buffer.writeln(StringPrintColor.defaultt('followRedirects: ${options.followRedirects}'));
      buffer.writeln(StringPrintColor.defaultt('persistentConnection: ${options.persistentConnection}'));
      buffer.writeln(StringPrintColor.defaultt('connectTimeout: ${options.connectTimeout}'));
      buffer.writeln(StringPrintColor.defaultt('sendTimeout: ${options.sendTimeout}'));
      buffer.writeln(StringPrintColor.defaultt('receiveTimeout: ${options.receiveTimeout}'));
      buffer.writeln(StringPrintColor.defaultt('receiveDataWhenStatusError: ${options.receiveDataWhenStatusError}'));
      buffer.writeln(StringPrintColor.defaultt('extra: ${options.extra}'));
    }

    if (requestHeader) {
      buffer.writeln(StringPrintColor.defaultt('headers:'));
      options.headers.forEach((key, v) => buffer.writeln(StringPrintColor.defaultt(' $key: $v')));
    }

    if (requestBody) {
      buffer.writeln(StringPrintColor.defaultt('Data Request:'));
      if (options.data is FormData) {
        final formDataJson = jsonEncode(
          Map.fromEntries([
            ...(options.data as FormData).fields,
            ...(options.data as FormData).files.map(
              (e) => MapEntry(e.key, e.value.filename),
            ),
          ]),
        );
        formDataJson.split('\n').forEach((line) => buffer.writeln(StringPrintColor.green(line)));
      } else {
        final dataJson = jsonEncode(options.data);
        dataJson.split('\n').forEach((line) => buffer.writeln(StringPrintColor.green(line)));
      }
    }

    buffer.writeln(StringPrintColor.defaultt(''));

    // Print all at once
    log(buffer.toString());

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    _printResponse(response);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (error) {
      final buffer = StringBuffer();

      buffer.writeln(StringPrintColor.red('*** DioException ***:'));
      buffer.writeln(StringPrintColor.yellow('${showTimeStampString()}${err.requestOptions.method}: ${err.requestOptions.uri}'));
      buffer.writeln(StringPrintColor.red('$err'));

      if (err.response != null) {
        buffer.writeln(StringPrintColor.red(''));

        // Print all at once
        log(buffer.toString());

        _printResponse(err.response!);
      } else {
        buffer.writeln(StringPrintColor.red(''));

        // Print all at once
        log(buffer.toString());
      }
    }

    handler.next(err);
  }

  void _printResponse(Response response) {
    final buffer = StringBuffer();
    buffer.writeln(StringPrintColor.defaultt('*** Response ***'));
    // Add method and URI with yellow color
    buffer.writeln(StringPrintColor.yellow('${showTimeStampString()}${response.requestOptions.method}: ${response.requestOptions.uri}'));

    if (responseHeader) {
      buffer.writeln(StringPrintColor.defaultt('statusCode: ${response.statusCode}'));
      if (response.isRedirect == true) {
        buffer.writeln(StringPrintColor.defaultt('redirect: ${response.realUri}'));
      }

      buffer.writeln(StringPrintColor.defaultt('headers:'));
      response.headers.forEach((key, v) => buffer.writeln(StringPrintColor.defaultt(' $key: ${v.join('\r\n\t')}')));
    }

    if (responseBody) {
      buffer.writeln(StringPrintColor.defaultt('Data Response:'));
      try {
        final jsonData = jsonEncode(response.data);
        jsonData.split('\n').forEach((line) => buffer.writeln(StringPrintColor.magenta(line)));
      } catch (e) {
        final dataString = response.data.toString();
        dataString.split('\n').forEach((line) => buffer.writeln(StringPrintColor.magenta(line)));
      }
    }

    buffer.writeln(StringPrintColor.defaultt(''));

    // Print all at once
    log(buffer.toString());
  }

  String showTimeStampString() => showTimeStamp ? '[${Helper.defaultFormatDateTime(DateTime.now())}] ' : '';
}

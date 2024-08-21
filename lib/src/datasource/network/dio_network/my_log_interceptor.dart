import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../utils/print.dart';

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
    this.request = false,
    this.requestHeader = false,
    this.requestBody = true,
    //
    this.responseHeader = false,
    this.responseBody = true,
    //
    this.error = true,
  });

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
    Printt.defaultt('*** Request ***');
    _printKV(options.method, options.uri, Printt.yellow);
    //options.headers;

    if (request) {
      _printKV('responseType', options.responseType.toString());
      _printKV('followRedirects', options.followRedirects);
      _printKV('persistentConnection', options.persistentConnection);
      _printKV('connectTimeout', options.connectTimeout);
      _printKV('sendTimeout', options.sendTimeout);
      _printKV('receiveTimeout', options.receiveTimeout);
      _printKV(
        'receiveDataWhenStatusError',
        options.receiveDataWhenStatusError,
      );
      _printKV('extra', options.extra);
    }
    if (requestHeader) {
      Printt.defaultt('headers:');
      options.headers.forEach((key, v) => _printKV(' $key', v));
    }
    if (requestBody) {
      Printt.defaultt('Data Request:');
      if (options.data is FormData) {
        _printAll(
            jsonEncode(Map.fromEntries([
              ...(options.data as FormData).fields,
              ...(options.data as FormData).files.map((e) => MapEntry(e.key, e.value.filename)),
            ])),
            Printt.green);
      } else {
        _printAll(jsonEncode(options.data), Printt.green);
      }
    }
    Printt.defaultt('');

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    Printt.defaultt('*** Response ***');
    _printResponse(response);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (error) {
      Printt.red('*** DioException ***:');
      _printKV(err.requestOptions.method, err.requestOptions.uri, Printt.yellow);
      Printt.red('$err');
      if (err.response != null) {
        _printResponse(err.response!);
      }
      Printt.red('');
    }

    handler.next(err);
  }

  void _printResponse(Response response) {
    _printKV(response.requestOptions.method, response.requestOptions.uri, Printt.yellow);
    if (responseHeader) {
      _printKV('statusCode', response.statusCode);
      if (response.isRedirect == true) {
        _printKV('redirect', response.realUri);
      }

      Printt.defaultt('headers:');
      response.headers.forEach((key, v) => _printKV(' $key', v.join('\r\n\t')));
    }
    if (responseBody) {
      Printt.defaultt('Data Response:');
      _printAll(jsonEncode(response.data), Printt.magenta);
    }
    Printt.defaultt('');
  }

  void _printKV(String key, Object? v, [PrinttLog? printt]) {
    (printt ?? Printt.defaultt)('$key: $v');
  }

  void _printAll(String msg, [PrinttLog? printt]) {
    msg.split('\n').forEach(printt ?? Printt.defaultt);
  }
}

import 'package:dio/dio.dart';

import '../../../app/globals.dart';
import '../../../widgets/loadding_widget.dart';

class LoadingInterceptor extends Interceptor {
  final bool isShowLoading;
  final String apiKey;
  final Function(Response?) handleErrorStatus;

  LoadingInterceptor({
    required this.isShowLoading,
    required this.apiKey,
    required this.handleErrorStatus,
  });

  @override
  Future<dynamic> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (isShowLoading) Loadding.show();

    // Gắn access_token vào header, gửi kèm access_token trong header mỗi khi call API
    if (apiKey.isNotEmpty) {
      options.headers["Authorization"] = apiKey;
    }
    // Update static lần cuối gọi API là gì...
    Globals.lastCallUrlApi = options.path;

    return handler.next(options);
  }

  @override
  Future<dynamic> onResponse(Response response, ResponseInterceptorHandler handler) async {
    Loadding.dismiss();
    return handler.next(response);
  }

  @override
  Future<dynamic> onError(DioException err, ErrorInterceptorHandler handler) async {
    Loadding.dismiss();
    await handleErrorStatus(err.response);
    return handler.next(err);
  }
}

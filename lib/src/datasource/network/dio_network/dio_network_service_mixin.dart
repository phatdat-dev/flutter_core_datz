part of 'base_dio_network_service.dart';

enum RequestMethod { GET, POST, PUT, DELETE }

mixin DioNetworkServiceMixin on BaseDioNetworkService {
  /// Tự động parse response từ server thông qua BaseModel (generate json liên hệ Đạtz cung cấp tool)
  Future<dynamic> onRequest<T extends BaseModel>(
    String url,
    RequestMethod method, {
    /// body: dữ liệu gửi lên server, thường dùng cho != GET
    /// [Map<String, dynamic>] || List<Map<String, dynamic>] || [BaseModel] || [List<BaseModel>] || ...
    dynamic body,

    /// muốn tự động parse sang model nào thì cung cấp object ở đây
    /// ex: baseModel: User() // class User extends BaseModel<User>
    /// nếu null thi` tra? ve` [Response]
    BaseModel<T>? baseModel,
    Map<String, dynamic>? queryParam,

    /// if is null, default [isShowLoading] = false
    bool? isShowLoading,
  }) async {
    {
      _isShowLoading = isShowLoading ??= false;

      if (body is List<BaseModel>) {
        //cho no' theo kieu? nhu vay` [{},{},{}...]
        body = body.map((e) => e.toJson()).toList();
      } else if (body != null && body is BaseModel) {
        body = body.toJson();
      } else if (body is String) {
        body = jsonEncode(body);
      }

      final res = await dio
          .request(
        url,
        data: body,
        options: Options(
          method: method.name,
          // contentType: Headers.jsonContentType,
          // responseType: ResponseType.json,
        ),
        queryParameters: queryParam?.map((key, value) => MapEntry(key, value.toString())),
      )
          .then((value) {
        //decoder
        if (baseModel == null) return value.data; //return Response<dynamic>
        if (value.data is List) return (value.data as List).map((e) => baseModel.fromJson(e)).toList();
        return baseModel.fromJson(value.data);
      });
      return res;
    }
  }
}

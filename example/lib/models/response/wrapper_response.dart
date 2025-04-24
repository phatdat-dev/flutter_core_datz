// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter_core_datz/flutter_core_datz.dart';

class WrapperResponse<T extends BaseModel> extends BaseModel<WrapperResponse<T>> {
  final dynamic _data;
  final int? code;
  final String? message;
  //
  final T baseModel;
  final List<String> wrapKey;

  WrapperResponse({dynamic data, this.code, this.message, required this.baseModel, this.wrapKey = const ['Data', 'data']}) : _data = data;

  List<T>? get listData => _data is List ? _data as List<T> : null;
  T? get data => _data is T ? _data : null;

  factory WrapperResponse.fromJson(Map<String, dynamic> json, T baseModel) {
    return WrapperResponse<T>(baseModel: baseModel).fromJson(json);
  }

  @override
  WrapperResponse<T> fromJson(Map<String, dynamic> json) {
    dynamic getData(String key) {
      if (json[key] == null) return null;

      if (json[key] is List) {
        return List<T>.from((json[key] as List).map((x) => baseModel.fromJson(x)));
      } else if (json[key] is Map) {
        return baseModel.fromJson(json[key]);
      } else {
        return json[key];
      }
    }

    return WrapperResponse<T>(
      data: wrapKey.map((e) => getData(e)).firstWhere((element) => element != null, orElse: () => null),
      code: (json['ResultCode'] as num?)?.toInt() ?? (json['code'] as num?)?.toInt(),
      message: json['ResultInfo'] ?? json['message'],
      baseModel: baseModel,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (this._data != null) {
      if (this._data is List) {
        for (var element in wrapKey) data[element] = (this._data as List<T>).map((v) => v.toJson()).toList();
      } else {
        for (var element in wrapKey) data[element] = (this._data as T).toJson();
      }
    }
    if (code != null) {
      data['ResultCode'] = code;
    }
    if (message != null) {
      data['ResultInfo'] = message;
    }
    return data;
  }

  WrapperResponse<T> copyWith({dynamic data, int? resultCode, String? resultInfo}) {
    return WrapperResponse<T>(data: data ?? this._data, code: resultCode ?? this.code, message: resultInfo ?? this.message, baseModel: baseModel);
  }
}

class EmptyModel extends BaseModel<EmptyModel> {
  final dynamic data;
  EmptyModel([this.data]);

  factory EmptyModel.fromJson(Map<String, dynamic> json) => EmptyModel(json);

  @override
  EmptyModel fromJson(Map<String, dynamic> json) => EmptyModel.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}

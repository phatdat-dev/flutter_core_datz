import 'package:flutter_core_datz/flutter_core_datz.dart';

class StateResponse extends BaseModel<StateResponse> implements SearchDelegateQueryName {
  int? id;
  String? name;
  String? code;

  StateResponse({this.id, this.name, this.code});

  factory StateResponse.fromJson(Map<String, dynamic> json) => StateResponse(id: json['id'], name: json['name'], code: json['code']);

  @override
  StateResponse fromJson(Map<String, dynamic> json) => StateResponse.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (id != null) {
      data['id'] = id;
    }
    if (name != null) {
      data['name'] = name;
    }
    if (code != null) {
      data['code'] = code;
    }
    return data;
  }

  List<dynamic> toOdoo() => [id, name];

  StateResponse copyWith({int? id, String? name, String? code}) {
    return StateResponse(id: id ?? this.id, name: name ?? this.name, code: code ?? this.code);
  }

  @override
  String get queryName => name ?? "";
  @override
  set queryName(String value) => queryName = value;
  @override
  Object? objectt;
}

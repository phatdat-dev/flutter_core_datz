import 'package:flutter_core_datz/flutter_core_datz.dart';

class RequestWrapper extends BaseModel<RequestWrapper> {
  final dynamic params;

  RequestWrapper({required this.params});

  @override
  RequestWrapper fromJson(Map<String, dynamic> json) => RequestWrapper(params: json['params']);

  @override
  Map<String, dynamic> toJson() => {'params': params};
}

import 'package:flutter_core_datz/flutter_core_datz.dart';

class BaseSearchRequestModel extends BaseModel<BaseSearchRequestModel> {
  String? query;
  int page;
  int pageSize;
  String? sortBy;
  bool? isSortDescending;
  DateTime? fromDate;
  DateTime? toDate;

  BaseSearchRequestModel({this.query, this.page = 1, this.pageSize = 50, this.sortBy, this.isSortDescending, this.fromDate, this.toDate});

  @override
  BaseSearchRequestModel fromJson(Map<String, dynamic> json) => BaseSearchRequestModel(
    query: json['query'],
    page: (json['page'] as num).toInt(),
    pageSize: (json['pageSize'] as num).toInt(),
    sortBy: json['sortBy'],
    isSortDescending: json['isSortDescending'],
    fromDate: json['fromDate'] != null ? DateTime.tryParse(json['fromDate']) : null,
    toDate: json['toDate'] != null ? DateTime.tryParse(json['toDate']) : null,
  );

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (query != null) {
      data['query'] = query;
    }
    data['page'] = page;
    data['pageSize'] = pageSize;
    if (sortBy != null) {
      data['sortBy'] = sortBy;
    }
    if (isSortDescending != null) {
      data['isSortDescending'] = isSortDescending;
    }
    if (fromDate != null) {
      data['fromDate'] = fromDate?.toIso8601String();
    }
    if (toDate != null) {
      data['toDate'] = toDate?.toIso8601String();
    }
    return data;
  }

  BaseSearchRequestModel copyWith({
    String? query,
    int? page,
    int? pageSize,
    String? sortBy,
    bool? isSortDescending,
    DateTime? fromDate,
    DateTime? toDate,
  }) => BaseSearchRequestModel(
    query: query ?? this.query,
    page: page ?? this.page,
    pageSize: pageSize ?? this.pageSize,
    sortBy: sortBy ?? this.sortBy,
    isSortDescending: isSortDescending ?? this.isSortDescending,
    fromDate: fromDate ?? this.fromDate,
    toDate: toDate ?? this.toDate,
  );
}

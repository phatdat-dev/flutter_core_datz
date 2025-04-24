// ignore_for_file: non_constant_identifier_names

import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_datz/flutter_core_datz.dart';
import 'package:get_it/get_it.dart';

import '../../models/response/state_response.dart';
import '../datasource/network/dio_network_service.dart';

enum CacheKeyHelperApi {
  country;

  BaseModel get baseModel => switch (this) {
    country => StateResponse(),
  };
}

class MyHelperApi {
  // create Singleton Instance
  static final MyHelperApi _instance = MyHelperApi._internal();
  static MyHelperApi get instance => _instance;

  // instantiate constructor
  factory MyHelperApi() => _instance;
  // private constructor
  MyHelperApi._internal() {
    _call_hoyolab_avatar_set();
  }

  final ValueNotifier<Map<String, dynamic>?> avatarSet = ValueNotifier(null);
  final Map<String, Either<List<BaseModel>, Map<String, List<BaseModel>>>?> cacheData = {}; // {"city": [{"123":"HaNoi"},]}
  Future<List<BaseModel>>? _completer; // Fix bug call multiple times

  Future<void> _call_hoyolab_avatar_set() async {
    if (avatarSet.value == null) {
      final apiCall = GetIt.instance.get<DioNetworkService>();
      avatarSet.value = (await apiCall.onRequest('https://bbs-api-os.hoyolab.com/community/misc/api/avatar_set', RequestMethod.GET));
    }
  }

  String generateListQueryParameter({required String url, required String key, required Iterable<String>? listValue}) {
    String? listQueryString;
    if (listValue != null) listQueryString = listValue.map((e) => "$key=$e").join("&");
    if (listQueryString != null) url += "?$listQueryString";
    return url;
  }

  Future<Either<List<BaseModel>, Map<String, List<BaseModel>>>?> fetchCacheData(CacheKeyHelperApi cacheKey, String? cacheKey2) async {
    if (cacheData[cacheKey.name] == null) {
      switch (cacheKey) {
        case CacheKeyHelperApi.country:
          _completer ??= getListCountry();
          break;
      }
    }
    if (cacheKey2 != null && cacheData[cacheKey.name]?.toRight()?[cacheKey2] == null) {
      // switch (cacheKey) {
      //   case CacheKeyHelperApi.district:
      //     _completer ??= getListDistrict(int.parse(cacheKey2));
      //     break;
      //   default:
      // }
    }

    await _completer;
    _completer = null;
    return cacheData[cacheKey.name];
  }

  /// return String or List
  Future<dynamic> getValueFromCache<T extends BaseModel>({
    required String keyCondition,
    required String keyNameReturn,
    required dynamic valueCondition,
    required CacheKeyHelperApi cacheKey,
    String? cacheKey2,
  }) async {
    dynamic onError() {
      if (valueCondition is List) return List.filled(valueCondition.length, '');
      return '';
    }

    await fetchCacheData(cacheKey, cacheKey2);

    if (cacheData[cacheKey.name] != null) {
      return AppException(identifier: "$runtimeType.getValueFromCache")
          .handleException(() {
            final List<BaseModel<dynamic>> data;
            if (cacheKey2 != null) {
              data = cacheData[cacheKey.name]!.toRight()![cacheKey2]!;
            } else {
              data = cacheData[cacheKey.name]!.toLeft()!;
            }
            //  nếu truyền vào là 1 List, sẽ trả ra tương ứng List đó
            if (valueCondition is List) {
              final List items = [];

              for (var con in valueCondition) {
                final item = data.firstWhereOrNull((e) => e.toJson()[keyCondition] == con);
                if (item != null) {
                  items.add(item.toJson()[keyNameReturn]);
                } else {
                  items.add('');
                }
                if (items.length == valueCondition.length) return items;
              }

              return items;
            } else {
              final item = data.firstWhereOrNull((e) => e.toJson()[keyCondition].toString() == valueCondition.toString());
              return item?.toJson()[keyNameReturn] ?? '';
            }
          })
          .fold(
            (error) {
              return onError();
            },
            (data) {
              return data;
            },
          );
    }
    return onError();
  }

  Future<List<BaseModel>> _getListData<T extends BaseModel>({
    required Future<Either<AppException, List<T>>> Function() remoteDataSource,
    required CacheKeyHelperApi cacheKey,
    String? cacheKey2, // deep cache
  }) async {
    if (cacheData[cacheKey.name] == null) {
      final response = await remoteDataSource.call();
      response.fold(
        (error) {
          //
        },
        (data) {
          if (data.isNotNullAndEmpty) {
            if (cacheKey2 != null) {
              cacheData[cacheKey.name] = Right({cacheKey2: data});
            } else {
              cacheData[cacheKey.name] = Left(data);
            }
          }
        },
      );
    } else if (cacheKey2 != null && cacheData[cacheKey.name]!.toRight()?[cacheKey2] == null) {
      final response = await remoteDataSource.call();
      response.fold(
        (error) {
          //
        },
        (data) {
          if (data.isNotNullAndEmpty) {
            cacheData[cacheKey.name]!.toRight()?[cacheKey2] = data;
          }
        },
      );
    }

    return cacheData[cacheKey.name]?.fold((l) => l, (r) {
          if (cacheKey2 != null) return r[cacheKey2]!;
          return [];
        }) ??
        [];
  }

  Future<List<StateResponse>> getListCountry() async {
    return _getListData<StateResponse>(
      remoteDataSource: () {
        final result = AppException().handleExceptionAsync(() async {
          // final response = await Helper.readFileJson(Assets.data.langcode);
          final response = {};
          final data = (response as List).map((e) => StateResponse.fromJson(Map<String, dynamic>.from(e))).toList();
          return data;
        });
        return result;
      },
      cacheKey: CacheKeyHelperApi.country,
    ).then((value) => value.cast<StateResponse>());
  }
}

// ignore_for_file: non_constant_identifier_names

import 'package:flutter/widgets.dart';
import 'package:flutter_core_datz/flutter_core_datz.dart';
import 'package:get_it/get_it.dart';

import '../../models/request/base_search_request_model.dart';
import '../../models/response/wrapper_response.dart';
import '../../shared/datasource/network/dio_network_service.dart';
import '../base_datasource.dart';
import 'base_controller.dart';

abstract class BaseFetchController<T> extends BaseController {
  /// url get main data
  String get apiUrl;

  /// if is set String, get data from json with key
  /// if is set BaseModel, get data from BaseModel
  dynamic get parseObjectData => null;
  bool get isShowLoading => false;
  bool get allowShowToastError => false;
  DioNetworkService get apiCall => GetIt.instance<DioNetworkService>();

  //
  BaseSearchRequestModel searchQueryParams = BaseSearchRequestModel();
  Object? searchQueryBody;
  //
  bool dataResponseIsMaximum = false;
  //
  List<T>? listOrigin;
  ValueNotifier<List<T>?> state = ValueNotifier(null); // mainState

  @override
  Future<void> onInitData() async {
    call_fetchData();
  }

  Future<void> call_fetchData() async {
    Future<void> main() async {
      (await remoteDataSource()).fold(
        (error) {
          dataResponseIsMaximum = true;
        },
        (data) {
          if (data != null) {
            listOrigin = state.value = [...listOrigin ?? [], ...data];
          } else {
            dataResponseIsMaximum = true;
          }
        },
      );
    }

    await main();
  }

  void loadMoreData() {
    // Khi scroll đến cuối danh sách
    // Thực hiện tải thêm dữ liệu
    searchQueryParams.page += 1;
    call_fetchData();
  }

  void resetSearchRequestModel() {
    searchQueryParams = BaseSearchRequestModel();
    dataResponseIsMaximum = false;
  }

  Future<void> resetAndFetchData() async {
    dataResponseIsMaximum = false;
    listOrigin = state.value = null; // Selector ko hieu ham Clear()
    await call_fetchData();
  }

  // bởi vì có thể sẽ dùng NestedScrollView, nên ko thể chính xác được sử dụng cái nào để lấy scrollColtroller
  /// return true if isScrollBottom
  bool onListenScrollToBottom(ScrollController scrollController) {
    bool isScrollBottom =
        scrollController.position.pixels ==
        scrollController.position.maxScrollExtent;
    //nếu scroll đến cuối danh sách
    if ((!dataResponseIsMaximum) && isScrollBottom) {
      loadMoreData();
      return true;
    }
    return false;
  }

  FutureEitherAppException<List?> remoteDataSource() {
    final result = AppException().handleExceptionAsync(() async {
      var json = await apiCall.onRequest(
        apiUrl,
        searchQueryBody != null ? RequestMethod.POST : RequestMethod.GET,
        queryParam: searchQueryParams.toJson(),
        isShowLoading: isShowLoading,
        baseModel: parseObjectData is BaseModel ? parseObjectData : null,
        body: searchQueryBody,
      );
      //
      if (parseObjectData is String) {
        json = Helper.convertToListMap(
          (parseObjectData as String).isEmpty ? json : json[parseObjectData],
        );
      } else if (json is WrapperResponse) {
        json = json.listData;
      }

      return json as List?;
    }, showToastError: allowShowToastError);
    return result;
  }
}

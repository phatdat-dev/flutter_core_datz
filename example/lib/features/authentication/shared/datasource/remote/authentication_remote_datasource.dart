import 'package:flutter_core_datz/flutter_core_datz.dart';
import 'package:get_it/get_it.dart';

import '../../../../../core/base_datasource.dart';
import '../../../../../models/response/wrapper_response.dart';
import '../../../../../models/user_model.dart';
import '../../../../user/controller/user_controller.dart';

class AuthenticationRemoteDataSource extends BaseRemoteDataSource {
  FutureEitherAppException<WrapperResponse<UserModel>> login(UserModel request) async {
    final result = AppException().handleExceptionAsync(() async {
      final json = await apiCall.onRequest("ApiUrl.User_Login()", RequestMethod.POST, isShowLoading: false, body: request);
      return WrapperResponse.fromJson(json, UserModel());
    }, showToastError: false);
    return result;
  }

  // register
  FutureEitherAppException<WrapperResponse<UserModel>> register(UserModel request) async {
    final result = AppException().handleExceptionAsync(() async {
      final json = await apiCall.onRequest("ApiUrl.User_Create()", RequestMethod.POST, isShowLoading: false, body: request);
      return WrapperResponse.fromJson(json, UserModel());
    }, showToastError: false);
    return result;
  }

  FutureEitherAppException<String> changePassword(String newPassword) async {
    final result = AppException().handleExceptionAsync(() async {
      final json = await apiCall.onRequest(
        "ApiUrl.User_Change_Password()",
        RequestMethod.POST,
        isShowLoading: false,
        body: {"user_id": GetIt.instance<UserController>().state.value?.userId, "password": newPassword},
      );
      return json["message"] as String;
    }, showToastError: false);
    return result;
  }
}

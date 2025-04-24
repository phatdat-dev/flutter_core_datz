import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_datz/flutter_core_datz.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/controller/base_controller.dart';
import '../../../../models/user_model.dart';
import '../../../../router/app_router.dart';
import '../../../user/controller/user_controller.dart';
import '../../shared/datasource/local/authentication_local_datasource.dart';
import '../../shared/datasource/remote/authentication_remote_datasource.dart';
import 'secret_command_controller.dart';

class LoginController extends BaseController {
  static final isSavePassword = ValueNotifier(false);
  static final formKey = GlobalKey<FormBuilderState>();
  static final _localDataSource = AuthenticationLocalDataSource();
  final _userController = GetIt.instance<UserController>();

  final isLoadding = ValueNotifier(false);
  final _remoteDataSource = AuthenticationRemoteDataSource();
  // final _enterpriseRepository = EnterpriseRepository();

  static Map<String, FormBuilderFieldState> get _fields => formKey.currentState!.fields;

  @override
  Future<void> onInitData() async {
    // check xem đã đăng nhập chưa

    final either = await _localDataSource.getUserFromStorage();
    either.fold((error) {}, (data) async {
      if (data != null) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          _fields['username']?.didChange(data.userName ?? "");
          _fields['password']?.didChange(data.password ?? "");
          onLogin();
        });
      }
    });
  }

  Future<void> onLogin() async {
    UserModel? user;

    if (formKey.currentState!.saveAndValidate()) {
      isLoadding.value = true;

      String password = _fields['password']!.value.toString();
      password = (await SecretCommandController(password).onLoginPasswordCommand());

      final either = await _remoteDataSource.login(UserModel(userName: _fields['username']!.value.toString(), password: password));

      either.fold(
        (error) {
          // Either invalidate using Form Key
          _fields['username']?.invalidate(error.message);
        },
        (data) async {
          user = data.data?..password = password;
          if (isSavePassword.value) _localDataSource.saveUserToStorage(user);
          redirectToHomeScreen();
        },
      );
      isLoadding.value = false;
    }

    _userController.state.value = user;
  }

  void redirectToHomeScreen() {
    final context = formKey.currentState?.context ?? AppGlobals.context;
    if (context.mounted) context.pushRoute(const HomeRoute());
  }

  static Future<void> onLogout() async {
    final userController = GetIt.instance<UserController>();
    final cacheUser = userController.state.value?.copyWith();
    // xóa thông tin đăng nhập
    userController.state.value = null;
    await _localDataSource.removeUserFromStorage();
    // trả về màn hình login
    final context = AppGlobals.context;
    if (context.mounted) context.navigateTo(const LoginRoute());
    // nếu có lưu mật khẩu thì set lại thông tin đăng nhập tại form
    if (isSavePassword.value && cacheUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _fields['username']?.didChange(cacheUser.userName);
        _fields['password']?.didChange(cacheUser.password);
      });
    }
  }

  /// check user account not null, if not null, call callback
  static Future<T?> onUserNotNull<T>(Future<T> Function(UserModel user) callback) async {
    final userController = GetIt.instance<UserController>();
    final user = userController.state.value;

    if (user != null) {
      return await callback(user);
    } else {
      HelperWidget.showToastError('Vui lòng đăng nhập.');
    }
    return null;
  }
}

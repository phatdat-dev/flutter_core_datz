import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_datz/flutter_core_datz.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../../core/controller/base_controller.dart';
import '../../../../models/user_model.dart';
import '../../../../router/app_router.dart';
import '../../../../shared/utils/my_helper_widget.dart';
import '../../shared/datasource/remote/authentication_remote_datasource.dart';

class RegisterController extends BaseController {
  final formKey = GlobalKey<FormBuilderState>();

  final isLoadding = ValueNotifier(false);
  final _remoteDataSource = AuthenticationRemoteDataSource();
  // final _enterpriseRepository = EnterpriseRepository();

  Map<String, FormBuilderFieldState> get _fields =>
      formKey.currentState!.fields;

  @override
  Future<void> onInitData() async {}

  Future<void> onRegister() async {
    if (formKey.currentState!.saveAndValidate()) {
      isLoadding.value = true;

      final either = await _remoteDataSource.register(UserModel());

      either.fold(
        (error) {
          // Either invalidate using Form Key
          _fields['phone']?.invalidate(error.message);
        },
        (data) async {
          MyHelperWidget.showToastSuccess(data.message ?? "");
          Globals.context.navigateTo(const LoginRoute());
        },
      );
      isLoadding.value = false;
    }
  }
}

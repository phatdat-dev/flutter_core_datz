import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_datz/flutter_core_datz.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../../core/controller/base_controller.dart';
import '../../../../shared/utils/my_helper_widget.dart';
import '../../shared/datasource/remote/authentication_remote_datasource.dart';

enum ForgotPassWordType { email, phone }

class ForgotPasswordController extends BaseController {
  final forgotPassWordType = ValueNotifier(ForgotPassWordType.phone);

  final _remoteDataSource = AuthenticationRemoteDataSource();

  @override
  Future<void> onInitData() async {}

  void onChangeNewPassword(GlobalKey<FormBuilderState> formKey) async {
    if (formKey.currentState?.saveAndValidate() ?? false) {
      final newPassword = formKey.currentState?.value["newPassword"]
          ?.toString();
      if (!newPassword.isNotNullAndEmpty) return;
      //
      (await _remoteDataSource.changePassword(newPassword!)).fold(
        (error) {
          formKey.currentState?.fields["newPassword"]?.invalidate(
            error.message,
          );
        },
        (data) {
          formKey.currentState?.reset();
          MyHelperWidget.showToastSuccess("Đổi mật khẩu thành công".tr());
        },
      );
    }
  }
}

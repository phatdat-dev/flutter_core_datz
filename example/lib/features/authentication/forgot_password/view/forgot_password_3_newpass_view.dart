import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_datz/flutter_core_datz.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../../app/app_constants.dart';
import '../../../../generated/assets.gen.dart';
import '../../shared/widgets/textfield_password_widget.dart';

final formKey = GlobalKey<FormBuilderState>();

@RoutePage()
class ForgotPassword3NewPassView extends StatelessWidget {
  const ForgotPassword3NewPassView({super.key});

  void onPressed() {
    if (formKey.currentState!.saveAndValidate()) {
      final context = AppGlobals.context;
      HelperWidget.showCustomAlertDialog(
        context: context,
        defaultSize: false,
        child: Column(
          children: [
            Padding(padding: const EdgeInsets.only(right: 15), child: HelperWidget.imageWidget(Assets.svg.shieldSuccess, width: 150)),
            Text("Chúc mừng".tr(), style: context.textTheme.headlineMedium?.copyWith(color: Colors.green.shade300, fontWeight: FontWeight.w500)),
            const SizedBox(height: 15),
            Text("Bạn đã tạo mật khẩu thành công. Sẽ tự động chuyển về màn hình chính trong 3 giây.".tr(), textAlign: TextAlign.center),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tạo mật khẩu mới".tr())),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingContent),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: FormBuilder(
                    key: formKey,
                    child: Column(
                      children: [
                        HelperWidget.imageWidget(Assets.images.authenication.newPassword.path, height: 200),
                        Padding(
                          padding: const EdgeInsets.all(AppConstants.paddingTextField * 2),
                          child: Text(
                            "Tạo mật khẩu mới",
                            style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Expanded(
                          child: Column(
                            children: [
                              FormBuilderTextFieldPasswordWidget(name: "newPassword", labelText: "Mật khẩu mới", validators: []),
                              SizedBox(height: AppConstants.paddingTextField),
                              FormBuilderTextFieldPasswordWidget(name: "confirmNewPassword", labelText: "Xác nhận mật khẩu mới", validators: []),
                              SizedBox(height: AppConstants.paddingTextField),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(bottom: kToolbarHeight / 3),
                          child: FilledButton(onPressed: onPressed, child: Text("Tiếp tục".tr())),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

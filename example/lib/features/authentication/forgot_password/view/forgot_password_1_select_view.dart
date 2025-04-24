import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_datz/flutter_core_datz.dart';

import '../../../../app/app_constants.dart';
import '../../../../generated/assets.gen.dart';
import '../../../../router/app_router.dart';
import '../../../../shared/utils/my_helper_widget.dart';
import '../controller/forgot_password_controller.dart';

@RoutePage()
class ForgotPassword1SelectView extends StatelessWidget {
  const ForgotPassword1SelectView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ForgotPasswordController();
    return Scaffold(
      appBar: AppBar(title: Text("Quên mật khẩu".tr())),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingContent),
          child: Column(
            children: [
              HelperWidget.imageWidget(Assets.images.authenication.selectTypeChangePassword.path, height: 200),
              const Padding(
                padding: EdgeInsets.all(AppConstants.paddingTextField * 2),
                child: Text("Lựa chọn phương án xác minh\ntài khoản", textAlign: TextAlign.center),
              ),
              ...{
                "otp": {"title": "SMS OTP", "subtitle": "123****", "icon": Icons.sms, "type": ForgotPassWordType.phone},
                "mail": {"title": "Qua địa chỉ Email", "subtitle": "datz***123@gmail.com", "icon": Icons.email, "type": ForgotPassWordType.email},
              }.entries.map(
                (e) => ValueListenableBuilder(
                  valueListenable: controller.forgotPassWordType,
                  builder: (context, forgotPassWordTypeValue, child) {
                    final type = (e.value["type"] as ForgotPassWordType);
                    final bool isSelected = type == forgotPassWordTypeValue;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppConstants.paddingTextField),
                      child: InkWell(
                        onTap: () => controller.forgotPassWordType.value = type,
                        borderRadius: AppConstants.borderRadius,
                        child: Ink(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected ? context.theme.colorScheme.primary : MyHelperWidget.borderSide(context).color,
                              width: isSelected ? 1 : MyHelperWidget.borderSide(context).width,
                            ),
                            borderRadius: AppConstants.borderRadius,
                            color: context.theme.inputDecorationTheme.fillColor,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 24,
                              backgroundColor: context.theme.colorScheme.surface.withValues(alpha: 0.5),
                              child: Icon(e.value["icon"] as IconData, color: context.theme.colorScheme.primary),
                            ),
                            title: Text(e.value["title"] as String, style: TextStyle(color: context.theme.hintColor)),
                            subtitle: Text(e.value["subtitle"] as String),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: kToolbarHeight / 3),
                child: FilledButton(
                  onPressed: () {
                    const ForgotPassword2PinRoute().push(context);
                  },
                  child: Text("Tiếp tục".tr()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

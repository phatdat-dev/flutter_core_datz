import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_datz/flutter_core_datz.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../app/app_constants.dart';
import '../../../../generated/assets.gen.dart';
import '../../../../router/app_router.dart';
import '../../../../shared/utils/my_helper_widget.dart';
import '../widget/count_down_timer.dart';

@RoutePage()
class ForgotPassword2PinView extends StatelessWidget {
  const ForgotPassword2PinView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quên mật khẩu".tr())),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingContent),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      HelperWidget.imageWidget(Assets.images.authenication.forgotVerified.path, height: 200),
                      Text("OTP đã được gửi tới số +849****21".tr(), style: context.textTheme.bodyLarge),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Builder(
                          builder: (context) {
                            final borderWidth = MyHelperWidget.borderSide(context).width; // 0.5
                            final fillColor = context.theme.inputDecorationTheme.fillColor;
                            return PinCodeTextField(
                              appContext: context,
                              length: 4,
                              obscureText: false,
                              keyboardType: TextInputType.number,
                              animationType: AnimationType.scale,
                              enableActiveFill: true,
                              backgroundColor: Colors.transparent,
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: AppConstants.borderRadius,
                                fieldWidth: 50,
                                //
                                borderWidth: borderWidth,
                                activeBorderWidth: borderWidth,
                                // selectedBorderWidth: borderWidth, // mặc định màu là 2
                                inactiveBorderWidth: borderWidth,
                                disabledBorderWidth: borderWidth,
                                errorBorderWidth: borderWidth,
                                //
                                selectedColor: context.theme.colorScheme.primary,
                                inactiveColor: context.theme.hintColor,
                                activeColor: context.theme.hintColor, // màu đã nhập
                                //
                                inactiveFillColor: fillColor, // chưa nhập
                                selectedFillColor: fillColor, // đang nhập
                                activeFillColor: fillColor, // đã nhập
                              ),
                            );
                          },
                        ),
                      ),
                      DefaultTextStyle(
                        style: context.textTheme.bodyLarge!,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Gửi lại trong "),
                            CountDownTimer(
                              secondsRemaining: 100,
                              style: TextStyle(fontWeight: FontWeight.bold, color: context.theme.colorScheme.primary),
                            ),
                            const Text(" giây"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(bottom: kToolbarHeight / 3),
                  child: FilledButton(
                    onPressed: () {
                      const ForgotPassword3NewPassRoute().push(context);
                    },
                    child: Text("Tiếp tục".tr()),
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

class ForgotPassword2PinViewFast extends StatefulWidget {
  const ForgotPassword2PinViewFast({super.key});

  @override
  State<ForgotPassword2PinViewFast> createState() => _ForgotPassword2PinViewFastState();
}

class _ForgotPassword2PinViewFastState extends State<ForgotPassword2PinViewFast> {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  bool waitToResend = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quên mật khẩu".tr())),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingContent),
            child: Column(
              children: [
                Expanded(
                  child: FormBuilder(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        HelperWidget.imageWidget(Assets.images.authenication.forgotVerified.path, height: 200),
                        Text("Nhập tài khoản của bạn", style: context.textTheme.bodyLarge),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: FormBuilderTextField(name: "username", decoration: const InputDecoration(prefixIcon: Icon(Icons.person_outline))),
                        ),
                        if (waitToResend)
                          DefaultTextStyle(
                            style: context.textTheme.bodyLarge!,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Gửi lại trong "),
                                CountDownTimer(
                                  secondsRemaining: 60,
                                  style: TextStyle(fontWeight: FontWeight.bold, color: context.theme.colorScheme.primary),
                                  whenTimeExpires: () => setState(() => waitToResend = false),
                                ),
                                const Text(" giây"),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(bottom: kToolbarHeight / 3),
                  child: FilledButton(
                    onPressed: () async {
                      if ((formKey.currentState?.saveAndValidate() ?? false) && waitToResend == false) {
                        // setState(() => waitToResend = true);
                        // final result = await AuthenticationRemoteDataSource().resetPassword(formKey.currentState!.value["username"] as String);
                        // result.fold((error) => null, (data) {
                        //   MyHelperWidget.showToastSuccess("$data, ${"Vui lòng kiểm tra email của bạn"}");
                        //   const LoginRoute().go(context);
                        // });
                      }
                    },
                    style: waitToResend ? MyHelperWidget.greyButtonStyle(context) : null,
                    child: Text("Tiếp tục".tr()),
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

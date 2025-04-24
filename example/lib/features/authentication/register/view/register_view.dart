import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_datz/flutter_core_datz.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../../app/app_constants.dart';
import '../../../../generated/assets.gen.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../shared/widgets/text_register_widget.dart';
import '../../shared/widgets/textfield_password_widget.dart';
import '../controller/register_controller.dart';

@RoutePage()
class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final RegisterController controller;

  @override
  void initState() {
    controller = RegisterController()..onInitData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
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
                    key: controller.formKey,
                    child: Column(
                      children: [
                        HelperWidget.imageWidget(Assets.images.logo.logo512x512.path, width: context.width * 0.5),
                        Align(
                          alignment: Alignment.center,
                          child: Text("Đăng ký".tr(), style: context.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w500)),
                        ),
                        const SizedBox(height: 30),
                        // SizedBox(height: context.height * 0.12),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Focus(
                              onFocusChange: (hasFocus) {
                                // if (!hasFocus) controller.loadEnterprise();
                              },
                              child: FormBuilderTextField(
                                enableSuggestions: true,
                                name: "phone",
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.phone_outlined, color: context.theme.unselectedWidgetColor),
                                  labelText: "Số điện thoại (Username)",
                                ),
                                validator: FormBuilderValidators.compose([FormBuilderValidators.required(), FormBuilderValidators.phoneNumber()]),
                              ),
                            ),
                            const SizedBox(height: 10),
                            FormBuilderTextField(
                              enableSuggestions: true,
                              name: "name",
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person_outline, color: context.theme.unselectedWidgetColor),
                                labelText: "Họ tên",
                              ),
                              validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                            ),
                            const SizedBox(height: 10),
                            FormBuilderTextField(
                              enableSuggestions: true,
                              name: "email",
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email_outlined, color: context.theme.unselectedWidgetColor),
                                labelText: "Email",
                              ),
                              validator: FormBuilderValidators.compose([FormBuilderValidators.required(), FormBuilderValidators.email()]),
                            ),
                            const SizedBox(height: 10),
                            const FormBuilderTextFieldPasswordWidget(),
                            const SizedBox(height: 50),

                            SizedBox(
                              width: double.infinity,
                              child: FilledButton.icon(
                                onPressed: controller.onRegister,
                                icon: controller.isLoadding.builder(
                                  (context, isLoaddingValue) =>
                                      isLoaddingValue
                                          ? SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(color: Theme.of(context).colorScheme.surface, strokeWidth: 3),
                                          )
                                          : const SizedBox.shrink(),
                                ),
                                label: Text(LocaleKeys.Register.tr()),
                              ),
                            ),
                            // TextButton(
                            //   onPressed: () => const ForgotPassword1SelectRoute().push(context),
                            //   child: Text(
                            //     "Quên mật khẩu".tr(),
                            //     style: TextStyle(color: context.theme.colorScheme.error),
                            //   ),
                            // ),
                            // const SizedBox(height: 10),
                            // OrDivider(text: "Hoặc", color: Colors.grey.shade300),
                            // const SizedBox(height: (10 * 2)),
                          ],
                        ),
                        const TextLoginWidget(),
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

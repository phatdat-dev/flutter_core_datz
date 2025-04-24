import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_core_datz/flutter_core_datz.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../app/app_constants.dart';
import '../../../../../generated/assets.gen.dart';
import '../../../../../shared/utils/my_helper_widget.dart';
import '../../../../router/app_router.dart';
import '../../../../shared/datasource/network/dio_network_service.dart';
import '../../../authentication/login/controller/login_controller.dart';
import '../../../setting/widget/circle_avatar_outline_edit.dart';
import '../../../setting/widget/setting_menu_widget.dart';
import '../../../user/controller/user_controller.dart';

@RoutePage()
class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    // final settingController = GetIt.instance<SettingController>();
    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder:
            (context, innerBoxIsScrolled) => [
              SliverAppBar(
                centerTitle: true,
                title: Text("Tài khoản".tr()),
                actions: [
                  IconButton(
                    tooltip: "Cài đặt ứng dụng".tr(),
                    icon: const Icon(Icons.settings_outlined),
                    onPressed: () => const SettingRoute().push(context),
                  ),
                ],
              ),
            ],
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingContent),
          children: [
            ...[
              _buildHeader(context),
              const SizedBox(height: 20),
              SettingMenuWidget(
                title: "Giới thiệu".tr(),
                icon: Icons.description_outlined,
                iconColor: Colors.purple,
                onTap: () => launchUrlString("${GetIt.instance<DioNetworkService>().baseUrl}/intro"),
              ),
              SettingMenuWidget(
                title: "Chính sách bảo mật".tr(),
                icon: Icons.bookmark_outline,
                iconColor: Colors.blue,
                onTap: () => launchUrlString("${GetIt.instance<DioNetworkService>().baseUrl}/privacy-policy"),
              ),
              SettingMenuWidget(
                title: "Điều khoản sử dụng".tr(),
                icon: Icons.auto_stories_outlined,
                iconColor: Colors.blue,
                onTap: () => launchUrlString("${GetIt.instance<DioNetworkService>().baseUrl}/terns-of-use"),
              ),
              SettingMenuWidget(
                title: "Liên hệ".tr(),
                icon: Icons.help_outline,
                iconColor: Colors.orange,
                onTap: () => showModalBottomSheet(context: context, builder: (context) => const BuildContactInfoBottomSheet()),
              ),
              SettingMenuWidget(
                title: "Feedback".tr(),
                icon: Assets.icons.ask.path,
                iconColor: Colors.orange,
                onTap: () => launchUrlString("${GetIt.instance<DioNetworkService>().baseUrl}/feedback"),
              ),
            ].map((e) => Padding(padding: const EdgeInsets.only(bottom: (AppConstants.paddingTextField / 2)), child: e)),
            _buildVersion(context),
            _buildLogoutButton(context),
            // _buildInfoCompany(context),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: GetIt.instance<UserController>().state,
      builder:
          (context, user, child) => GestureDetector(
            onTap: user != null ? () => const UserRoute().push(context) : null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const CircleAvatarOutlineEdit(),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (user != null) ...[
                            Text(user.resPartner?.name ?? "", style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500)),

                            // Text(ref.watch(enterpriseNotifierProvider).value?.selectedVehicle?.queryName ?? ""),
                            Text(
                              "${user.resPartner?.gender != null ? (user.resPartner!.gender == "male" ? "Nam" : "Nữ") : ""} - ${user.resPartner?.yob ?? ""}",
                            ),
                            Text(
                              "${user.resPartner?.email ?? ""} - ${user.resPartner?.phone ?? ""}",
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).disabledColor),
                            ),
                            // Text.rich(
                            //   TextSpan(children: [
                            //     TextSpan(
                            //         text: "Loại tài khoản: ", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).disabledColor)),
                            //     const TextSpan(text: "Admin"),
                            //   ]),
                            // ),
                          ] else ...[
                            const Text("Bạn chưa đăng nhập"),
                          ],
                        ],
                      ),
                    ),
                    // Icon(Icons.edit_outlined, color: Theme.of(context).disabledColor),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ValueListenableBuilder(
        valueListenable: GetIt.instance<UserController>().state,
        builder: (context, user, child) {
          if (user == null) {
            return FilledButton(onPressed: () => LoginController.onLogout(), child: const Text("Tiến hành đăng nhập"));
          }
          return FilledButton(
            onPressed: () => LoginController.onLogout(),
            style: MyHelperWidget.greyButtonStyle(context),
            child: Text("Đăng xuất".tr()),
          );
        },
      ),
    );
  }

  Widget _buildVersion(BuildContext context) {
    return FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final PackageInfo packageInfo = snapshot.data!;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                packageInfo.appName, //♥
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor.withValues(alpha: 0.7)),
                textAlign: TextAlign.center,
              ),
              Text(
                "v${packageInfo.version}+${packageInfo.buildNumber}",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class BuildContactInfoBottomSheet extends StatelessWidget {
  const BuildContactInfoBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: Column(
        children: [
          ListTile(
            onTap: () => launchUrlString("tel:9999"),
            leading: const Icon(Icons.phone_outlined, color: Colors.green),
            title: const Text("Tổng đài hỗ trợ: 9999"),
            trailing: Icon(Icons.arrow_right_outlined, color: Theme.of(context).hintColor),
          ),
          ListTile(
            onTap: () => launchUrlString("mailto:info@company.com"),
            leading: const Icon(Icons.email_outlined, color: Colors.blue),
            title: const Text("Email: info@company.com"),
            trailing: Icon(Icons.arrow_right_outlined, color: Theme.of(context).hintColor),
          ),
          ListTile(
            onTap: () => launchUrlString("https://company.com"),
            leading: const Icon(Icons.language_outlined, color: Colors.amberAccent),
            title: const Text("Website: company.com"),
            trailing: Icon(Icons.arrow_right_outlined, color: Theme.of(context).hintColor),
          ),
        ],
      ),
    );
  }
}

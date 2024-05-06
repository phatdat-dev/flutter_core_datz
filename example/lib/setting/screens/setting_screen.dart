// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, depend_on_referenced_packages

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_core_datz/flutter_core_datz.dart';

import '../../app_theme.dart';
import '../widgets/check_radio_listtitle_widget.dart';
import '../widgets/setting_menu_widget.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const String devMode = "Dev mode";
    return Scaffold(
      appBar: AppBar(
        title: Text("Cài đặt ứng dụng".tr()),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Positioned(
            //   right: 5,
            //   bottom: 5,
            //   child: Opacity(
            //     opacity: 0.3,
            //     child: HelperWidget.imageWidget(
            //       "assets/images/logo/banner-logo.png",
            //       width: 150,
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CustomScrollView(
                slivers: [
                  SliverList(
                      delegate: SliverChildListDelegate([
                    ExpansionTitleSettingMenuWidget(
                      title: "Language".tr(),
                      subTitle: devMode,
                      iconData: Icons.translate_outlined,
                      iconColor: Colors.blue,
                      children: appTranslationController.locales
                          .map((e) => CheckRadioListTileWidget<Locale>(
                                value: e,
                                title: Text(
                                  e.toString().tr(),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                groupValue: context.locale,
                                onChanged: (value) => appTranslationController.changeLocale(value!),
                              ))
                          .toList(),
                    ),
                    ExpansionTitleSettingMenuWidget(
                      title: "Chủ đề".tr(),
                      subTitle: devMode,
                      iconData: Icons.color_lens_outlined,
                      iconColor: Colors.green,
                      children: [
                        ListenableBuilder(
                          listenable: themeController,
                          builder: (context, child) => SwitchListTile(
                            title: Row(
                              children: [
                                if (themeController.state.themeMode == ThemeMode.light)
                                  const Icon(Icons.wb_sunny_outlined)
                                else
                                  const Icon(Icons.nightlight_round),
                                const SizedBox(width: 10),
                                Text(themeController.state.themeMode.name),
                              ],
                            ),
                            value: themeController.state.themeMode == ThemeMode.light,
                            onChanged: (value) =>
                                themeController.state = themeController.state.copyWith(themeMode: value ? ThemeMode.light : ThemeMode.dark),
                          ),
                        ),
                        ListTile(
                          onTap: () => const TestThemeRoute().push(context),
                          title: Text("Xem mã màu hiện tại".tr()),
                          trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).hintColor),
                        ),
                        Wrap(
                          children: [null, ...Colors.primaries]
                              .map((e) => SizedBox(
                                    width: 75,
                                    child: CheckRadioCircleWidget<MaterialColor?>(
                                      value: e,
                                      groupValue: AppTheme.colorSchemeSeed,
                                      onChanged: (value) {
                                        AppTheme.colorSchemeSeed = value;
                                        if (value == null) {
                                          themeController.setDefaultTheme();
                                        } else {
                                          final brightness = Brightness.values.byName(themeController.state.themeMode.name);
                                          final newThemeDataSeed = ThemeData(colorSchemeSeed: value, brightness: brightness);
                                          themeController.state = themeController.state.copyWith(
                                            lightTheme: brightness == Brightness.light ? newThemeDataSeed : null,
                                            darkTheme: brightness == Brightness.dark ? newThemeDataSeed : null,
                                          );
                                        }
                                      },
                                      child: CircleAvatar(backgroundColor: e, radius: 20),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                    SettingMenuWidget(
                      title: "Xem lỗi".tr(),
                      subTitle: devMode,
                      iconData: Icons.error_outline,
                      iconColor: Colors.red,
                      onTap: () {
                        const AppExceptionRoute().push(context);
                      },
                    ),
                    // SettingMenuWidget(
                    //   title: "Test".tr(),
                    //   subTitle: devMode,
                    //   iconData: Icons.developer_mode_outlined,
                    //   iconColor: Colors.purple,
                    //   onTap: () {

                    //   },
                    // ),
                  ].map((e) => Padding(padding: const EdgeInsets.only(bottom: 8), child: e)).toList())),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_core_datz/flutter_core_datz.dart';
import 'package:get_it/get_it.dart';

import '../../../../../app/app_constants.dart';
import '../../../../../app/app_theme.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../generated/assets.gen.dart';
import '../../../shared/widgets/check_radio_listtitle_widget.dart';
import '../widget/setting_menu_widget.dart';

@RoutePage()
class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    const String devMode = "Dev mode";
    return Scaffold(
      appBar: AppBar(title: Text("Cài đặt ứng dụng".tr())),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              right: 5,
              bottom: 5,
              child: Opacity(opacity: 0.3, child: HelperWidget.imageWidget(Assets.images.logo.logo512x512.keyName, width: 150)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingContent),
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Builder(
                          builder: (context) {
                            final translationController = GetIt.instance<TranslationController>();
                            return ExpansionTitleSettingMenuWidget(
                              title: LocaleKeys.Language.tr(),
                              subTitle: devMode,
                              icon: Icons.translate_outlined,
                              iconColor: Colors.blue,
                              children:
                                  translationController.locales
                                      .map(
                                        (e) => CheckRadioListTileWidget<Locale>(
                                          value: e,
                                          title: Text(e.toString().tr(), style: Theme.of(context).textTheme.bodyMedium),
                                          groupValue: context.locale,
                                          onChanged: (value) => translationController.changeLocale(value!),
                                        ),
                                      )
                                      .toList(),
                            );
                          },
                        ),
                        Builder(
                          builder: (context) {
                            final themeController = GetIt.instance<ThemeController>();
                            return ExpansionTitleSettingMenuWidget(
                              title: "Chủ đề",
                              subTitle: devMode,
                              icon: Icons.color_lens_outlined,
                              iconColor: Colors.green,
                              children: [
                                ListenableBuilder(
                                  listenable: themeController,
                                  builder:
                                      (context, child) => SwitchListTile(
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
                                        onChanged:
                                            (value) =>
                                                themeController.state = themeController.state.copyWith(
                                                  themeMode: value ? ThemeMode.light : ThemeMode.dark,
                                                ),
                                      ),
                                ),
                                ListTile(
                                  onTap: () => const TestThemeRoute().push(context),
                                  title: Text(LocaleKeys.SettingView_ViewCurrentColorCode.tr()),
                                  trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).disabledColor),
                                ),
                                Wrap(
                                  children:
                                      [null, ...Colors.primaries]
                                          .map(
                                            (e) => SizedBox(
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
                                                    ThemeData newThemeDataSeed = ThemeData(colorSchemeSeed: value, brightness: brightness);

                                                    themeController.state = themeController.state.copyWith(
                                                      lightTheme: brightness == Brightness.light ? newThemeDataSeed : null,
                                                      darkTheme: brightness == Brightness.dark ? newThemeDataSeed : null,
                                                    );
                                                  }
                                                },
                                                child: CircleAvatar(backgroundColor: e, radius: 20),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                ),
                              ],
                            );
                          },
                        ),
                        SettingMenuWidget(
                          title: "Xem lỗi",
                          subTitle: devMode,
                          icon: Icons.error_outline,
                          iconColor: Colors.red,
                          onTap: () {
                            const AppExceptionRoute().push(context);
                          },
                        ),
                        // SettingMenuWidget(
                        //   title: "Test Link bank",
                        //   subTitle: devMode,
                        //   icon: Icons.error_outline,
                        //   iconColor: Colors.red,
                        //   onTap: () {
                        //     launchUrlString("https://dl.vietqr.io/pay?app=acb&ba=CAS01@ocb");
                        //   },
                        // ),
                      ].map((e) => Padding(padding: const EdgeInsets.only(bottom: (AppConstants.paddingTextField / 2)), child: e)).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_datz/src/features/theme/theme_controller.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../src/app/app_globals.dart';
import '../src/app/base_configs.dart';
import '../src/features/translation/app_translation_controller.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController theme;
    if (AppGlobals.kTestMode) {
      theme = ThemeController()..state.themeMode = ThemeMode.system;
      EasyLocalization.logger.enableBuildModes = [];
    } else {
      theme = themeController;
    }
    return EasyLocalization(
      path: baseConfigs.appAssetsPath.localization, //
      supportedLocales: appTranslationController.locales,
      fallbackLocale: appTranslationController.fallbackLocale,
      startLocale: AppTranslationController.startLocale,
      child: ListenableBuilder(
        listenable: theme,
        builder: (context, child) => MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: baseConfigs.appTitle,
          routerConfig: baseConfigs.router,
          //theme
          theme: theme.state.lightTheme,
          darkTheme: theme.state.darkTheme,
          themeMode: theme.state.themeMode,
          //language
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: [
            ...context.localizationDelegates,
            FormBuilderLocalizations.delegate,
          ],
          //builder fix first context
          builder: (context, child) {
            return Overlay(
              initialEntries: [
                if (child != null)
                  OverlayEntry(
                    builder: (context) => child,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get_it/get_it.dart';

import '../src/app/app_globals.dart';
import '../src/app/base_configs.dart';
import '../src/features/theme/theme_controller.dart';
import '../src/features/translation/translation_controller.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController theme = GetIt.instance<ThemeController>();
    final translationController = GetIt.instance<TranslationController>();

    if (AppGlobals.kTestMode) {
      EasyLocalization.logger.enableBuildModes = [];
    }
    return EasyLocalization(
      path: baseConfigs.assetsPath.localization, //
      supportedLocales: translationController.locales,
      fallbackLocale: translationController.fallbackLocale,
      startLocale: translationController.startLocale,
      child: ListenableBuilder(
        listenable: theme,
        builder: (context, child) => MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: baseConfigs.appTitle,
          routerConfig: baseConfigs.router(context),
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
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.mouse,
              PointerDeviceKind.touch,
              PointerDeviceKind.stylus,
              PointerDeviceKind.unknown,
            },
          ),
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

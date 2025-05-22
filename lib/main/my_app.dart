import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get_it/get_it.dart';

import '../src/app/base_configs.dart';
import '../src/app/globals.dart';
import '../src/features/theme/theme_controller.dart';
import '../src/features/translation/translation_controller.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.builder});
  final TransitionBuilder? builder;

  @override
  Widget build(BuildContext context) {
    final configs = GetIt.instance<BaseConfigs>();
    final theme = GetIt.instance<ThemeController>();
    final translationController = GetIt.instance<TranslationController>();

    if (Globals.kTestMode) {
      EasyLocalization.logger.enableBuildModes = [];
    }
    return EasyLocalization(
      path: configs.assetsPath.localization, //
      supportedLocales: translationController.locales,
      fallbackLocale: translationController.fallbackLocale,
      startLocale: translationController.startLocale,
      child: ListenableBuilder(
        listenable: theme,
        builder: (context, child) => MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: configs.appTitle,
          routerConfig: configs.routerConfig(context),
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
          builder: (context, child) {
            //builder fix first context
            return Overlay(
              initialEntries: [
                if (child != null)
                  OverlayEntry(
                    builder: (context) =>
                        builder?.call(context, child) ?? child,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

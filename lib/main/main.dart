import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../flutter_core_datz.dart';
import '../src/app/base_configs.dart';
import 'my_app.dart';

Future<void> runMain({
  required BaseConfigs configs,
  Widget Function(Widget child)? beforeAppBuilder,

  /// example
  /// ```dart
  /// builder: (context, child) => MediaQuery(
  ///    data: MediaQuery.of(context).copyWith(
  ///      textScaler: const TextScaler.linear(0.7),
  ///    ),
  ///    child: child!,
  ///  )
  /// ```
  TransitionBuilder? builder,
  FutureOr<void> Function()? onInit,
}) async {
  baseConfigs = configs;
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    EasyLocalization.ensureInitialized(),
    _initSingletons(),
  ]);

  // Setting Device Orientation
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  await onInit?.call();

  runApp(beforeAppBuilder?.call(MyApp(builder: builder)) ?? MyApp(builder: builder));
  errorWidget();
}

@pragma('vm:entry-point')
void errorWidget() {
  if (!AppGlobals.kTestMode) {
    // tránh lỗi integration test
    ErrorWidget.builder = (FlutterErrorDetails details) {
      if (kDebugMode) return ErrorWidget(details.exception);
      return Container(
        alignment: Alignment.center,
        color: Colors.transparent,
        child: Image.asset(
          baseConfigs.assetsPath.errorWidget,
          width: 100,
          height: 100,
        ),
      );
    };
  }
}

Future<void> _initSingletons() async {
  // Services
  GetIt.instance.registerLazySingleton<StorageService>(() => baseConfigs.storageService);
  GetIt.instance.registerLazySingleton<NetworkConnectivityService>(() => baseConfigs.networkConnectivityService);
  // Controllers
  GetIt.instance.registerLazySingleton<TranslationController>(() => baseConfigs.translationController);
  GetIt.instance.registerLazySingleton<ThemeController>(() => ThemeController());
  GetIt.instance.registerLazySingleton<AppExceptionController>(() => AppExceptionController());

  // initiating db
  await GetIt.instance<StorageService>().init();
  // initiating Translation
  await GetIt.instance<TranslationController>().init();
}

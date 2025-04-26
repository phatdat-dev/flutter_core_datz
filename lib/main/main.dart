import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../flutter_core_datz.dart';
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
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([EasyLocalization.ensureInitialized(), _initSingletons(configs)]);

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
  if (!Globals.kTestMode) {
    // tránh lỗi integration test
    ErrorWidget.builder = (FlutterErrorDetails details) {
      if (kDebugMode) return ErrorWidget(details.exception);
      return Container(
        alignment: Alignment.center,
        color: Colors.transparent,
        child: Image.asset(GetIt.instance<BaseConfigs>().assetsPath.errorWidget, width: 100, height: 100),
      );
    };
  }
}

Future<void> _initSingletons(BaseConfigs configs) async {
  GetIt.instance.registerSingleton<BaseConfigs>(configs);
  // Services
  GetIt.instance.registerLazySingleton<StorageService>(() => configs.storageService);
  GetIt.instance.registerLazySingleton<NetworkConnectivityService>(() => configs.networkConnectivityService);
  // Controllers
  GetIt.instance.registerLazySingleton<TranslationController>(() => configs.translationController);
  GetIt.instance.registerLazySingleton<ThemeController>(() => ThemeController());
  GetIt.instance.registerLazySingleton<AppExceptionController>(() => AppExceptionController());

  // initiating db
  await GetIt.instance<StorageService>().init();
  // initiating Translation
  await GetIt.instance<TranslationController>().init();
}

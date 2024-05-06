import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_core_datz/src/app/base_configs.dart';
import 'package:flutter_core_datz/src/features/translation/app_translation_controller.dart';
import 'package:get_it/get_it.dart';

import '../src/app/app_globals.dart';
import '../src/datasource/local/storage_service.dart';
import '../src/datasource/network/network_connectivity_service.dart';
import 'my_app.dart';

Future<void> runMain({
  required BaseConfigs configs,
  required Widget Function(Widget child) builder,
  FutureOr<void> Function()? onInit,
}) async {
  baseConfigs = configs;
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    EasyLocalization.ensureInitialized(),
    _initSingletons(),
    AppTranslationController.initLocale(),
  ]);

  // Setting Device Orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await onInit?.call();

  runApp(builder(const MyApp()));
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
          baseConfigs.appAssetsPath.errorWidget,
          width: 100,
          height: 100,
        ),
      );
    };
  }
}

Future<void> _initSingletons() async {
  //Services
  GetIt.instance.registerLazySingleton<StorageService>(() => StorageService());
  GetIt.instance.registerLazySingleton<NetworkConnectivityService>(() => NetworkConnectivityService());

  //initiating db
  await GetIt.instance<StorageService>().init();
}

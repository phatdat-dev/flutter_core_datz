// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../flutter_core_datz.dart';
import '../widgets/loadding_widget.dart';

abstract class BaseConfigs {
  String get appTitle;
  RouterConfig<Object>? routerConfig(BuildContext context);
  AssetsPath get assetsPath => AssetsPath();
  ThemeState get themeState => ThemeState();
  ResponsiveScreenSettings get responsiveScreenSettings => const ResponsiveScreenSettings();
  BaseInitSingleton get baseInitSingleton => BaseInitSingleton();

  /// This is a default overlay loadding widget. (dialog)
  ///
  /// You can override this method to provide your own loadding widget.
  ///
  /// Using [Loadding.show()] to show the loadding widget.
  ///
  /// Using [Loadding.dismiss()] to dismiss the loadding widget.
  Widget Function(AssetImage imageLoadding) get loaddingWidget =>
      (imageLoadding) => DefaultLoaddingWidget(imageLoadding);
}

class AssetsPath {
  final String localization;
  final String loadding;
  final String errorWidget;
  final String imageError;

  AssetsPath({
    this.localization = 'assets/translations',
    this.loadding = 'assets/images/loading/loading.gif',
    this.errorWidget = 'assets/gif/error_widget.gif',
    this.imageError = 'assets/images/error.png',
  });

  // copyWith
  AssetsPath copyWith({
    String? localization,
    String? loadding,
    String? errorWidget,
    String? imageError,
  }) {
    return AssetsPath(
      localization: localization ?? this.localization,
      loadding: loadding ?? this.loadding,
      errorWidget: errorWidget ?? this.errorWidget,
      imageError: imageError ?? this.imageError,
    );
  }
}

class BaseInitSingleton {
  StorageService get storageService => StorageService();
  NetworkConnectivityService get networkConnectivityService => NetworkConnectivityService();
  TranslationController get translationController => TranslationController();
  ThemeController get themeController => ThemeController();
  AppExceptionController get appExceptionController => AppExceptionController();
  AppLifecycleService get appLifecycleController => AppLifecycleService();

  @mustCallSuper
  Future<void> init() async {
    // Services
    GetIt.instance.registerLazySingleton<StorageService>(() => storageService);
    GetIt.instance.registerLazySingleton<NetworkConnectivityService>(() => networkConnectivityService);
    GetIt.instance.registerLazySingleton<AppLifecycleService>(() => appLifecycleController);
    // Controllers
    GetIt.instance.registerLazySingleton<TranslationController>(() => translationController);
    GetIt.instance.registerLazySingleton<ThemeController>(() => themeController);
    GetIt.instance.registerLazySingleton<AppExceptionController>(() => appExceptionController);

    // initiating db
    await GetIt.instance<StorageService>().init();
    // initiating Translation
    await GetIt.instance<TranslationController>().init();
  }
}

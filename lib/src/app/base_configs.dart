// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';

import '../../flutter_core_datz.dart';

abstract class BaseConfigs {
  String get appTitle;
  RouterConfig<Object>? routerConfig(BuildContext context);
  AssetsPath get assetsPath => AssetsPath();
  ThemeState get themeState => ThemeState();
  TranslationController get translationController => TranslationController();
  ResponsiveScreenSettings get responsiveScreenSettings => const ResponsiveScreenSettings();
  StorageService get storageService => StorageService();
  NetworkConnectivityService get networkConnectivityService => NetworkConnectivityService();
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
  AssetsPath copyWith({String? localization, String? loadding, String? errorWidget, String? imageError}) {
    return AssetsPath(
      localization: localization ?? this.localization,
      loadding: loadding ?? this.loadding,
      errorWidget: errorWidget ?? this.errorWidget,
      imageError: imageError ?? this.imageError,
    );
  }
}

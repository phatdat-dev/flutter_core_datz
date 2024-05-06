import 'package:go_router/go_router.dart';

import '../../flutter_core_datz.dart';

late BaseConfigs baseConfigs;

abstract class BaseConfigs {
  String get appTitle;
  GoRouter get router;
  AssetsPath get appAssetsPath => AssetsPath();
  ThemeState get themeState => ThemeState();
}

class AssetsPath {
  final String localization;
  final String loadding;
  final String errorWidget;
  final String imageError;

  AssetsPath({
    this.localization = 'assets/translations',
    this.loadding = 'assets/images/loading.gif',
    this.errorWidget = 'assets/gif/error_widget.gif',
    this.imageError = 'assets/images/error.png',
  });
}

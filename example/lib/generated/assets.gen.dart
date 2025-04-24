/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsGifGen {
  const $AssetsGifGen();

  /// File path: assets/gif/error_widget.gif
  AssetGenImage get errorWidget =>
      const AssetGenImage('assets/gif/error_widget.gif');

  /// File path: assets/gif/no-data.gif
  AssetGenImage get noData => const AssetGenImage('assets/gif/no-data.gif');

  /// List of all assets
  List<AssetGenImage> get values => [errorWidget, noData];
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/ask.png
  AssetGenImage get ask => const AssetGenImage('assets/icons/ask.png');

  /// List of all assets
  List<AssetGenImage> get values => [ask];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// Directory path: assets/images/authenication
  $AssetsImagesAuthenicationGen get authenication =>
      const $AssetsImagesAuthenicationGen();

  /// File path: assets/images/avatar.jpg
  AssetGenImage get avatar => const AssetGenImage('assets/images/avatar.jpg');

  /// File path: assets/images/bg_liquid.png
  AssetGenImage get bgLiquid =>
      const AssetGenImage('assets/images/bg_liquid.png');

  /// File path: assets/images/error.png
  AssetGenImage get error => const AssetGenImage('assets/images/error.png');

  /// Directory path: assets/images/loading
  $AssetsImagesLoadingGen get loading => const $AssetsImagesLoadingGen();

  /// Directory path: assets/images/logo
  $AssetsImagesLogoGen get logo => const $AssetsImagesLogoGen();

  /// List of all assets
  List<AssetGenImage> get values => [avatar, bgLiquid, error];
}

class $AssetsSvgGen {
  const $AssetsSvgGen();

  /// File path: assets/svg/shield-success.svg
  String get shieldSuccess => 'assets/svg/shield-success.svg';

  /// List of all assets
  List<String> get values => [shieldSuccess];
}

class $AssetsTranslationsGen {
  const $AssetsTranslationsGen();

  /// File path: assets/translations/en-US.json
  String get enUS => 'assets/translations/en-US.json';

  /// File path: assets/translations/vi-VN.json
  String get viVN => 'assets/translations/vi-VN.json';

  /// List of all assets
  List<String> get values => [enUS, viVN];
}

class $AssetsImagesAuthenicationGen {
  const $AssetsImagesAuthenicationGen();

  /// File path: assets/images/authenication/forgot-verified.jpeg
  AssetGenImage get forgotVerified =>
      const AssetGenImage('assets/images/authenication/forgot-verified.jpeg');

  /// File path: assets/images/authenication/new_password.png
  AssetGenImage get newPassword =>
      const AssetGenImage('assets/images/authenication/new_password.png');

  /// File path: assets/images/authenication/select_type_change_password.png
  AssetGenImage get selectTypeChangePassword => const AssetGenImage(
    'assets/images/authenication/select_type_change_password.png',
  );

  /// List of all assets
  List<AssetGenImage> get values => [
    forgotVerified,
    newPassword,
    selectTypeChangePassword,
  ];
}

class $AssetsImagesLoadingGen {
  const $AssetsImagesLoadingGen();

  /// File path: assets/images/loading/loading.gif
  AssetGenImage get loading =>
      const AssetGenImage('assets/images/loading/loading.gif');

  /// List of all assets
  List<AssetGenImage> get values => [loading];
}

class $AssetsImagesLogoGen {
  const $AssetsImagesLogoGen();

  /// File path: assets/images/logo/logo-512x512.png
  AssetGenImage get logo512x512 =>
      const AssetGenImage('assets/images/logo/logo-512x512.png');

  /// File path: assets/images/logo/logo-removebg-crop-1152x1152-circle-768.png
  AssetGenImage get logoRemovebgCrop1152x1152Circle768 => const AssetGenImage(
    'assets/images/logo/logo-removebg-crop-1152x1152-circle-768.png',
  );

  /// File path: assets/images/logo/logo-removebg.png
  AssetGenImage get logoRemovebg =>
      const AssetGenImage('assets/images/logo/logo-removebg.png');

  /// File path: assets/images/logo/logo.png
  AssetGenImage get logo => const AssetGenImage('assets/images/logo/logo.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    logo512x512,
    logoRemovebgCrop1152x1152Circle768,
    logoRemovebg,
    logo,
  ];
}

class Assets {
  const Assets._();

  static const String aEnv = '.env';
  static const $AssetsGifGen gif = $AssetsGifGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsSvgGen svg = $AssetsSvgGen();
  static const $AssetsTranslationsGen translations = $AssetsTranslationsGen();

  /// List of all assets
  static List<String> get values => [aEnv];
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size, this.flavors = const {}});

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

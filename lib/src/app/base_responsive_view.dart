// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'base_configs.dart';

mixin BaseResponsiveMixin on Diagnosticable {
// mixin BaseResponsiveMixin {
  /// [400-700] => Phone
  static late bool isMobile;

  /// [700-1000] => Tablet
  static late bool isTablet;

  /// [1000-...] => Desktop
  static late bool isDesktop;

  @protected
  @visibleForOverriding
  @Deprecated("Don't use this method directly, use wrapWidget instead")
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        final settings = baseConfigs.responsiveScreenSettings;
        final width = MediaQuery.sizeOf(context).width;
        final isPortrait = (orientation == Orientation.portrait);

        /// Nếu đang ở trạng thái bình thường (nằm dọc-mobile)
        isMobile = isPortrait && (width < settings.watchChangePoint);
        isTablet = (width >= settings.tabletChangePoint) && (width < settings.desktopChangePoint);
        isDesktop = (width >= settings.desktopChangePoint);

        Widget? widget;

        if (isDesktop) {
          widget = buildDesktop(context);
        } else if (isTablet) {
          widget = buildTablet(context);
        } else if (isMobile) {
          widget = buildMobile(context);
        }
        widget ??= const Center(
            child: Text(
          'Screen size not suitable !',
          style: TextStyle(color: Colors.red, fontSize: 16),
          textAlign: TextAlign.center,
        ));

        return wrapWidget(context, widget) ?? widget;
      },
    );
  }

  /// Wrap widget before build ex:
  /// ```dart
  /// @override
  /// Widget? wrapWidget(context, child) {
  ///   return GestureDetector(
  ///       //unforcus keyboard
  ///       onTap: () => WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(),
  ///       child: Scaffold(
  ///         body: child,
  ///       ));
  /// }
  /// ```
  Widget? wrapWidget(BuildContext context, Widget child) => null;

  Widget? buildDesktop(BuildContext context) => null;

  Widget? buildTablet(BuildContext context) => null;

  Widget? buildMobile(BuildContext context) => null;
}

class ResponsiveScreenSettings {
  /// When the width is greater als this value
  /// the display will be set as [ScreenType.Desktop]
  final double desktopChangePoint;

  /// When the width is greater als this value
  /// the display will be set as [ScreenType.Tablet]
  /// or when width greater als [watchChangePoint] and smaller als this value
  /// the display will be [ScreenType.Phone]
  final double tabletChangePoint;

  /// When the width is smaller als this value
  /// the display will be set as [ScreenType.Watch]
  /// or when width greater als this value and smaller als [tabletChangePoint]
  /// the display will be [ScreenType.Phone]
  final double watchChangePoint;

  const ResponsiveScreenSettings({
    this.desktopChangePoint = 1000,
    this.tabletChangePoint = 700,
    this.watchChangePoint = 400,
  });
}

// ----------------- Example -----------------
/*
class StatelessScreen extends StatelessWidget with BaseResponsiveMixin {
  const StatelessScreen({super.key});

  @override
  Widget? buildDesktop(BuildContext context) => const Scaffold(body: Center(child: Text('Desktop')));

  @override
  Widget? buildTablet(BuildContext context) => const Scaffold(body: Center(child: Text('Tablet')));

  @override
  Widget? buildMobile(BuildContext context) => const Scaffold(body: Center(child: Text('Mobile')));
}

class StatefulScreen extends StatefulWidget {
  const StatefulScreen({super.key});

  @override
  State<StatefulScreen> createState() => _StatefulScreenState();
}

class _StatefulScreenState extends State<StatefulScreen> with BaseResponsiveMixin {
  @override
  Widget? buildDesktop(BuildContext context) => const Scaffold(body: Center(child: Text('Desktop')));

  @override
  Widget? buildTablet(BuildContext context) => const Scaffold(body: Center(child: Text('Tablet')));

  @override
  Widget? buildMobile(BuildContext context) => const Scaffold(body: Center(child: Text('Mobile')));
}
*/
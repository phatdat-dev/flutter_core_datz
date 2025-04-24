// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'base_configs.dart';

mixin BaseResponsiveMixin on Diagnosticable {
  /// [0-300] => Watch
  static late bool isWatch;

  /// [300-600] => Phone
  static late bool isMobile;

  /// [600-900] => Tablet
  static late bool isTablet;

  /// [900-...] => Desktop
  static late bool isDesktop;

  @protected
  @visibleForOverriding
  @Deprecated("Don't use this method directly, use wrapWidget instead")
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        final configs = GetIt.instance<BaseConfigs>();
        final settings = configs.responsiveScreenSettings;
        final width = MediaQuery.sizeOf(context).width;
        // final isPortrait = (orientation == Orientation.portrait);

        /// Nếu đang ở trạng thái bình thường (nằm dọc-mobile)
        // isMobile = isPortrait && (width < settings.mobileChangePoint);
        isWatch = (width < settings.mobileChangePoint);
        isMobile = (width >= settings.mobileChangePoint) && (width < settings.tabletChangePoint);
        isTablet = (width >= settings.tabletChangePoint) && (width < settings.desktopChangePoint);
        isDesktop = (width >= settings.desktopChangePoint);

        Widget? widget;

        if (isDesktop) {
          widget = buildDesktop(context);
        } else if (isTablet) {
          widget = buildTablet(context);
        } else if (isMobile) {
          widget = buildMobile(context);
        } else if (isWatch) {
          widget = buildWatch(context);
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

  Widget? buildWatch(BuildContext context) => null;
}

class ResponsiveScreenSettings {
  final double desktopChangePoint;
  final double tabletChangePoint;
  final double mobileChangePoint;

  const ResponsiveScreenSettings({
    this.desktopChangePoint = 900,
    this.tabletChangePoint = 600,
    this.mobileChangePoint = 300,
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
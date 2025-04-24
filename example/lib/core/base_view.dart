import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../shared/extensions/get_it/get_it_extensions.dart';
import 'controller/base_controller.dart';

mixin RegisterBaseControllerStateMixin<T extends StatefulWidget, C extends BaseController> on State<T> {
  late final C controller;

  @override
  void initState() {
    controller = createController()..onInitData();
    GetIt.instance.refresh(() => controller);
    super.initState();
  }

  @override
  void dispose() {
    controller.onDispose();
    GetIt.instance.unregister<C>();
    super.dispose();
  }

  C createController();
}
mixin GetOrRegisterBaseControllerStateMixin<T extends StatefulWidget, C extends BaseController> on State<T> {
  late final C controller;

  @override
  void initState() {
    controller = GetIt.instance.getOrRegisterSingleton(() => createController()..onInitData());
    super.initState();
  }

  C createController();
}

enum RolesEnum { admin, user }

mixin BaseRoleView<T extends Enum> on Diagnosticable {
  // đáng lý ra ko cần dùng ValueNotifier, nhưng để dễ test thì mình dùng ValueNotifier
  ValueNotifier<T> get role;
  //
  Map<T, Widget> buildRoles(BuildContext context);

  @protected
  @visibleForOverriding
  @Deprecated("Don't use this method directly, use wrapWidget instead")
  Widget build(BuildContext context) => ValueListenableBuilder(
    valueListenable: role,
    builder: (context, role, child) {
      Widget? widget;
      widget = buildRoles(context)[role];
      widget ??= buildDefault(context);

      return wrapWidget(context, widget) ?? widget;
    },
  );

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

  Widget buildDefault(BuildContext context) => Center(child: Text("UnderDevelopment".tr()));
}

// ignore_for_file: depend_on_referenced_packages

import 'package:example/main.dart';
import 'package:example/setting/screens/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_datz/flutter_core_datz.dart' as core_datz;
import 'package:go_router/go_router.dart';

part 'app_router.g.dart';

const String _initialRoute = '/';

final goRouter = GoRouter(
  initialLocation: _initialRoute,
  navigatorKey: core_datz.AppGlobals.rootNavigatorKey, //TODO: Here
  debugLogDiagnostics: true,
  routes: [...$appRoutes, ...core_datz.$appRoutes],
);

@TypedGoRoute<HomeRoute>(path: '/')
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

@TypedGoRoute<SettingRoute>(path: '/setting')
class SettingRoute extends GoRouteData {
  const SettingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const SettingScreen();
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/app_exception/app_exception_screen.dart';
import '../features/theme/test_theme_screen.dart';

part 'app_route.g.dart';

@TypedGoRoute<AppExceptionRoute>(path: '/view-error')
class AppExceptionRoute extends GoRouteData {
  const AppExceptionRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const AppExceptionScreen();
}

@TypedGoRoute<TestThemeRoute>(path: '/test-theme')
class TestThemeRoute extends GoRouteData {
  const TestThemeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const TestThemeScreen();
}

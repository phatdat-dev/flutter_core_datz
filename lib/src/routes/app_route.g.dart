// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_route.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $appExceptionRoute,
      $testThemeRoute,
    ];

RouteBase get $appExceptionRoute => GoRouteData.$route(
      path: '/view-error',
      factory: $AppExceptionRouteExtension._fromState,
    );

extension $AppExceptionRouteExtension on AppExceptionRoute {
  static AppExceptionRoute _fromState(GoRouterState state) =>
      const AppExceptionRoute();

  String get location => GoRouteData.$location(
        '/view-error',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $testThemeRoute => GoRouteData.$route(
      path: '/test-theme',
      factory: $TestThemeRouteExtension._fromState,
    );

extension $TestThemeRouteExtension on TestThemeRoute {
  static TestThemeRoute _fromState(GoRouterState state) =>
      const TestThemeRoute();

  String get location => GoRouteData.$location(
        '/test-theme',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

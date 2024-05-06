import 'package:go_router/go_router.dart';

extension GoRouterExtension on GoRouter {
  /// Get the current location of the router
  String get location {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch ? lastMatch.matches : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }

  // popUntil with path
  void popUntil(String routePath) {
    while (routerDelegate.currentConfiguration.last.matchedLocation != routePath) {
      if (!canPop()) return;
      pop();
    }
  }
}

// extension GoRouterBuildContextExtension on BuildContext{

// }
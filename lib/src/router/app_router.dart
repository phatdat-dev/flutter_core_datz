import 'package:auto_route/auto_route.dart';

import '../features/app_exception/app_exception_view.dart';
import '../features/app_log/view/app_log_view.dart';
import '../features/theme/test_theme_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page|Screen|View,Route')
class DAppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: AppExceptionRoute.page),
    AutoRoute(page: TestThemeRoute.page),
    AutoRoute(page: AppLogRoute.page),
  ];
}

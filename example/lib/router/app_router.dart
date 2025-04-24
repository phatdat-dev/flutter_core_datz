import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_datz/flutter_core_datz.dart' as datz;

import '../features/authentication/forgot_password/view/forgot_password_1_select_view.dart';
import '../features/authentication/forgot_password/view/forgot_password_2_pin_view.dart';
import '../features/authentication/forgot_password/view/forgot_password_3_newpass_view.dart';
import '../features/authentication/login/view/login_view.dart';
import '../features/authentication/register/view/register_view.dart';
import '../features/notification/view/notification_view.dart';
import '../features/scaffold/account/view/account_view.dart';
import '../features/scaffold/home/view/home_view.dart';
import '../features/scaffold/scaffold_curved_bottomnav_view.dart';
import '../features/scaffold/scaffold_view.dart';
import '../features/scaffold/track/view/track_view.dart';
import '../features/scaffold/wallet/view/wallet_view.dart';
import '../features/setting/view/setting_view.dart';
import '../features/user/view/user_view.dart';
import '../shared/widgets/test_widget/test_view.dart';

part 'app_router.gr.dart';

final appRouter = AppRouter();

@AutoRouterConfig(replaceInRouteName: 'Page|Screen|View,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    ...datz.DAppRouter().routes,
    AutoRoute(
      initial: true,
      page: ScaffoldCurvedBottomnavRoute.page,
      children: [
        AutoRoute(page: HomeRoute.page),
        AutoRoute(page: TrackRoute.page),
        AutoRoute(page: WalletRoute.page),
        AutoRoute(page: AccountRoute.page),
      ],
    ),
    AutoRoute(page: ForgotPassword1SelectRoute.page),
    AutoRoute(page: ForgotPassword2PinRoute.page),
    AutoRoute(page: ForgotPassword3NewPassRoute.page),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: NotificationRoute.page),
    AutoRoute(page: RegisterRoute.page),
    AutoRoute(page: SettingRoute.page),
    AutoRoute(page: TestRoute.page),
    AutoRoute(page: UserRoute.page),
  ];
}

/*
int _random = -1;
CustomTransitionPage _buildPage(BuildContext context, GoRouterState state, Widget child) {
  final list = PageTransitionType.getValueWithoutPop;
  _random += 1;
  if (_random > list.length - 1) _random = 0;

  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
      return buildTransitionss(context, animation, secondaryAnimation, child, type: list.elementAt(_random), alignment: Alignment.center);
    },
  );
}
*/

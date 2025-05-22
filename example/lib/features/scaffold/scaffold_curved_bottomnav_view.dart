import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../app/app_globals.dart';
import '../../core/check_app_view.dart';
import '../../packages/curved_navigation_bar/curved_navigation_bar.dart';
import '../../router/app_router.dart';
import '../../shared/extensions/get_it/get_it_extensions.dart';
import '../notification/controller/notification_controller.dart';
import 'home/controller/home_controller.dart';

@RoutePage()
class ScaffoldCurvedBottomnavView extends StatefulWidget {
  const ScaffoldCurvedBottomnavView({super.key});

  @override
  State<ScaffoldCurvedBottomnavView> createState() =>
      _ScaffoldCurvedBottomnavViewState();
}

class _ScaffoldCurvedBottomnavViewState
    extends State<ScaffoldCurvedBottomnavView> {
  @override
  void initState() {
    GetIt.instance.refresh(() => HomeController()..onInitData());
    GetIt.instance.refresh(() => NotificationController()..onInitData());

    // WidgetsBinding.instance.addPostFrameCallback((_) => requestIOSAppTrackingTransparency());
    super.initState();
  }

  /*

  Future<void> showCustomTrackingDialog(BuildContext context) async {
    // Implement your custom tracking dialog here
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text("Theo dõi tính minh bạch"),
          content: const Text(
            '''Chúng tôi sẽ mở đến tùy chọn cho phép theo dõi tính minh bạch thông tin của bạn, nhằm để phục vụ trải nghiệm tốt nhất, để xác thực các thông tin như ID thiết bị, Số điện thoại...
            \nCác thông tin bạn khai báo khi đặt vé nếu không chính xác có thể dẫn đến phiền phức rất lớn đó !''',
          ),
          actions: <Widget>[
            TextButton(child: const Text("OK", style: TextStyle(fontWeight: FontWeight.bold)), onPressed: () => Navigator.of(context).pop()),
          ],
        );
      },
    );
  }

  void requestIOSAppTrackingTransparency() async {
    // If the system can show an authorization request dialog
    if (await AppTrackingTransparency.trackingAuthorizationStatus == TrackingStatus.notDetermined) {
      // Show a custom explainer dialog before the system dialog
      await showCustomTrackingDialog(context);
      // Wait for dialog popping animation
      await Future.delayed(const Duration(milliseconds: 200));
      // Request system's tracking authorization dialog
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }

*/
  @override
  void dispose() {
    GetIt.instance.unregister<HomeController>();
    GetIt.instance.unregister<NotificationController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CheckAppView(
      child: AutoTabsRouter.builder(
        routes: [
          const HomeRoute(),
          const WalletRoute(),
          const TrackRoute(),
          const AccountRoute(),
        ],
        builder: (context, children, tabsRouter) => GestureDetector(
          //huy keyboard khi bam ngoai man hinh
          onTap: () =>
              WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(),
          child: Scaffold(
            // resizeToAvoidBottomInset: true,
            // extendBody: true,
            extendBodyBehindAppBar: true,
            extendBody: true,
            body: Stack(
              children: children.mapIndexed((int index, Widget navigator) {
                final isCurrent = index == tabsRouter.activeIndex;
                return AnimatedScale(
                  scale: isCurrent ? 1 : 1.5,
                  duration: const Duration(milliseconds: 150),
                  child: AnimatedOpacity(
                    opacity: isCurrent ? 1 : 0,
                    duration: const Duration(milliseconds: 150),
                    child: IgnorePointer(
                      ignoring: !isCurrent,
                      child: TickerMode(enabled: isCurrent, child: navigator),
                    ),
                  ),
                );
              }).toList(),
            ),
            //Footer
            bottomNavigationBar: BottomNavigationWidget(tabsRouter),
          ),
        ),
      ),
    );
  }
}

class BottomNavigationWidget extends StatelessWidget {
  const BottomNavigationWidget(this.tabsRouter, {super.key});
  final TabsRouter tabsRouter;

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      color: Theme.of(context).colorScheme.primary,
      // buttonBackgroundColor: Theme.of(context).primaryColor,
      // buttonLabelColor: Colors.white,
      animationDuration: const Duration(milliseconds: 300),
      height: AppGlobals.isIos ? 80 : 65,
      onTap: (index) => tabsRouter.setActiveIndex(index),
      items:
          {
                "Home": MingCute.home_5_line,
                "Wallet": MingCute.wallet_4_line,
                "Track": MingCute.car_line,
                "Account": MingCute.user_3_line,
              }.entries
              .map(
                (e) => CurvedNavigationBarItem(
                  icon: Icon(e.value, color: Colors.white, size: 30),
                  label: Text(
                    e.key,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
    );
  }
}

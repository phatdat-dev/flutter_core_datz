import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_datz/flutter_core_datz.dart';
import 'package:get_it/get_it.dart';

import '../../app/app_constants.dart';
import '../../core/check_app_view.dart';
import '../../router/app_router.dart';
import '../../shared/extensions/get_it/get_it_extensions.dart';
import '../notification/controller/notification_controller.dart';
import 'home/controller/home_controller.dart';

@RoutePage()
class ScaffoldView extends StatefulWidget {
  const ScaffoldView({super.key});

  @override
  State<ScaffoldView> createState() => _ScaffoldViewState();
}

class _ScaffoldViewState extends State<ScaffoldView> {
  @override
  void initState() {
    GetIt.instance<NetworkConnectivityService>().onInit();

    GetIt.instance.refresh(() => HomeController()..onInitData());
    GetIt.instance.refresh(() => NotificationController()..onInitData());
    super.initState();
  }

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
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Card(
                elevation: 3,
                child: BottomNavigationWidget(tabsRouter),
              ),
            ),
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
    return ClipRRect(
      borderRadius: AppConstants.borderRadius,
      child: BottomNavigationBar(
        backgroundColor: context.theme.colorScheme.surface,
        currentIndex: tabsRouter.activeIndex,
        unselectedItemColor: context.theme.hintColor,
        //backgroundColor: Colors.amber,
        type: BottomNavigationBarType.fixed, //ko cho no thu nho? mat chu~
        iconSize: 20,
        // selectedIconTheme: const IconThemeData(size: 30),
        //selectedItemColor: Colors.indigo,
        onTap: (index) => tabsRouter.setActiveIndex(index),
        items: [
          bottomNavBarItem(
            context,
            label: 'Trang chủ',
            iconData: Icons.home_outlined,
          ),
          bottomNavBarItem(
            context,
            label: 'Khám phá',
            iconData: Icons.play_arrow_outlined,
          ),
          bottomNavBarItem(
            context,
            label: 'Đặt chổ của tôi',
            iconData: Icons.receipt_long_outlined,
          ),
          bottomNavBarItem(
            context,
            label: 'Tài khoản',
            iconData: Icons.person_outline,
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem bottomNavBarItem(
    BuildContext context, {
    required String label,
    required IconData iconData,
  }) {
    final colorScheme = context.theme.colorScheme;
    return BottomNavigationBarItem(
      // backgroundColor: colorScheme.surface,
      label: label.tr(),
      icon: SizedBox(
        height: 30,
        // padding: const EdgeInsets.all(3),
        // margin: const EdgeInsets.all(5),
        // decoration: BoxDecoration(color: colorScheme.secondary, borderRadius: AppConstants.borderRadius),
        child: Icon(iconData),
      ),
      activeIcon: Container(
        height: 30,
        padding: const EdgeInsets.all(5),
        // margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          shape: BoxShape.circle,
        ),
        child: Icon(iconData, color: colorScheme.surface),
      ),
    );
  }
}

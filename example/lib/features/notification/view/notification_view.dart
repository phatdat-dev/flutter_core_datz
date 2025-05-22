import 'package:animate_do/animate_do.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../app/app_constants.dart';
import '../widget/notify_card_widget.dart';

@RoutePage()
class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  Widget build(BuildContext context) {
    int indexx = 0;
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              title: const Text("Thông báo"),
              centerTitle: true,
              pinned: true,
              shadowColor: Theme.of(context).highlightColor,
            ),
          ],
          body: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingContent,
            ),
            children: [
              ...List.generate(2, (index) {
                (indexx % 10 == 0) ? indexx = 0 : indexx++;
                return FadeInRight(
                  duration: Duration(milliseconds: 700 + (indexx * 100)),
                  child: const NotifyCardWidget(),
                );
              }),
              const SizedBox(height: kBottomNavigationBarHeight * 1.5),
            ],
          ),
        ),
      ),
    );
  }
}

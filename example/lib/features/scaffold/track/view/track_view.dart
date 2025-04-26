import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../../app/app_constants.dart';
import '../../../../app/app_globals.dart';

@RoutePage()
class TrackView extends StatefulWidget {
  const TrackView({super.key});

  @override
  State<TrackView> createState() => _TrackViewState();
}

class _TrackViewState extends State<TrackView> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(title: Text("Track")),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingContent),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 10),

              SizedBox(height: kBottomNavigationBarHeight * (AppGlobals.isIos ? 2.3 : 1.5)),
            ]),
          ),
        ),
      ],
    );
  }
}

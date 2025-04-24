import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../../app/app_constants.dart';
import '../../../../app/globals.dart';

@RoutePage()
class WalletView extends StatefulWidget {
  const WalletView({super.key});

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(title: Text("Wallet")),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingContent),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 10),

              SizedBox(height: kBottomNavigationBarHeight * (Globals.isIos ? 2.3 : 1.5)),
            ]),
          ),
        ),
      ],
    );
  }
}

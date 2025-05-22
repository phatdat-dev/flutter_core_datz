import 'package:flutter/material.dart';

import '../../app/app_constants.dart';
import '../widgets/search_bar_widget.dart';

class BaseListViewSearchWithTabBar extends StatefulWidget {
  const BaseListViewSearchWithTabBar({
    super.key,
    this.title,
    required this.tabBarWidget,
    this.onChangedSearchBar,
  });

  final String? title;
  final Map<Tab, Widget> tabBarWidget;
  final void Function(String searchText, int index)? onChangedSearchBar;

  @override
  State<BaseListViewSearchWithTabBar> createState() =>
      _BaseListViewSearchWithTabBarState();
}

class _BaseListViewSearchWithTabBarState
    extends State<BaseListViewSearchWithTabBar>
    with SingleTickerProviderStateMixin {
  late final TabController tabBarController;

  @override
  void initState() {
    tabBarController = TabController(
      length: widget.tabBarWidget.length,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // extendBody: true,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: GestureDetector(
          onTap: () =>
              WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(),
          child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                floating: true, //giuu lau bottom
                pinned: true, //giuu lai bottom
                snap: true,
                title: widget.title != null ? Text(widget.title!) : null,
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.filter_alt_outlined),
                  ),
                ],
                expandedHeight: 150,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  centerTitle: true,
                  titlePadding: EdgeInsets.zero,
                  background: Container(
                    padding: const EdgeInsets.only(
                      top: kToolbarHeight,
                      bottom: kToolbarHeight / 1.3,
                      left: AppConstants.paddingContent,
                      right: AppConstants.paddingContent,
                    ),
                    child: SearchBarWidget(
                      onChanged: widget.onChangedSearchBar != null
                          ? (value) => widget.onChangedSearchBar!(
                              value,
                              tabBarController.index,
                            )
                          : null,
                    ),
                  ),
                ),
                bottom: TabBar(
                  controller: tabBarController,
                  tabs: widget.tabBarWidget.keys.toList(),
                  labelColor: Theme.of(context).colorScheme.onSurface,
                  unselectedLabelColor: Theme.of(context).hintColor,
                  // indicator: BoxDecoration(
                  //   borderRadius: AppConstants.borderRadius,
                  //   border: Border.all(color: Colors.green),
                  // ),
                  indicatorColor: Colors.green,
                  indicatorSize: TabBarIndicatorSize.tab,
                  splashBorderRadius: AppConstants.borderRadius,
                ),
              ),
            ],
            body: Padding(
              padding: const EdgeInsets.only(
                left: AppConstants.paddingContent,
                right: AppConstants.paddingContent,
                top: AppConstants.paddingContent,
              ),
              child: TabBarView(
                controller: tabBarController,
                children: widget.tabBarWidget.values.toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

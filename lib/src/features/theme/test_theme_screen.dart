import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import '../../../flutter_core_datz.dart';

class TestThemeScreen extends StatefulWidget {
  const TestThemeScreen({super.key});

  @override
  State<TestThemeScreen> createState() => _TestThemeScreenState();
}

class _TestThemeScreenState extends State<TestThemeScreen> with SingleTickerProviderStateMixin {
  late final TabController tabbarController;
  @override
  void initState() {
    tabbarController = TabController(length: 2, vsync: this);
    tabbarController.addListener(() {
      final themeController = GetIt.instance<ThemeController>();
      switch (tabbarController.index) {
        case 0:
          if (themeController.state.themeMode != ThemeMode.light) {
            themeController.state = themeController.state.copyWith(themeMode: ThemeMode.light);
          }
          break;
        case 1:
          if (themeController.state.themeMode != ThemeMode.dark) {
            themeController.state = themeController.state.copyWith(themeMode: ThemeMode.dark);
          }
          break;
        default:
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Theme'),
          bottom: TabBar(
            controller: tabbarController,
            tabs: const [
              Tab(text: 'Light'),
              Tab(text: 'Dark'),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabbarController,
          children: [
            Theme(data: ThemeData.light(), child: _buildThemeColor(context)),
            Theme(data: ThemeData.dark(), child: _buildThemeColor(context)),
          ],
        ));
  }

  ListView _buildThemeColor(BuildContext context) {
    return ListView(
      children: [
        GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            buildColorTheme(Theme.of(context).canvasColor, 'canvasColor'),
            buildColorTheme(Theme.of(context).cardColor, 'cardColor'),
            buildColorTheme(Theme.of(context).dialogBackgroundColor, 'dialogBackgroundColor'),
            buildColorTheme(Theme.of(context).disabledColor, 'disabledColor'),
            buildColorTheme(Theme.of(context).dividerColor, 'dividerColor'),
            buildColorTheme(Theme.of(context).focusColor, 'focusColor'),
            buildColorTheme(Theme.of(context).highlightColor, 'highlightColor'),
            buildColorTheme(Theme.of(context).hintColor, 'hintColor'),
            buildColorTheme(Theme.of(context).hoverColor, 'hoverColor'),
            buildColorTheme(Theme.of(context).indicatorColor, 'indicatorColor'),
            buildColorTheme(Theme.of(context).primaryColor, 'primaryColor'),
            buildColorTheme(Theme.of(context).primaryColorDark, 'primaryColorDark'),
            buildColorTheme(Theme.of(context).primaryColorLight, 'primaryColorLight'),
            buildColorTheme(Theme.of(context).scaffoldBackgroundColor, 'scaffoldBackgroundColor'),
            buildColorTheme(Theme.of(context).secondaryHeaderColor, 'secondaryHeaderColor'),
            buildColorTheme(Theme.of(context).shadowColor, 'shadowColor'),
            buildColorTheme(Theme.of(context).splashColor, 'splashColor'),
            buildColorTheme(Theme.of(context).unselectedWidgetColor, 'unselectedWidgetColor'),
          ],
        ),
        const Divider(thickness: 2, color: Colors.cyan),
        //build colorSheme
        GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            buildColorTheme(Theme.of(context).colorScheme.primary, 'primary'),
            buildColorTheme(Theme.of(context).colorScheme.onPrimary, 'onPrimary'),
            buildColorTheme(Theme.of(context).colorScheme.primaryContainer, 'primaryContainer'),
            buildColorTheme(Theme.of(context).colorScheme.onPrimaryContainer, 'onPrimaryContainer'),
            buildColorTheme(Theme.of(context).colorScheme.primaryFixed, 'primaryFixed'),
            buildColorTheme(Theme.of(context).colorScheme.primaryFixedDim, 'primaryFixedDim'),
            buildColorTheme(Theme.of(context).colorScheme.onPrimaryFixed, 'onPrimaryFixed'),
            buildColorTheme(Theme.of(context).colorScheme.onPrimaryFixedVariant, 'onPrimaryFixedVariant'),
            buildColorTheme(Theme.of(context).colorScheme.secondary, 'secondary'),
            buildColorTheme(Theme.of(context).colorScheme.onSecondary, 'onSecondary'),
            buildColorTheme(Theme.of(context).colorScheme.secondaryContainer, 'secondaryContainer'),
            buildColorTheme(Theme.of(context).colorScheme.onSecondaryContainer, 'onSecondaryContainer'),
            buildColorTheme(Theme.of(context).colorScheme.secondaryFixed, 'secondaryFixed'),
            buildColorTheme(Theme.of(context).colorScheme.secondaryFixedDim, 'secondaryFixedDim'),
            buildColorTheme(Theme.of(context).colorScheme.onSecondaryFixed, 'onSecondaryFixed'),
            buildColorTheme(Theme.of(context).colorScheme.onSecondaryFixedVariant, 'onSecondaryFixedVariant'),
            buildColorTheme(Theme.of(context).colorScheme.tertiary, 'tertiary'),
            buildColorTheme(Theme.of(context).colorScheme.onTertiary, 'onTertiary'),
            buildColorTheme(Theme.of(context).colorScheme.tertiaryContainer, 'tertiaryContainer'),
            buildColorTheme(Theme.of(context).colorScheme.onTertiaryContainer, 'onTertiaryContainer'),
            buildColorTheme(Theme.of(context).colorScheme.tertiaryFixed, 'tertiaryFixed'),
            buildColorTheme(Theme.of(context).colorScheme.tertiaryFixedDim, 'tertiaryFixedDim'),
            buildColorTheme(Theme.of(context).colorScheme.onTertiaryFixed, 'onTertiaryFixed'),
            buildColorTheme(Theme.of(context).colorScheme.onTertiaryFixedVariant, 'onTertiaryFixedVariant'),
            buildColorTheme(Theme.of(context).colorScheme.error, 'error'),
            buildColorTheme(Theme.of(context).colorScheme.onError, 'onError'),
            buildColorTheme(Theme.of(context).colorScheme.errorContainer, 'errorContainer'),
            buildColorTheme(Theme.of(context).colorScheme.onErrorContainer, 'onErrorContainer'),
            buildColorTheme(Theme.of(context).colorScheme.surface, 'surface'),
            buildColorTheme(Theme.of(context).colorScheme.onSurface, 'onSurface'),
            buildColorTheme(Theme.of(context).colorScheme.surfaceDim, 'surfaceDim'),
            buildColorTheme(Theme.of(context).colorScheme.surfaceBright, 'surfaceBright'),
            buildColorTheme(Theme.of(context).colorScheme.surfaceContainerLowest, 'surfaceContainerLowest'),
            buildColorTheme(Theme.of(context).colorScheme.surfaceContainerLow, 'surfaceContainerLow'),
            buildColorTheme(Theme.of(context).colorScheme.surfaceContainer, 'surfaceContainer'),
            buildColorTheme(Theme.of(context).colorScheme.surfaceContainerHigh, 'surfaceContainerHigh'),
            buildColorTheme(Theme.of(context).colorScheme.surfaceContainerHighest, 'surfaceContainerHighest'),
            buildColorTheme(Theme.of(context).colorScheme.onSurfaceVariant, 'onSurfaceVariant'),
            buildColorTheme(Theme.of(context).colorScheme.outline, 'outline'),
            buildColorTheme(Theme.of(context).colorScheme.outlineVariant, 'outlineVariant'),
            buildColorTheme(Theme.of(context).colorScheme.shadow, 'shadow'),
            buildColorTheme(Theme.of(context).colorScheme.scrim, 'scrim'),
            buildColorTheme(Theme.of(context).colorScheme.inverseSurface, 'inverseSurface'),
            buildColorTheme(Theme.of(context).colorScheme.onInverseSurface, 'onInverseSurface'),
            buildColorTheme(Theme.of(context).colorScheme.inversePrimary, 'inversePrimary'),
            buildColorTheme(Theme.of(context).colorScheme.surfaceTint, 'surfaceTint'),
          ],
        ),
      ],
    );
  }

  Widget buildColorTheme(Color color, String name) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onLongPress: () => Clipboard.setData(ClipboardData(text: '${color.value}')),
          child: Container(
            width: 100,
            height: 100,
            color: color,
            child: Text('${color.value}'),
          ),
        ),
        Text(name, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}

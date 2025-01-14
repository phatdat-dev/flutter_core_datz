// ignore_for_file: depend_on_referenced_packages, implementation_imports

import 'package:example/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_datz/flutter_core_datz.dart';
import 'package:go_router/src/router.dart';

import 'app_router.dart';

class MyAppConfigs extends BaseConfigs {
  @override
  String get appTitle => "Flutter Core DatZ";

  @override
  GoRouter router(BuildContext context) => goRouter;

  @override
  ThemeState get themeState => ThemeState(
        lightTheme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
      );

  @override
  AssetsPath get assetsPath => AssetsPath().copyWith(
        loadding: 'assets/images/loading/loading-loop.gif',
      );
}

void main() => runMain(
      configs: MyAppConfigs(),
    );

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("HomeScreen")),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(onPressed: () => const SettingRoute().push(context), child: const Text("Setting")),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Test"),
            ),
          ],
        ),
      ),
    );
  }
}

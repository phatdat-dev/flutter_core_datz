import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../flutter_core_datz.dart';
import '../../app/base_configs.dart';

class ThemeController extends ChangeNotifier {
  late ThemeState _state;

  ThemeState get state => _state;
  set state(ThemeState value) {
    _state = value;
    _sharedPrefs.setString(AppStorageConstants.theme, _state.themeMode.name);
    notifyListeners();
  }

  ThemeController() {
    _state = loadThemeStorage(); // getDefaultTheme();
    notifyListeners();
  }
  final _sharedPrefs = GetIt.instance.get<StorageService>().sharedPreferences!;

  ThemeState getDefaultTheme() {
    final ThemeMode theme;
    final name = _sharedPrefs.get(AppStorageConstants.theme) as String?;
    if (name != null) {
      theme = ThemeMode.values.byName(name);
    } else {
      final defaultThemeMode = PlatformDispatcher.instance.platformBrightness;
      theme = ThemeMode.values.byName(defaultThemeMode.name);
    }

    return baseConfigs.themeState.copyWith(themeMode: theme);
  }

  void setDefaultTheme() {
    state = getDefaultTheme();
  }

  ThemeState loadThemeStorage() {
    final name = _sharedPrefs.get(AppStorageConstants.theme) as String?;
    final result = baseConfigs.themeState;
    if (name != null) {
      final themeMode = ThemeMode.values.byName(name);
      if (result.themeMode != themeMode) result.themeMode = themeMode;
    }
    return result;
  }
}

class ThemeState {
  ThemeMode themeMode;
  ThemeData? lightTheme;
  ThemeData? darkTheme;
  ThemeState({
    this.themeMode = ThemeMode.light,
    this.lightTheme,
    this.darkTheme,
  }) {
    lightTheme ??= ThemeData.light();
    darkTheme ??= ThemeData.dark();
  }

  ThemeState copyWith({
    ThemeMode? themeMode,
    ThemeData? lightTheme,
    ThemeData? darkTheme,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      lightTheme: lightTheme ?? this.lightTheme,
      darkTheme: darkTheme ?? this.darkTheme,
    );
  }
}

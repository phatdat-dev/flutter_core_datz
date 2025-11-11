import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../flutter_core_datz.dart';

class ThemeController extends ChangeNotifier {
  late ThemeState _state;

  ThemeState get state => _state;
  set state(ThemeState value) {
    _state = value;
    _sharedPrefs.setString(AppStorageConstants.theme, _state.themeMode.name);
    _saveThemeData();
    notifyListeners();
  }

  BaseConfigs get _configs => GetIt.instance<BaseConfigs>();

  ThemeController() {
    _state = loadThemeStorage(); // getDefaultTheme();
    notifyListeners();
  }
  final _sharedPrefs = GetIt.instance.get<StorageService>().sharedPreferences!;

  void _saveThemeData() {
    final themeData = <String, dynamic>{
      'lightTheme': _state.lightTheme?.toJson(),
      'darkTheme': _state.darkTheme?.toJson(),
    };
    _sharedPrefs.setString(AppStorageConstants.themeData, jsonEncode(themeData));
  }

  ThemeState getDefaultTheme() {
    final ThemeMode theme;
    final name = _sharedPrefs.get(AppStorageConstants.theme) as String?;
    if (name != null) {
      theme = ThemeMode.values.byName(name);
    } else {
      final defaultThemeMode = PlatformDispatcher.instance.platformBrightness;
      theme = ThemeMode.values.byName(defaultThemeMode.name);
    }

    return _configs.themeState.copyWith(themeMode: theme);
  }

  void setDefaultTheme() {
    state = getDefaultTheme();
    _sharedPrefs.remove(AppStorageConstants.themeData);
  }

  ThemeState loadThemeStorage() {
    final name = _sharedPrefs.get(AppStorageConstants.theme) as String?;
    final result = _configs.themeState;
    if (name != null) {
      final themeMode = ThemeMode.values.byName(name);
      if (result.themeMode != themeMode) result.themeMode = themeMode;
    }

    // Load saved theme data
    final themeDataString = _sharedPrefs.getString(AppStorageConstants.themeData);
    if (themeDataString != null) {
      try {
        final Map<String, dynamic> themeData = jsonDecode(themeDataString);
        final lightThemeData = ThemeDataExtension.fromJson(themeData['lightTheme'], false);
        final darkThemeData = ThemeDataExtension.fromJson(themeData['darkTheme'], true);

        return result.copyWith(lightTheme: lightThemeData, darkTheme: darkThemeData);
      } catch (e) {
        // If there's an error parsing, use default themes
        debugPrint('Error loading theme data: $e');
      }
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

extension ThemeDataExtension on ThemeData {
  Map<String, dynamic> toJson() {
    return {
      'primaryColor': primaryColor.toARGB32(),
      'colorScheme': {
        'primary': colorScheme.primary.toARGB32(),
        'secondary': colorScheme.secondary.toARGB32(),
        'surface': colorScheme.surface.toARGB32(),
        'background': colorScheme.surface.toARGB32(), // background is deprecated, using surface
        'error': colorScheme.error.toARGB32(),
        'onPrimary': colorScheme.onPrimary.toARGB32(),
        'onSecondary': colorScheme.onSecondary.toARGB32(),
        'onSurface': colorScheme.onSurface.toARGB32(),
        'onError': colorScheme.onError.toARGB32(),
        'brightness': colorScheme.brightness.name,
      },
      'appBarTheme': {
        'backgroundColor': appBarTheme.backgroundColor?.toARGB32(),
        'foregroundColor': appBarTheme.foregroundColor?.toARGB32(),
        'elevation': appBarTheme.elevation,
      },
      'textTheme': {
        'headlineLarge': {
          'fontSize': textTheme.headlineLarge?.fontSize,
          'fontWeight': textTheme.headlineLarge?.fontWeight?.index,
          'color': textTheme.headlineLarge?.color?.toARGB32(),
        },
        'bodyLarge': {
          'fontSize': textTheme.bodyLarge?.fontSize,
          'fontWeight': textTheme.bodyLarge?.fontWeight?.index,
          'color': textTheme.bodyLarge?.color?.toARGB32(),
        },
        'bodyMedium': {
          'fontSize': textTheme.bodyMedium?.fontSize,
          'fontWeight': textTheme.bodyMedium?.fontWeight?.index,
          'color': textTheme.bodyMedium?.color?.toARGB32(),
        },
      },
    };
  }

  static ThemeData fromJson(Map<String, dynamic> data, bool isDark) {
    final colorSchemeData = Map<String, dynamic>.from(data['colorScheme']);

    final brightness = colorSchemeData['brightness'] == 'dark' ? Brightness.dark : Brightness.light;
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: Color(colorSchemeData['primary'] ?? (isDark ? 0xFF90CAF9 : 0xFF1976D2)),
      secondary: Color(colorSchemeData['secondary'] ?? (isDark ? 0xFF81C784 : 0xFF388E3C)),
      surface: Color(colorSchemeData['surface'] ?? (isDark ? 0xFF121212 : 0xFFFFFFFF)),
      error: Color(colorSchemeData['error'] ?? (isDark ? 0xFFCF6679 : 0xFFB00020)),
      onPrimary: Color(colorSchemeData['onPrimary'] ?? (isDark ? 0xFF000000 : 0xFFFFFFFF)),
      onSecondary: Color(colorSchemeData['onSecondary'] ?? (isDark ? 0xFF000000 : 0xFFFFFFFF)),
      onSurface: Color(colorSchemeData['onSurface'] ?? (isDark ? 0xFFFFFFFF : 0xFF000000)),
      onError: Color(colorSchemeData['onError'] ?? (isDark ? 0xFF000000 : 0xFFFFFFFF)),
    );

    final appBarData = data['appBarTheme'] as Map<String, dynamic>?;
    final appBarTheme = AppBarTheme(
      backgroundColor: appBarData?['backgroundColor'] != null ? Color(appBarData!['backgroundColor']) : null,
      foregroundColor: appBarData?['foregroundColor'] != null ? Color(appBarData!['foregroundColor']) : null,
      elevation: appBarData?['elevation']?.toDouble(),
    );

    final textThemeData = data['textTheme'] as Map<String, dynamic>?;
    TextTheme? textTheme;
    if (textThemeData != null) {
      textTheme = TextTheme(
        headlineLarge: _deserializeTextStyle(textThemeData['headlineLarge']),
        bodyLarge: _deserializeTextStyle(textThemeData['bodyLarge']),
        bodyMedium: _deserializeTextStyle(textThemeData['bodyMedium']),
      );
    }

    return ThemeData(
      colorScheme: colorScheme,
      primaryColor: Color(data['primaryColor'] ?? colorScheme.primary.toARGB32()),
      appBarTheme: appBarTheme,
      textTheme: textTheme,
    );
  }

  static TextStyle? _deserializeTextStyle(Map<String, dynamic>? data) {
    if (data == null) return null;

    return TextStyle(
      fontSize: (data['fontSize'] as num?)?.toDouble(),
      fontWeight: data['fontWeight'] != null ? FontWeight.values[data['fontWeight']] : null,
      color: data['color'] != null ? Color(data['color']) : null,
    );
  }
}

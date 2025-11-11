import 'package:flutter/material.dart';

import '../../../../flutter_core_datz.dart';

/// Service managing app lifecycle
/// Used to catch events when app is terminated, paused, resumed, etc.
class AppLifecycleService with WidgetsBindingObserver {
  final bool enableLogging;
  AppLifecycleService({this.enableLogging = true});

  final List<VoidCallback> _onAppDetachedCallbacks = [];
  final List<VoidCallback> _onAppPausedCallbacks = [];
  final List<VoidCallback> _onAppResumedCallbacks = [];
  final List<VoidCallback> _onAppInactiveCallbacks = [];
  final List<VoidCallback> _onAppHiddenCallbacks = [];

  /// Initialize listener
  Future<void> init() async {
    WidgetsBinding.instance.addObserver(this);
    if (enableLogging) {
      Printt.defaultt('AppLifecycleService initialized');
      AppLogController.instance.info('AppLifecycleService initialized');
    }
  }

  /// Clean up when not needed
  Future<void> dispose() async {
    _onAppDetachedCallbacks.clear();
    _onAppPausedCallbacks.clear();
    _onAppResumedCallbacks.clear();
    _onAppInactiveCallbacks.clear();
    _onAppHiddenCallbacks.clear();
    WidgetsBinding.instance.removeObserver(this);
    if (enableLogging) {
      Printt.defaultt('AppLifecycleService disposed');
      AppLogController.instance.info('AppLifecycleService disposed');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.detached:
        // App has been completely terminated
        _runCallbacks(_onAppDetachedCallbacks);
        if (enableLogging) {
          final text = "App detached - App is being terminated";
          Printt.defaultt(text);
          AppLogController.instance.info(text);
        }
        break;
      case AppLifecycleState.paused:
        // App is paused (switching to another app or home screen)
        _runCallbacks(_onAppPausedCallbacks);
        if (enableLogging) {
          final text = "App paused - App is in background";
          Printt.defaultt(text);
          AppLogController.instance.info(text);
        }
        break;
      case AppLifecycleState.resumed:
        // App is resumed back
        _runCallbacks(_onAppResumedCallbacks);
        if (enableLogging) {
          final text = "App resumed - App is in foreground";
          Printt.defaultt(text);
          AppLogController.instance.info(text);
        }
        break;
      case AppLifecycleState.inactive:
        // App inactive (may be in transition)
        _runCallbacks(_onAppInactiveCallbacks);
        if (enableLogging) {
          final text = "App inactive - App is inactive";
          Printt.defaultt(text);
          AppLogController.instance.info(text);
        }
        break;
      case AppLifecycleState.hidden:
        // App is hidden (on some platforms)
        _runCallbacks(_onAppHiddenCallbacks);
        if (enableLogging) {
          final text = "App hidden - App is hidden";
          Printt.defaultt(text);
          AppLogController.instance.info(text);
        }
        break;
    }
  }

  /// Run all callbacks in the list
  void _runCallbacks(List<VoidCallback> callbacks) {
    for (final callback in callbacks) {
      try {
        callback();
      } catch (e) {
        Printt.defaultt('Error running lifecycle callback: $e');
      }
    }
  }

  void addAppLifecycleCallBack(AppLifecycleState state, VoidCallback callback) {
    switch (state) {
      case AppLifecycleState.detached:
        _onAppDetachedCallbacks.add(callback);
        break;
      case AppLifecycleState.paused:
        _onAppPausedCallbacks.add(callback);
        break;
      case AppLifecycleState.resumed:
        _onAppResumedCallbacks.add(callback);
        break;
      case AppLifecycleState.inactive:
        _onAppInactiveCallbacks.add(callback);
        break;
      case AppLifecycleState.hidden:
        _onAppHiddenCallbacks.add(callback);
        break;
    }
  }

  void removeAppLifecycleCallBack(AppLifecycleState state, VoidCallback callback) {
    switch (state) {
      case AppLifecycleState.detached:
        _onAppDetachedCallbacks.remove(callback);
        break;
      case AppLifecycleState.paused:
        _onAppPausedCallbacks.remove(callback);
        break;
      case AppLifecycleState.resumed:
        _onAppResumedCallbacks.remove(callback);
        break;
      case AppLifecycleState.inactive:
        _onAppInactiveCallbacks.remove(callback);
        break;
      case AppLifecycleState.hidden:
        _onAppHiddenCallbacks.remove(callback);
        break;
    }
  }

  // add Map<AppLifecycleState, List<VoidCallback>>
  void addMultipleAppLifecycleCallbacks(Map<AppLifecycleState, List<VoidCallback>> callbacksMap) {
    callbacksMap.forEach((state, callbacks) {
      for (final callback in callbacks) {
        addAppLifecycleCallBack(state, callback);
      }
    });
  }

  void removeMultipleAppLifecycleCallbacks(Map<AppLifecycleState, List<VoidCallback>> callbacksMap) {
    callbacksMap.forEach((state, callbacks) {
      for (final callback in callbacks) {
        removeAppLifecycleCallBack(state, callback);
      }
    });
  }
}

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../flutter_core_datz.dart';

/// Service managing app lifecycle
/// Used to catch events when app is terminated, paused, resumed, etc.
class AppLifecycleService with WidgetsBindingObserver {
  final List<VoidCallback> _onAppExitCallbacks = [];
  final List<VoidCallback> _onAppPausedCallbacks = [];
  final List<VoidCallback> _onAppResumedCallbacks = [];
  final List<VoidCallback> _onAppInactiveCallbacks = [];

  /// Initialize listener
  Future<void> init() async {
    WidgetsBinding.instance.addObserver(this);
    Printt.defaultt('AppLifecycleManager initialized');

    // Initialize AppLogController
    AppLogController.instance.init();
    AppLogController.instance.info('AppLifecycleManager initialized');
  }

  /// Clean up when not needed
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    _onAppExitCallbacks.clear();
    _onAppPausedCallbacks.clear();
    _onAppResumedCallbacks.clear();
    _onAppInactiveCallbacks.clear();
    Printt.defaultt('AppLifecycleManager disposed');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.detached:
        // App has been completely terminated
        Printt.defaultt('App state: detached - App is being terminated');
        AppLogController.instance.warn('App detached - App is being terminated');
        _runCallbacks(_onAppExitCallbacks);
        break;
      case AppLifecycleState.paused:
        // App is paused (switching to another app or home screen)
        Printt.defaultt('App state: paused - App is in background');
        AppLogController.instance.info('App paused - App is in background');
        _runCallbacks(_onAppPausedCallbacks);
        break;
      case AppLifecycleState.resumed:
        // App is resumed back
        Printt.defaultt('App state: resumed - App is in foreground');
        AppLogController.instance.info('App resumed - App is in foreground');
        _runCallbacks(_onAppResumedCallbacks);
        break;
      case AppLifecycleState.inactive:
        // App inactive (may be in transition)
        Printt.defaultt('App state: inactive - App is inactive');
        AppLogController.instance.debug('App inactive - App is inactive');
        _runCallbacks(_onAppInactiveCallbacks);
        break;
      case AppLifecycleState.hidden:
        // App is hidden (on some platforms)
        Printt.defaultt('App state: hidden - App is hidden');
        AppLogController.instance.debug('App hidden - App is hidden');
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

  /// Register callback when app is terminated
  void addOnAppExitCallback(VoidCallback callback) {
    _onAppExitCallbacks.add(callback);
  }

  /// Remove callback when app is terminated
  void removeOnAppExitCallback(VoidCallback callback) {
    _onAppExitCallbacks.remove(callback);
  }

  /// Register callback when app is paused
  void addOnAppPausedCallback(VoidCallback callback) {
    _onAppPausedCallbacks.add(callback);
  }

  /// Remove callback when app is paused
  void removeOnAppPausedCallback(VoidCallback callback) {
    _onAppPausedCallbacks.remove(callback);
  }

  /// Register callback when app resumes
  void addOnAppResumedCallback(VoidCallback callback) {
    _onAppResumedCallbacks.add(callback);
  }

  /// Remove callback when app resumes
  void removeOnAppResumedCallback(VoidCallback callback) {
    _onAppResumedCallbacks.remove(callback);
  }

  /// Register callback when app is inactive
  void addOnAppInactiveCallback(VoidCallback callback) {
    _onAppInactiveCallbacks.add(callback);
  }

  /// Remove callback when app is inactive
  void removeOnAppInactiveCallback(VoidCallback callback) {
    _onAppInactiveCallbacks.remove(callback);
  }

  /// Perform basic cleanup when app shuts down
  void _performBasicCleanup() {
    try {
      // Cleanup GetIt instances if needed
      if (GetIt.instance.isRegistered()) {
        Printt.defaultt('Performing GetIt cleanup...');
        // Can add cleanup logic for GetIt instances here
      }

      // Add other cleanup logic here
      Printt.defaultt('Basic cleanup completed');
    } catch (e) {
      Printt.defaultt('Error during basic cleanup: $e');
    }
  }

  /// Register basic cleanup callbacks
  void registerBasicCleanup() {
    addOnAppExitCallback(_performBasicCleanup);
    addOnAppPausedCallback(() {
      Printt.defaultt('App paused - you might want to save data here');
    });
  }
}

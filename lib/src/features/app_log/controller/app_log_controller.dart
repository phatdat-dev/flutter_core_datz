import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../flutter_core_datz.dart';

/// Model for log entry
class AppLogEntry {
  final DateTime timestamp;
  final AppLogLevel level;
  final String message;
  final Map<String, dynamic>? data;

  AppLogEntry({
    required this.timestamp,
    required this.level,
    required this.message,
    this.data,
  });

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'level': level.name,
    'message': message,
    'data': data,
  };

  factory AppLogEntry.fromJson(Map<String, dynamic> json) => AppLogEntry(
    timestamp: DateTime.parse(json['timestamp']),
    level: AppLogLevel.fromString(json['level']),
    message: json['message'],
    data: json['data'],
  );

  @override
  String toString() {
    final timeStr = timestamp.toString().substring(11, 19); // HH:mm:ss
    return '[$timeStr] [${level.name}] $message${data != null ? ' - ${jsonEncode(data)}' : ''}';
  }
}

/// Service for managing app logs
class AppLogController {
  static AppLogController? _instance;
  static AppLogController get instance => _instance ??= AppLogController._();

  AppLogController._();

  static const String _logKey = 'app_logs';
  static const int _maxLogs = 1000; // Keep maximum 1000 logs

  final List<AppLogEntry> _logs = [];

  /// Initialize service and load logs from storage

  Future<void> init() async {
    await _loadLogsFromStorage();
    addLog(AppLogLevel.info, 'AppLogService initialized');
  }

  /// Add new log
  void addLog(AppLogLevel level, String message, [Map<String, dynamic>? data]) {
    final entry = AppLogEntry(
      timestamp: DateTime.now(),
      level: level,
      message: message,
      data: data,
    );

    _logs.add(entry);

    // Also log to console
    log('${entry.level.name}: ${entry.message}', name: 'AppLog');

    // Limit the number of logs
    if (_logs.length > _maxLogs) {
      _logs.removeRange(0, _logs.length - _maxLogs);
    }

    // Save to storage (async, does not block UI)
    _saveLogsToStorage();
  }

  /// Add debug log
  void debug(String message, [Map<String, dynamic>? data]) {
    addLog(AppLogLevel.debug, message, data);
  }

  /// Add info log
  void info(String message, [Map<String, dynamic>? data]) {
    addLog(AppLogLevel.info, message, data);
  }

  /// Add warning log
  void warn(String message, [Map<String, dynamic>? data]) {
    addLog(AppLogLevel.warn, message, data);
  }

  /// Add error log
  void error(String message, [Map<String, dynamic>? data]) {
    addLog(AppLogLevel.error, message, data);
  }

  /// Get list of logs
  List<AppLogEntry> get logs => List.unmodifiable(_logs);

  /// Get logs by level
  List<AppLogEntry> getLogsByLevel(AppLogLevel level) {
    return _logs.where((log) => log.level == level).toList();
  }

  /// Get logs within time range
  List<AppLogEntry> getLogsByTimeRange(DateTime start, DateTime end) {
    return _logs.where((log) => log.timestamp.isAfter(start) && log.timestamp.isBefore(end)).toList();
  }

  /// Clear all logs
  Future<void> clearLogs() async {
    _logs.clear();
    await _saveLogsToStorage();
    addLog(AppLogLevel.info, 'All logs cleared');
  }

  /// Export logs as string
  String exportLogsAsString() {
    return _logs.map((log) => log.toString()).join('\n');
  }

  /// Export logs as JSON
  String exportLogsAsJson() {
    return jsonEncode(_logs.map((log) => log.toJson()).toList());
  }

  /// Save logs to storage
  Future<void> _saveLogsToStorage() async {
    try {
      final storage = GetIt.instance<StorageService>();
      final jsonString = jsonEncode(_logs.map((log) => log.toJson()).toList());
      await storage.sharedPreferences!.setString(_logKey, jsonString);
    } catch (e) {
      log('Error saving logs to storage: $e', name: 'AppLog');
    }
  }

  /// Load logs from storage
  Future<void> _loadLogsFromStorage() async {
    try {
      final storage = GetIt.instance<StorageService>();
      final jsonString = storage.sharedPreferences!.getString(_logKey);

      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        _logs.clear();
        _logs.addAll(jsonList.map((json) => AppLogEntry.fromJson(json)));
      }
    } catch (e) {
      log('Error loading logs from storage: $e', name: 'AppLog');
    }
  }

  /// Get log statistics
  Map<AppLogLevel, int> getLogStats() {
    final stats = <AppLogLevel, int>{};
    for (final log in _logs) {
      stats[log.level] = (stats[log.level] ?? 0) + 1;
    }
    return stats;
  }

  /// Get latest logs
  List<AppLogEntry> getRecentLogs([int count = 50]) {
    final startIndex = _logs.length > count ? _logs.length - count : 0;
    return _logs.sublist(startIndex);
  }
}

enum AppLogLevel {
  all,
  debug,
  info,
  warn,
  error;

  factory AppLogLevel.fromString(String level) => AppLogLevel.values.byName(level);

  Color get color => switch (this) {
    all => Colors.black,
    debug => Colors.grey,
    info => Colors.blue,
    warn => Colors.orange,
    error => Colors.red,
  };

  IconData get icon => switch (this) {
    all => Icons.list,
    debug => Icons.bug_report,
    info => Icons.info,
    warn => Icons.warning,
    error => Icons.error,
  };
}

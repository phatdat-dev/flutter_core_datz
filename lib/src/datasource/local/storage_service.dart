import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  SharedPreferences? sharedPreferences;
  Isar? cacheDb;

  bool get hasInitialized => sharedPreferences != null && cacheDb != null;

  Future<void> init() async {
    await _initSharedPrefs();
    await _initCacheDb();
  }

  Future<void> _initSharedPrefs() async {
    sharedPreferences ??= await SharedPreferences.getInstance();
  }

  Future<void> _initCacheDb() async {
    // https://isar-community.dev/tutorials/quickstart.html
    if (kIsWeb) {
      // For web, make sure to initalize before
      await Isar.initialize();

      // Use sync methods
      cacheDb ??= Isar.open(
        schemas: [],
        directory: Isar.sqliteInMemory,
        engine: IsarEngine.sqlite,
      );
    } else {
      final dir = await getApplicationDocumentsDirectory();
      cacheDb ??= await Isar.openAsync(
        schemas: [],
        directory: dir.path,
      );
    }
  }
}

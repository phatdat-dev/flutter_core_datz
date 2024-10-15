import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  SharedPreferences? sharedPreferences;
  // Database? cacheDb;

  // bool get hasInitialized => sharedPreferences != null && cacheDb != null;
  bool get hasInitialized => sharedPreferences != null;

  Future<void> init() async {
    await _initSharedPrefs();
    await _initCacheDb();
  }

  Future<void> _initSharedPrefs() async {
    sharedPreferences ??= await SharedPreferences.getInstance();
  }

  Future<void> _initCacheDb() async {
    // final dbPath = await getDatabasesPath();
    // cacheDb = await openDatabase('$dbPath/cache.db');
  }
}

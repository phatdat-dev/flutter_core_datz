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
    cacheDb ??= await Isar.openAsync(
      schemas: [],
      directory: (await getApplicationCacheDirectory()).path,
    );
  }
}

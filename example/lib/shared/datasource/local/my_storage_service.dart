import 'dart:convert';

import 'package:flutter_core_datz/flutter_core_datz.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

class MyStorageService extends StorageService {
  Database? cacheDb;

  @override
  bool get hasInitialized => sharedPreferences != null && cacheDb != null;

  Future<String> get pathCacheDb async => "${await getDatabasesPath()}/cache.db";

  @override
  Future<void> initCacheDb() async {
    final path = await pathCacheDb;
    cacheDb = await openDatabase('$path/cache.db');
  }
}

// Supported SQLite types
enum SQLiteType {
  integer,
  real,
  text,
  blob,
  // new type
  boolean,
  datetime,
  json,
}

mixin BaseTable {
  String get tableName => runtimeType.toString();
  String get primaryKey => "id";
  Map<String, SQLiteType> get columns;

  Database get db => (GetIt.instance<StorageService>() as MyStorageService).cacheDb!;

  Future<void> createTable() async {
    // check if table exists
    final tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='$tableName'");
    if (tables.isNotEmpty) return;
    final columns = this.columns.entries
        .map((e) {
          return switch (e.value) {
            SQLiteType.boolean => "${e.key} INTEGER",
            SQLiteType.datetime || SQLiteType.json => "${e.key} TEXT",
            _ => "${e.key} ${e.value.name}",
          };
        })
        .join(", ");
    await db.execute('CREATE TABLE IF NOT EXISTS $tableName ($columns)');
  }

  Future<void> insert([Map<String, dynamic>? data]) async {
    if (data == null) return;
    //
    final columns = data.keys.join(", ");
    final values =
        data.values.map((e) {
          if (e is bool) return "${e ? 1 : 0}";
          if (e is DateTime) return e.toIso8601String();
          if (e is Iterable || e is Map) return jsonEncode(e);
          return e.toString();
        }).toList();
    final query = 'INSERT INTO $tableName ($columns) VALUES (${values.map((e) => "?").join(", ")})';
    await db.rawInsert(query, values);
  }

  Future<void> update([Map<String, dynamic>? data]) async {
    if (data == null) return;
    //
    final values = Map<String, Object?>.fromEntries(
      data.keys.map((e) {
        if (data[e] is bool) return MapEntry(e, data[e] ? 1 : 0);
        if (data[e] is DateTime) return MapEntry(e, (data[e] as DateTime).toIso8601String());
        if (data[e] is Iterable || data[e] is Map) return MapEntry(e, jsonEncode(data[e]));
        return MapEntry(e, data[e]);
      }),
    );
    await db.update(tableName, values, where: "$primaryKey = ?", whereArgs: [data[primaryKey]]);
  }

  Future<void> delete([String? id]) async {
    if (id == null) return;
    //
    await db.delete(tableName, where: "$primaryKey = ?", whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> select({String? where, List<String>? columns}) async {
    final cols = columns != null ? columns.join(", ") : "*";
    final whereClause = where != null ? "WHERE $where" : "";
    final result = await db.rawQuery('SELECT $cols FROM $tableName $whereClause');
    // cast data boolean and datetime
    return result.map((e) {
      final data = Map<String, dynamic>.from(e);
      data.forEach((key, value) {
        // replace first char and last char == '
        if ((value is String) && (value.startsWith("'") && value.endsWith("'"))) {
          data[key] = value = value.substring(1, value.length - 1);
        }
        switch (this.columns[key]) {
          // case SQLiteType.boolean:
          //   data[key] = value == 1;
          //   break;
          // case SQLiteType.datetime:
          //   data[key] = DateTime.parse(value);
          //   break;
          case SQLiteType.json:
            if (value != null) data[key] = jsonDecode(value);
            break;
          default:
            break;
        }
      });
      return data;
    }).toList();
  }

  Future<bool> isExist([String? id]) async {
    if (id == null) return false;
    //
    final result = await select(where: "$primaryKey = '$id'");
    return result.isNotEmpty;
  }

  Future<void> insertOrUpdate([Map<String, dynamic>? data]) async {
    if (data == null) return;
    //
    final isExist = await this.isExist(data[primaryKey].toString());
    if (isExist) {
      await update(data);
    } else {
      await insert(data);
    }
  }
}

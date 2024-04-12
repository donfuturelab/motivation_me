import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../constant/database.dart';

Future<void> initializeDatabase() async {
  final String dbPath = join(await getDatabasesPath(), dbName);
  final bool dbExists = await databaseExists(dbPath);

  if (!dbExists) {
    await copyDatabaseFromAssets(assetesDbPath, dbName);
    print('Database copied from assets');
  } else {
    await checkAndUpdateDatabase();
  }
}

Future<void> checkAndUpdateDatabase() async {
  final box = GetStorage('dbVersion');
  final storedDbVersion = box.read('dbVersion') ?? 0;

  if (storedDbVersion < currentDbVersion) {
    final oldDbPath = join(await getDatabasesPath(), dbName);

    //copy new database from assets as temp database
    final String tempDbPath =
        await copyDatabaseFromAssets(assetesDbPath, tempDbName);

    //copy user content to temp database
    await copyUserContentToTempDb(oldDbPath, tempDbPath);

    //replace old database with temp database
    await replaceOldDatabase(tempDbPath, oldDbPath);

    //update database version in get_storage
    box.write('dbVersion', currentDbVersion);
    print('Database updated to version $currentDbVersion');
  } else {
    print('Database is up to date');
    return;
  }
}

Future<String> copyDatabaseFromAssets(
    String assetPath, String tempDbName) async {
  final String tempDbPath = join(await getDatabasesPath(), tempDbName);

  final ByteData data = await rootBundle.load(assetPath);
  final List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

  await File(tempDbPath).writeAsBytes(bytes, flush: true);

  return tempDbPath;
}

Future<void> copyUserContentToTempDb(
    String currentDbPath, String tempDbPath) async {
  Database currentDb = await openDatabase(currentDbPath);
  Database tempDb = await openDatabase(tempDbPath);
  try {
    for (String table in userTables) {
      await copyTableData(currentDb, tempDb, table);
    }
  } finally {
    currentDb.close();
    tempDb.close();
  }
}

Future<void> copyTableData(
    Database sourceDb, Database targetDb, String tableName) async {
  final List<Map<String, dynamic>> tableData = await sourceDb.query(tableName);
  for (final row in tableData) {
    await targetDb.insert(tableName, row,
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }
}

Future<void> replaceOldDatabase(String tempDbPath, String oldDbPath) async {
  await File(oldDbPath).delete();
  await File(tempDbPath).rename(oldDbPath);
}

import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


Future<dynamic> getCoverifyDatabase() async {
  var databasePath = await getDatabasesPath();
  String filePath  = join(databasePath, 'coverify.db');
  var db           = await openDatabase(filePath);

  return db;
}

Future<void> checkAndCreateDatabase() async {

  var databasePath = await getDatabasesPath();
  String filePath  = join(databasePath, 'coverify.db');
  bool dbExists    = await File(filePath).exists();

  if (dbExists) {
    return;
  }

  print('Creating database now');

  Database database = await openDatabase(filePath, version: 1,
    onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE RecentCalls (
            contactNumber TEXT PRIMARY KEY,
            name TEXT,
            helpfulCount INTEGER,
            unresponsiveCount INTEGER,
            invalidCount INTEGER,
            outOfStockCount INTEGER,
            calledTime TEXT,
            category TEXT)
      ''');
    }
  );

  await database.close();
}


Future<dynamic> fetchRecentCallsFromDatabase(Database db) async {

  var records = await db.query('RecentCalls');
}

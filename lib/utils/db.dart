import 'dart:io';

import 'package:coverify/models/contact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';


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
            _id INTEGER PRIMARY KEY AUTOINCREMENT, 
            contactNumber TEXT,
            name TEXT,
            helpfulCount INTEGER,
            unresponsiveCount INTEGER,
            notWorkingCount INTEGER,
            outOfStockCount INTEGER,
            calledTime TEXT,
            state TEXT,
            category TEXT)
      ''');
    }
  );

  await database.close();
}


Future<dynamic> fetchRecentCallsFromDatabase(Database db) async {

  List<Map> records = await db.rawQuery('SELECT * FROM RecentCalls ORDER BY _id DESC');
  return records;
}


Future<void> insertRecordToDatabase(Database db, ContactModel model, String filter) async {

  if (db == null) {
    db = await getCoverifyDatabase();
  }

  String contactNumber  = model.contactNumber;
  String name           = model.name;
  int helpfulCount      = model.counts[filter]['helpfulCount'];
  int unresponsiveCount = model.counts[filter]['unresponsiveCount'];
  int notWorkingCount   = model.counts[filter]['invalidCount'];
  int outOfStockCount   = model.counts[filter]['outOfStockCount'];
  String state          = model.lastState;
  String category       = filter;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  String calledTime     = dateFormat.format(DateTime.now());

  await db.transaction((txn) async {
    int id1 = await txn.rawInsert(
      '''INSERT into RecentCalls(contactNumber, name, helpfulCount, unresponsiveCount, notWorkingCount, outOfStockCount, calledTime, state, category) '''
      '''VALUES("$contactNumber", "$name", $helpfulCount, $unresponsiveCount, $notWorkingCount, $outOfStockCount, "$calledTime", "$state", "$category")'''
    );

    print('INSERT COMPLETE');
  });
}
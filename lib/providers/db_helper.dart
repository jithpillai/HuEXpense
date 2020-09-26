import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Database_Helper {
  static final _dbName = 'myDatabase.db';
  static final _dbVersion = 1;

  Database_Helper._privateConstructor();
  static final Database_Helper instance = Database_Helper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _intiateDatabase();
    return _database;
  }

  _intiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) {

  }
}

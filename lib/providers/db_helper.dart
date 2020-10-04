import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class Database_Helper {
  static final _dbName = 'myDatabase.db';
  static final _dbVersion = 1;
  static final _txTableName = 'allTransactions';
  static final _notesTableName = 'allNotes';
  static final _listTypeTable = 'listTypes';
  static final _listItems = 'listItems';
  static final _columnId = 'id';
  static final _parentId = 'parentId';
  static final _title = 'title';
  static final _name = 'name';
  static final _desc = 'desc';
  static final _status = 'status';
  static final _content = 'content';
  static final _amount = 'amount';
  static final _date = 'date';

  Database_Helper._privateConstructor();


  static final Database_Helper instance = Database_Helper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) {
      await _createTables(_database, _dbVersion);
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
      onCreate: _createTables,
    );
  }

  Future _createTables(Database db, int version) async {
    await db.execute(
      '''
        CREATE TABLE IF NOT EXISTS $_txTableName(
          $_columnId INTEGER PRIMARY KEY,
          $_title TEXT NOT NULL,
          $_amount REAL NOT NULL,
          $_date TEXT NOT NULL
        ) 
      '''
    );

    await db.execute(
      '''
        CREATE TABLE IF NOT EXISTS $_notesTableName(
          $_columnId INTEGER PRIMARY KEY,
          $_title TEXT NOT NULL,
          $_content TEXT NOT NULL
        ) 
      '''
    );

    await db.execute(
      '''
        CREATE TABLE IF NOT EXISTS $_listTypeTable(
          $_columnId TEXT PRIMARY KEY,
          $_name TEXT NOT NULL,
          $_desc TEXT
        ) 
      '''
    );

    await db.execute(
      '''
        CREATE TABLE IF NOT EXISTS $_listItems(
          $_columnId TEXT PRIMARY KEY,
          $_parentId TEXT,
          $_name TEXT NOT NULL,
          $_desc TEXT,
          $_status TEXT
        ) 
      '''
    );
  }

  //All Transaction Opertations
  /*   {
    id: '123',
    name: 'Shopping',
    amount: 256.00,
    date: 'DATE'
  } */
  Future insertTx (Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_txTableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAllTx () async {
    Database db = await instance.database;
    return await db.query(_txTableName, orderBy: "$_date DESC");
  }

  Future<int> updateTX(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[_columnId];
    return await db.update(_txTableName, row, where: '$_columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteTX(int id) async {
    Database db = await instance.database;
    return await db.delete(_txTableName, where: '$_columnId = ?', whereArgs: [id]);
  }

  //All Notes operations
  /* 
    {
      id: 1,
      title: 'Notes Title',
      content: 'Notes Content';
    }
   */
  Future insertNotes (Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_notesTableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAllNotes () async {
    Database db = await instance.database;
    return await db.query(_notesTableName);
  }

  Future<int> updateNotes(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[_columnId];
    return await db.update(_notesTableName, row, where: '$_columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteNotes(int id) async {
    Database db = await instance.database;
    return await db.delete(_notesTableName, where: '$_columnId = ?', whereArgs: [id]);
  }

  /* 
    {
      id: "movieList",
      name: "Movie List",
      desc: "List of fav movies"
    }
   */

  Future insertListTypes (Map<String, dynamic> row) async {
    print(row);
    Database db = await instance.database;
    return await db.insert(_listTypeTable, row);
  }

  Future<List<Map<String, dynamic>>> queryAllListTypes () async {
    Database db = await instance.database;
    return await db.query(_listTypeTable);
  }

  Future<int> updateListTypes(Map<String, dynamic> row) async {
    Database db = await instance.database;
    String id = row[_columnId];
    return await db.update(_listTypeTable, row, where: '$_columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteListTypes(String id) async {
    Database db = await instance.database;
    db.delete(_listItems, where: '$_parentId = ?', whereArgs: [id]);
    return await db.delete(_listTypeTable, where: '$_columnId = ?', whereArgs: [id]);
  }
  /* 
    {
      id: '13434'
      parentId: "movieList",
      name: "Petrol",
      desc: "For vehicle"
    }
   */

  Future insertListItems (Map<String, dynamic> row) async {
    print(row);
    Database db = await instance.database;
    return await db.insert(_listItems, row);
  }

  Future<List<Map<String, dynamic>>> queryListItems (String parentId) async {
    Database db = await instance.database;
    return await db.query(_listItems, where: '$_parentId = ?', whereArgs: [parentId]);
  }

  Future<int> updateListItems(Map<String, dynamic> row) async {
    Database db = await instance.database;
    String id = row[_columnId];
    return await db.update(_listItems, row, where: '$_columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteListItems(String id) async {
    Database db = await instance.database;
    return await db.delete(_listItems, where: '$_columnId = ?', whereArgs: [id]);
  }
}

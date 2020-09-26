import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/transaction.dart';

class Database_Helper {
  static final _dbName = 'myDatabase.db';
  static final _dbVersion = 1;
  static final _tableName = 'allTransactions';
  static final _columnId = 'id';
  static final _name = 'title';
  static final _amount = 'amount';
  static final _date = 'date';

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
    db.execute(
      '''
        CREATE TABLE $_tableName(
          $_columnId INTEGER PRIMARY KEY,
          $_name TEXT NOT NULL,
          $_amount REAL NOT NULL,
          $_date TEXT NOT NULL
        ) 
      '''
    );
  }
/*   {
    id: '123',
    name: 'Shopping',
    amount: 256.00,
    date: 'DATE'
  } */
  Future insertTx (Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAllTx () async {
    Database db = await instance.database;
    return await db.query(_tableName, orderBy: "$_date DESC");
  }

  Future<int> updateTX(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[_columnId];
    return await db.update(_tableName, row, where: '$_columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteTX(int id) async {
    Database db = await instance.database;
    return await db.delete(_tableName, where: '$_columnId = ?', whereArgs: [id]);
  }
}

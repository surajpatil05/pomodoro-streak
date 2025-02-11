import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbCreation {
  static final DbCreation instance = DbCreation._init();
  static Database? _database;

  DbCreation._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('timer_data.db');
    return _database!;
  }

  Future<Database> _initDB(String dbName) async {
    final dbPath = await getDatabasesPath();
    final fullPath = join(dbPath, dbName);
    debugPrint('Database path: $fullPath');
    return await openDatabase(fullPath, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    debugPrint('Creating database tables...');
    await db.execute('''
      CREATE TABLE focus_mode (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cycle_count INTEGER,
        time_spent INTEGER,
        timestamp TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE break_mode (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cycle_count INTEGER,
        time_spent INTEGER,
        timestamp TEXT
      )
    ''');

    debugPrint('Tables created successfully.');
  }
}

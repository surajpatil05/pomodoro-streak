import 'package:flutter/material.dart';

import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // return the database if it already exists otherwise initialize it
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('timer_data.db');
    return _database!;
  }

  // initialize the database and create tables if they don't exist
  Future<Database> _initDB(String path) async {
    final dbPath = await getDatabasesPath();
    final fullPath = join(dbPath, path);
    debugPrint('database path $fullPath'); // log database path
    return await openDatabase(fullPath, version: 1, onCreate: _onCreate);
  }

  // create tables if they don't exist
  Future _onCreate(Database db, int version) async {
    debugPrint('database tables created Successfully');
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
    debugPrint('Tables created Successfully');
  }

  // query the table and return query result
  Future<List<Map<String, dynamic>>> rawQuery(String query) async {
    final db = await database;
    return await db.rawQuery(query);
  }

  // Insert data in Focuse Mode table
  Future<int> insertFocusCycleCountAndTimeSpent(
      int cycleCount, int timeSpent, DateTime dateTime) async {
    final db = await instance.database;
    debugPrint(
        'Inserting into focus_mode: $cycleCount, $timeSpent, ${dateTime.toIso8601String()}');
    return await db.insert(
      'focus_mode',
      {
        'cycle_count': cycleCount,
        'time_spent': timeSpent,
        'timestamp': dateTime.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace, // Prevent duplicates
    );
  }

  // Insert data in Break Mode table
  Future<int> insertBreakCycleCountAndTimeSpent(
      int cycleCount, int timeSpent, DateTime dateTime) async {
    final db = await instance.database;

    debugPrint(
        'Inserting into break_mode: $cycleCount, $timeSpent, ${dateTime.toIso8601String()}');
    return await db.insert(
      'break_mode',
      {
        'cycle_count': cycleCount,
        'time_spent': timeSpent,
        'timestamp': dateTime.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace, // Prevent duplicates
    );
  }

  // Get and Display (Cycle Count and Time Spent) for the selected timeline from focus_mode table to display in Focus Mode Screen
  Future<List<Map<String, dynamic>>> fetchFocusCycleCountAndTimeSpentByRange(
      String timeline) async {
    final db = await instance.database;
    // Adjust query based on the timeline
    String query;
    if (timeline == 'Today') {
      query =
          "SELECT * FROM focus_mode WHERE date(timestamp, 'localtime') = date('now', 'localtime')";
    } else if (timeline == 'This Week') {
      query =
          // "SELECT * FROM focus_mode WHERE strftime('%Y-%W', timestamp, 'localtime') = strftime('%Y-%W', 'now', 'localtime')";
          "SELECT * FROM focus_mode WHERE date(timestamp, 'localtime') BETWEEN date('now', 'weekday 0', '-6 days') AND date('now', 'weekday 0')";
    } else if (timeline == 'This Month') {
      query =
          "SELECT * FROM focus_mode WHERE strftime('%Y-%m', timestamp, 'localtime') = strftime('%Y-%m', 'now', 'localtime')";
    } else {
      query =
          "SELECT * FROM focus_mode WHERE strftime('%Y', timestamp, 'localtime') = strftime('%Y', 'now', 'localtime')"; // Total time, all records
    }
    return await db.rawQuery(query);
  }

  // Get and Display (Cycle Count and Time Spent) for the selected timeline from break_mode table to display in Break Mode Screen
  Future<List<Map<String, dynamic>>> fetchBreakCycleCountAndTimeSpentByRange(
      String timeline) async {
    final db = await instance.database;
    // Adjust query based on the timeline
    String query;
    if (timeline == 'Today') {
      query =
          "SELECT * FROM break_mode WHERE date(timestamp, 'localtime') = date('now', 'localtime')";
    } else if (timeline == 'This Week') {
      query =
          // "SELECT * FROM break_mode WHERE strftime('%W', timestamp, 'localtime') = strftime('%W', 'now', 'localtime')";
          "SELECT * FROM break_mode WHERE date(timestamp, 'localtime') BETWEEN date('now', 'weekday 0', '-6 days') AND date('now', 'weekday 0')";
    } else if (timeline == 'This Month') {
      query =
          "SELECT * FROM break_mode WHERE strftime('%Y-%m', timestamp, 'localtime') = strftime('%Y-%m', 'now', 'localtime')";
    } else {
      query =
          "SELECT * FROM break_mode WHERE strftime('%Y', timestamp, 'localtime') = strftime('%Y', 'now', 'localtime')"; // Total time, all records
    }
    return await db.rawQuery(query);
  }

  // function to return all the stored records in the database in debug console
  Future<List<Map<String, dynamic>>> fetchAllFocusModeData() async {
    final db = await instance.database;

    final result = db.rawQuery("SELECT * FROM focus_mode");

    return result;
  }

  // function to return all the stored records in the database in debug console
  Future<List<Map<String, dynamic>>> fetchAllBreakModeData() async {
    final db = await instance.database;

    final result = db.rawQuery("SELECT * FROM break_mode");

    return result;
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
        timeline TEXT, 
        cycle_count INTEGER,
        time_spent INTEGER,
        timestamp TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE break_mode (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timeline TEXT,
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

  // Helper Method to Format the date and time to yyyy-MM-dd HH:mm format before displaying in the ui
  String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  // Insert data in Focuse Mode table
  Future<int> insertFocusCycleCountAndTimeSpent(
      String timeline, int cycleCount, int timeSpent, DateTime dateTime) async {
    final db = await instance.database;
    String formattedTimeStamp = formatDateTime(dateTime);
    debugPrint(
        'Inserting into focus_mode: $timeline, $cycleCount, $timeSpent, $formattedTimeStamp');
    return await db.insert('focus_mode', {
      'timeline': timeline,
      'cycle_count': cycleCount,
      'time_spent': timeSpent,
      'timestamp': formattedTimeStamp,
    });
  }

  // Insert data in Break Mode table
  Future<int> insertBreakCycleCountAndTimeSpent(
      String timeline, int cycleCount, int timeSpent, DateTime dateTime) async {
    final db = await instance.database;
    String formattedTimeStamp = formatDateTime(dateTime);
    debugPrint(
        'Inserting into break_mode: $timeline, $cycleCount, $timeSpent, $formattedTimeStamp');
    return await db.insert('break_mode', {
      'timeline': timeline,
      'cycle_count': cycleCount,
      'time_spent': timeSpent,
      'timestamp': formattedTimeStamp,
    });
  }

  // Get and Display (Cycle Count and Time Spent) for the selected timeline from focus_mode table to display in Focus Mode Screen
  Future<List<Map<String, dynamic>>> fetchFocusCycleCountAndTimeSpentByRange(
      String timeline) async {
    final db = await instance.database;
    // Adjust query based on the timeline
    String query;
    if (timeline == 'today') {
      query = "SELECT * FROM focus_mode WHERE date(timestamp) = date('now')";
    } else if (timeline == 'this_week') {
      query =
          "SELECT * FROM focus_mode WHERE strftime('%W', timestamp) = strftime('%W', 'now')";
    } else if (timeline == 'this_month') {
      query =
          "SELECT * FROM focus_mode WHERE strftime('%m', timestamp) = strftime('%m', 'now')";
    } else {
      query = "SELECT * FROM focus_mode"; // Total time, all records
    }
    return await db.rawQuery(query);
  }

  // Get and Display (Cycle Count and Time Spent) for the selected timeline from break_mode table to display in Break Mode Screen
  Future<List<Map<String, dynamic>>> fetchBreakCycleCountAndTimeSpentByRange(
      String timeline) async {
    final db = await instance.database;
    // Adjust query based on the timeline
    String query;
    if (timeline == 'today') {
      query = "SELECT * FROM break_mode WHERE date(timestamp) = date('now')";
    } else if (timeline == 'this_week') {
      query =
          "SELECT * FROM break_mode WHERE strftime('%W', timestamp) = strftime('%W', 'now')";
    } else if (timeline == 'this_month') {
      query =
          "SELECT * FROM break_mode WHERE strftime('%m', timestamp) = strftime('%m', 'now')";
    } else {
      query = "SELECT * FROM break_mode"; // Total time, all records
    }
    return await db.rawQuery(query);
  }
}

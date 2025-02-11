import 'package:flutter/material.dart';

import 'package:sqflite/sqflite.dart';

import 'db_creation.dart';

class Repository {
  static final Repository instance = Repository._init();

  Repository._init();

  Future<Database> get _database async => await DbCreation.instance.database;

  Future<List<Map<String, dynamic>>> rawQuery(String query) async {
    final db = await _database;
    return await db.rawQuery(query);
  }

  Future<int> insertFocusCycleCountAndTimeSpent(
      int cycleCount, int timeSpent, DateTime dateTime) async {
    final db = await _database;
    debugPrint(
        'Inserting into focus_mode table: $cycleCount, $timeSpent, ${dateTime.toIso8601String()}');
    return await db.insert(
      'focus_mode',
      {
        'cycle_count': cycleCount,
        'time_spent': timeSpent,
        'timestamp': dateTime.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertBreakCycleCountAndTimeSpent(
      int cycleCount, int timeSpent, DateTime dateTime) async {
    final db = await _database;
    debugPrint(
        'Inserting into break_mode table: $cycleCount, $timeSpent, ${dateTime.toIso8601String()}');
    return await db.insert(
      'break_mode',
      {
        'cycle_count': cycleCount,
        'time_spent': timeSpent,
        'timestamp': dateTime.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> fetchFocusCycleCountAndTimeSpentByRange(
      String timeline) async {
    final db = await _database;
    String query;

    if (timeline == 'Today') {
      query =
          "SELECT * FROM focus_mode WHERE date(datetime(timestamp, 'utc'), 'localtime') = date('now', 'localtime')";
    } else if (timeline == 'This Week') {
      query =
          "SELECT * FROM focus_mode WHERE date(datetime(timestamp, 'utc'), 'localtime') BETWEEN date('now', 'weekday 1', '-7 days', 'localtime') AND date('now', 'weekday 0', 'localtime')";
    } else if (timeline == 'This Month') {
      query =
          "SELECT * FROM focus_mode WHERE strftime('%Y-%m', datetime(timestamp, 'utc'), 'localtime') = strftime('%Y-%m', 'now', 'localtime')";
    } else {
      query =
          "SELECT * FROM focus_mode WHERE strftime('%Y', datetime(timestamp, 'utc'), 'localtime') = strftime('%Y', 'now', 'localtime')";
    }

    return await db.rawQuery(query);
  }

  Future<List<Map<String, dynamic>>> fetchBreakCycleCountAndTimeSpentByRange(
      String timeline) async {
    final db = await _database;
    String query;

    if (timeline == 'Today') {
      query =
          "SELECT * FROM break_mode WHERE date(datetime(timestamp, 'utc'), 'localtime') = date('now', 'localtime')";
    } else if (timeline == 'This Week') {
      query =
          "SELECT * FROM break_mode WHERE date(datetime(timestamp, 'utc'), 'localtime') BETWEEN date('now', 'weekday 1', '-7 days', 'localtime') AND date('now', 'weekday 0', 'localtime')";
    } else if (timeline == 'This Month') {
      query =
          "SELECT * FROM break_mode WHERE strftime('%Y-%m', datetime(timestamp, 'utc'), 'localtime') = strftime('%Y-%m', 'now', 'localtime')";
    } else {
      query =
          "SELECT * FROM break_mode WHERE strftime('%Y', datetime(timestamp, 'utc'), 'localtime') = strftime('%Y', 'now', 'localtime')";
    }

    return await db.rawQuery(query);
  }

  // to see data from database in debug console
  Future<List<Map<String, dynamic>>> fetchAllFocusModeData() async {
    final db = await _database;
    return await db.rawQuery("SELECT * FROM focus_mode");
  }

  // to see data from database in debug console
  Future<List<Map<String, dynamic>>> fetchAllBreakModeData() async {
    final db = await _database;
    return await db.rawQuery("SELECT * FROM break_mode");
  }
}

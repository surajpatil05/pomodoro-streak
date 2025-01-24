import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_streak/data/database_helper.dart';

import 'package:pomodoro_streak/screens/main_screen.dart';

// import 'package:sqflite/sqflite.dart';

ThemeData themeData = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.black,
    surface: Colors.black,
    onSurface: Colors.white,
    primary: Colors.white,
    onPrimary: Colors.white,
    secondary: Colors.white,
    onSecondary: Colors.white,
    shadow: Colors.white,
    brightness: Brightness.dark,
  ),
  useMaterial3: true,
);

// Future<void> deleteDatabaseFile() async {
//   final dbPath = await getDatabasesPath();
//   final path = '$dbPath/timer_data.db';

//   // Delete the database
//   await deleteDatabase(path);
//   print('Database deleted successfully');
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  List<Map<String, dynamic>> focusModeData =
      await DatabaseHelper.instance.fetchAllFocusModeData();

  List<Map<String, dynamic>> breakModeData =
      await DatabaseHelper.instance.fetchAllBreakModeData();

  debugPrint(focusModeData.toString());
  debugPrint(breakModeData.toString());

  // Delete the database (for testing or development purposes)
  // await deleteDatabaseFile();

  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro App',
      theme: themeData,
      debugShowCheckedModeBanner: false,
      home: MainScreen(), // pomodoro application screen
    );
  }
}

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

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
//   final path = '$dbPath/your_database_name.db';

//   // Delete the database
//   await deleteDatabase(path);
//   print('Database deleted successfully');
// }

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();

  // // Delete the database (for testing or development purposes)
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

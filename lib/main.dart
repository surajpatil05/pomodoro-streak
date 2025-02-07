import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pomodoro_streak/providers/update_notifier.dart';

import 'package:pomodoro_streak/screens/main_screen.dart';

import 'package:pomodoro_streak/data/database_helper.dart';

import 'package:pomodoro_streak/services/notification_service.dart';

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
//   debugPrint('Database deleted successfully');
// }

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize the notification service
  NotificationService().initNotification();

  // fetch all focus_mode table data
  List<Map<String, dynamic>> focusModeData =
      await DatabaseHelper.instance.fetchAllFocusModeData();

  // fetch all break_mode table data
  List<Map<String, dynamic>> breakModeData =
      await DatabaseHelper.instance.fetchAllBreakModeData();

  // print all focus_mode table data in debug console
  debugPrint(focusModeData.toString());
  // print all break_mode table data in debug console
  debugPrint(breakModeData.toString());

  // Delete the database (for testing or development purposes)
  // await deleteDatabaseFile();

  // all debugPrint are ignored in production build
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();

    // Initialize the splash screen before app starts
    initSplashScreen();

    // Automatically check for updates
    Future.microtask(() {
      ref.read(updateNotifierProvider.notifier).checkForUpdate();
    });
  }

  // Initialize the splash screen in app starting and remove after 3 seconds duration
  void initSplashScreen() async {
    debugPrint('pausing splash screen ...');
    await Future.delayed(Duration(seconds: 1));
    debugPrint('unpausing splash screen ...');
    FlutterNativeSplash.remove();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(411, 891),
      minTextAdapt: true, // Allow text to scale down
      splitScreenMode: true, // Support split-screen mode
      child: MaterialApp(
        title: 'Pomodoro App',
        theme: themeData,
        debugShowCheckedModeBanner: false,
        home: MainScreen(), // pomodoro application screen
      ),
    );
  }
}

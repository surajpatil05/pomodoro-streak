import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pomodoro_streak/data/repositories/timer_repository.dart';

import 'package:pomodoro_streak/viewmodels/app_update_viewmodel.dart';

import 'package:pomodoro_streak/views/home_view.dart';

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

  // fetch all focus_mode table data
  List<Map<String, dynamic>> focusModeData =
      await TimerRepository.instance.fetchAllFocusModeData();

  // fetch all break_mode table data
  List<Map<String, dynamic>> breakModeData =
      await TimerRepository.instance.fetchAllBreakModeData();

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

    // Initialize the notification service
    NotificationService().initNotification(context);
  }

  // Initialize the splash screen in app starting and remove after 3 seconds duration
  void initSplashScreen() async {
    debugPrint('pausing splash screen ...');
    await Future.delayed(Duration(seconds: 1));
    debugPrint('unpausing splash screen ...');
    FlutterNativeSplash.remove();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForUpdates(); // Pass context and ref
    });
  }

  // Check for app update
  Future<void> _checkForUpdates() async {
    final appUpdateViewModel =
        ref.read(appUpdateProvider.notifier); // Get ViewModel

    appUpdateViewModel.checkForUpdate((updateInfo) {
      if (mounted && updateInfo != null) {
        // Show dialog when new update available
        showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: Text('Update Available'),
                content: Text('A new version of the app is available. '
                    'Would you like to update now?'),
                actions: [
                  TextButton(
                    onPressed: () async {
                      Navigator.of(dialogContext).pop();
                      ref
                          .read(appUpdateProvider.notifier)
                          .performUpdate(context, updateInfo);
                    },
                    child: Text('Update Now'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: Text('Later'),
                  )
                ],
              );
            });
      }
    });
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
        home: HomeView(), // pomodoro application screen
      ),
    );
  }
}

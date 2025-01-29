# Keep Flutter classes and methods
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep your app's main activity class
-keep class com.example.pomodoro_streak.MainActivity { *; }

# Keep other specific classes or methods you need
# Example: Keep a class with annotations
-keep @interface com.example.pomodoro_streak.annotations.**

# Example: Keep a class from a specific library
-keep class com.example.someLibrary.** { *; }

# Keep SQLite classes for sqflite
-keep class android.database.sqlite.** { *; }
-keep class io.flutter.plugins.sqflite.** { *; }

# Keep classes related to flutter_local_notifications
-keep class io.flutter.plugins.flutterlocalnotifications.** { *; }
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# Keep permission handler classes
-keep class com.permissionhandler.** { *; }
-keep class io.flutter.plugins.permissionhandler.** { *; }


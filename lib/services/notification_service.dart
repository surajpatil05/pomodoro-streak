import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  // flutter local notification plugin instance
  FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // initializing the notification service
  Future<void> initNotification(BuildContext context) async {
    AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/logo');

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {},
    );

    // Request notification permissions
    await requestNotificationPermission();
  }

  // requesting notification permission if denied before
  Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      // request permission
      await Permission.notification.request();
    }
  }

  // Notifications Detail Setup
  notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'Timer End Channel',
        channelDescription: 'Notifications for when a timer has finished.',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
  }

  // show notification
  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
      id,
      title,
      body,
      await notificationDetails(),
    );
  }

  // Notifications Details Setup for live timer notifying
  Future<void> showOngoingTimerNotification(
      {int id = 1,
      required String? title,
      String? payload,
      required int secondsRemaining}) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      'timer_channel',
      'Timer Running Channel',
      description:
          'Ongoing notifications showing the remaining time on a timer.',
      importance: Importance.low,
    );

    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await notificationsPlugin.show(
      id,
      title,
      _formatDuration(Duration(seconds: secondsRemaining)),
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.low,
          priority: Priority.low,
          ongoing: true,
          autoCancel: false,
          showWhen: true,
          styleInformation: DefaultStyleInformation(true, true),
        ),
      ),
      payload: payload,
    );
  }

  // format time duration for the notification
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes: $twoDigitSeconds";
  }

  Future<void> cancelNotification() async {
    await notificationsPlugin.cancel(
        1); // 0 is used because in .show method i assigned 0 to id field
  }
}

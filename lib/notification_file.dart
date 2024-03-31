
import 'package:doc_patient/homePage/notification.dart';
import 'package:doc_patient/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  //Singleton pattern
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  //instance of FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
  // AndroidFlutterLocalNotificationsPlugin>().requestNotificationsPermission();

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future<void> init() async {
    tz.initializeTimeZones();
    //Initialization Settings for Android
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('splash');

    //InitializationSettings for initializing settings for both platforms (Android & iOS)
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: selectNotification);
  }

  AndroidNotificationDetails get _androidNotificationDetails =>
      AndroidNotificationDetails(
        'channel ID',
        'channel name',
        playSound: true,
        priority: Priority.high,
        importance: Importance.high,
      );

  NotificationDetails get platformChannelSpecifics =>
      NotificationDetails(android: _androidNotificationDetails);

  Future<void> showNotifications(id, data) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      data['sender'],
      data['message'],
      platformChannelSpecifics,
      payload: 'Notification Payload',
    );
  }

  tz.TZDateTime _convertTime(int hour, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes)
            .add(const Duration(hours: 18));
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }

    return scheduleDate;
  }

  Future<void> scheduleNotifications(id, hour, minutes, days, body) async {
    for (int i = 0; i < days; i++) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id + i, // ensure each notification has a unique id
        'Reminder',
        body,
        _convertTime(hour, minutes).add(Duration(days: i)),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'your channel id',
            'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  Future<void> scheduleAppointment(id, hour, minutes, days, body) async {
    DateTime dateTime = DateTime.parse(days);

    tz.TZDateTime scheduledDate = tz.TZDateTime.from(dateTime, tz.local);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id, // ensure each notification has a unique id
      'Reminder',
      body,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}

void selectNotification(NotificationResponse response) async {
  String payload = response.payload!;

  await MyApp.navigatorKey.currentState!.push(
    MaterialPageRoute(builder: (context) => NotificationPage()),
  );
}

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'dart:math';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationController {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  final storage = GetStorage();
  Random random = new Random();

  void InitializeNotification() async {
    InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) async {
      await flutterLocalNotificationsPlugin.cancelAll();
      scheduleNotification();
    });
    tz.initializeTimeZones();
  }

  void scheduleNotification() async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    if (await storage.read('favorite') != null) {
      print(tz.TZDateTime.now(tz.local)); //selisih 7 jam
      List<dynamic> listFavorite = jsonDecode(storage.read('favorite'));
      // print(listFavorite.length);
      var body = listFavorite[random.nextInt(listFavorite.length)];
      // print(body["nama"]);

      // await flutterLocalNotificationsPlugin.periodicallyShow(
      //     0,
      //     body["nama"],
      //     'Recommendation Restaurant For You',
      //     RepeatInterval.everyMinute,
      //     platformChannelSpecifics);

      await flutterLocalNotificationsPlugin.zonedSchedule(
          0,
          body["nama"],
          'Recommendation Restaurant For You',
          scheduleTime(Time(4, 0, 0)), //-7 jika sesuai diindonesia wib
          // DateTime.now().add(Duration(seconds: 5)),
          platformChannelSpecifics,
          // Type of time interpretation
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true,
          matchDateTimeComponents: DateTimeComponents
              .time //To show notification even when the app is closed
          );
    }
  }

  static tz.TZDateTime scheduleTime(Time time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
        now.day, time.hour, time.minute, time.second);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  void stopNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

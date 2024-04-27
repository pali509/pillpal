import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pillpal/utils/user.dart';
import 'package:timezone/timezone.dart';
import 'package:uuid/uuid.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

import 'db_connections.dart';


class alarms_class {

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<bool?> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Initialize native android notification
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid
    );
    return await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
            if (notificationResponse.actionId == 'Tomar') {
              debugPrint("PRINGAITO1");
              // do something
            } else if (notificationResponse.actionId == 'Ignorar') {
              debugPrint("PRINGAITO1");
              // do something else
            }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }
  @pragma('vm:entry-point')
  static void notificationTapBackground(NotificationResponse notificationResponse) {

    if (notificationResponse.actionId == 'Tomar') {
      debugPrint("PRINGAITO2");
      // do something
    } else if (notificationResponse.actionId == 'Ignorar') {
      debugPrint("PRINGAITO2");
      // do something else
    }
  }

  Future<void> una_vez(int id, DateTime diaDeInicio, String hora, String name, int num) async {
    int h = int.parse(hora.split(":")[0]);
    int m = int.parse(hora.split(":")[1].split(" ")[0]);
    if(hora.split(":")[1].split(" ")[1] == "PM") h = h + 12;
    String title = 'Tome $num unidades de $name.';
    // Convertir la hora a un objeto TZDateTime
    Duration offsetTime = DateTime.now().timeZoneOffset;
    tz.initializeTimeZones();
    tz.TZDateTime zonedTime = tz.TZDateTime.local(DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        DateTime.now().hour,
        DateTime.now().minute).subtract(offsetTime);
    PermissionStatus status = await Permission.notification.status;
    if (!status.isGranted) {
      // The permission is not granted, request it.
      status = await Permission.notification.request();
    }

    final alarmTime = TZDateTime.from(DateTime(diaDeInicio.year, diaDeInicio.month, diaDeInicio.day, h, m), zonedTime.location);

    AndroidNotificationDetails and = AndroidNotificationDetails(
      'alarm_clock_channel',
      'Alarm Clock Channel',
      channelDescription: 'Alarm Clock Notification',
      subText: title,
      //silent: true,
      color: Colors.amber,
      colorized: true,
      ticker: title,
      playSound: true,
      priority: Priority.high,
      importance: Importance.high,
      actions: [
        AndroidNotificationAction('Tomar', 'Tomar', showsUserInterface: true, cancelNotification: false),
        AndroidNotificationAction('Ignorar', 'Ignorar', showsUserInterface: true, cancelNotification: false)
      ],
    );
    NotificationDetails nd = NotificationDetails(android: and);
    // Programar la alarma
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id, title, title, alarmTime,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: title,
      nd,
    );
    _checkPendingNotificationRequests();

   //await flutterLocalNotificationsPlugin.onActionSelected.listen((String selectedNotificationId, String action) {
   //  if (selectedNotificationId == 'alarm_clock_channel') {
   //    switch (action) {
   //      case 'Tomar':
   //      // Realizar la acción al presionar "Tomar"
   //        print('Botón "Tomar" presionado');
   //        break;
   //      case 'Ignorar':
   //      // Realizar la acción al presionar "Ignorar"
   //        print('Botón "Ignorar" presionado');
   //        break;
   //    }
   //  }
   //});
  }

  void onTapLocalNotification(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    debugPrint(payload);
    // this is where my navigation happens

  }

  Future<void> deleteAlarm(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> _checkPendingNotificationRequests() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
    await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    print('${pendingNotificationRequests.length} pending notification ');

    for (PendingNotificationRequest pendingNotificationRequest
    in pendingNotificationRequests) {
      print(pendingNotificationRequest.id.toString() +
          " " +
          (pendingNotificationRequest.payload ?? ""));
    }
    print('NOW ' + tz.TZDateTime.now(tz.local).toString());
  }
}





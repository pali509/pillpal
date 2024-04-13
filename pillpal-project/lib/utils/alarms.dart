import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pillpal/utils/user.dart';
import 'package:timezone/timezone.dart';
import 'package:uuid/uuid.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';


import 'db_connections.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
  }

  void diarias(DateTime diaDeInicio,  String hora, String name, int num) async {
    var uuid = Uuid();
    // Convertir la hora a un objeto TZDateTime
    final alarmTime = TZDateTime.from(
      DateTime(
        diaDeInicio.year,
        diaDeInicio.month,
        diaDeInicio.day/*,
        hora.hour,
        hora.minute,*/
      ),
      local,
    );

    // Inicializar las notificaciones locales
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('repeating_daily', 'Repertir diaria',
        importance: Importance.max,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound('alarm')
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

   //Falta programar dia de inicio
    flutterLocalNotificationsPlugin.periodicallyShow(
      int.parse(uuid.v4()),
      name.toUpperCase(),
      'Tome $num unidades de $name.',
      RepeatInterval.daily,
      platformChannelSpecifics,
    );
  }

  Future<void> una_vez(int id, DateTime diaDeInicio,  String hora, String name, int num) async {
    String title = 'Tome $num unidades de $name.';
    // Convertir la hora a un objeto TZDateTime
    Duration offsetTime= DateTime.now().timeZoneOffset;
    tz.initializeTimeZones();
    tz.TZDateTime zonedTime = tz.TZDateTime.local(DateTime.now().year,DateTime.now().month,
        DateTime.now().day,DateTime.now().hour,DateTime.now().minute).subtract(offsetTime);
    PermissionStatus status = await Permission.notification.status;
        if (!status.isGranted) {
          debugPrint("Te jodes");
          // The permission is not granted, request it.
          status = await Permission.notification.request();
          if (!status.isGranted) {
            debugPrint("Te jodes");
            // The permission is not granted, request it.
          }
        }
        else {
          debugPrint("Vivan los chinos");
        }
    final alarmTime = TZDateTime.from(
      DateTime(
          diaDeInicio.year,
          diaDeInicio.month,
          diaDeInicio.day,
        int.parse(hora.substring(0, 2)),
        int.parse(hora.substring(3, 5)),
      ),
      zonedTime.location,
    );
    int h = int.parse(hora.substring(0, 2));
    int m = int.parse(hora.substring(3, 5));
    debugPrint(m.toString());

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('repeating_daily', 'Repertir diaria',
        importance: Importance.max,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound('alarm')
    );

    // Programar la alarma
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        title,
        alarmTime,
        //platformChannelSpecifics,
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: title,
        NotificationDetails(
          android: AndroidNotificationDetails(
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
            actions: <AndroidNotificationAction>[
              const AndroidNotificationAction(
                'Tomar',
                'Tomar',
                titleColor: Colors.lightGreen,
              ),
              const AndroidNotificationAction(
                'Ignorar',
                'Ignorar',
                titleColor: Colors.redAccent,
                showsUserInterface: true,
                // By default, Android plugin will dismiss the notification when the
                // user tapped on a action (this mimics the behavior on iOS).
                cancelNotification: false,
              ),
            ],

          ),
        ),
    );
  }

  @pragma('vm:entry-point')
  void notificationTapBackground(NotificationResponse notificationResponse) {
    //2 casos, si ya hay registro y si no hay registro
      if (notificationResponse.actionId == 'Tomar') {
        insert_statistics(DateTime.now(), user_id!, 1, 1, "summary");
      }
      else if (notificationResponse.actionId == 'Ignorar') {
        insert_statistics(DateTime.now(), user_id!, 0, 1, "summary");
      }
  }

  Future<void> deleteAlarm(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
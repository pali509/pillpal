import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pillpal/utils/user.dart';
import 'package:timezone/timezone.dart';
import 'package:uuid/uuid.dart';

import 'db_connections.dart';

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
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('repeating_daily', 'Repertir diaria',
        importance: Importance.max,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound('alarm')
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);


    // Programar la alarma
    /*await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Alarma diaria',
        '¡Es hora de levantarse!',
        alarmTime,
        platformChannelSpecifics,
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true
    );*/
   //Falta programar dia de inicio
    flutterLocalNotificationsPlugin.periodicallyShow(
      int.parse(uuid.v4()),
      name.toUpperCase(),
      'Tome $num unidades de $name.',
      RepeatInterval.daily,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
    );
  }

  Future<int> una_vez(DateTime diaDeInicio,  String hora, String name, int num) async {
    String title = 'Tome $num unidades de $name.';
    var uuid = Uuid();
    // Convertir la hora a un objeto TZDateTime
    final alarmTime = TZDateTime.from(
      DateTime(
          diaDeInicio.year,
          diaDeInicio.month,
          diaDeInicio.day,
        int.parse(hora.substring(0, 2)),
        int.parse(hora.substring(3, 5)),
      ),
      local,
    );

    // Inicializar las notificaciones locales
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('repeating_daily', 'Repertir diaria',
        importance: Importance.max,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound('alarm')
    );

    int id = int.parse(uuid.v4());

    // Programar la alarma
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        title,
        alarmTime,
        //platformChannelSpecifics,
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
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
    return id;
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
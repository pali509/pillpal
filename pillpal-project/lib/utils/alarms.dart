import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';
import 'package:uuid/uuid.dart';

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

void una_vez(DateTime diaDeInicio,  String hora, String name, int num) async {
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
  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);


  // Programar la alarma
  await flutterLocalNotificationsPlugin.zonedSchedule(
      int.parse(uuid.v4()),
      'Tome $num unidades de $name.',
      'Tome $num unidades de $name.',
      alarmTime,
      platformChannelSpecifics,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true
  );
}
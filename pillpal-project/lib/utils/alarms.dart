import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';

void diarias(DateTime diaDeInicio,  String hora, String name, int num) async {

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
    0,
    name.toUpperCase(),
    'Tome $num unidades de $name.',
    RepeatInterval.daily,
    platformChannelSpecifics,
    androidAllowWhileIdle: true,
  );
}


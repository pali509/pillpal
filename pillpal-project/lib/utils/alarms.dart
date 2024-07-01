import 'dart:math';

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

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
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
      onDidReceiveNotificationResponse: notificationTapBackground,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  @pragma('vm:entry-point')
  static Future<void> notificationTapBackground(NotificationResponse notificationResponse) async {
    List<String> payload = notificationResponse.payload!.split(';');
    DateTime today = DateTime.now();
    if (notificationResponse.actionId == 'Tomar') {
      String s = payload[0] + ";" + payload[1] + ";" + payload[5] + ";Si";
      insert_statistics(today, getUserId(), int.parse(payload[0]),
          int.parse(payload[0]), s);
      //Restar cantidad
      int final_pills = await subPills(
          getUserId(), int.parse(payload[5]), int.parse(payload[0]));

      // Comprobar si quedan pocas y mandar notificacion
      //Será -1 si hay error o si no se desean notificaciones
      if (final_pills <= 5 && final_pills >= 0)
        showNotificationNoPills(payload[1], final_pills);
    }
    else {//Si se ignora o si se pulsa la noti
      String s = payload[0] + ";" + payload[1] + ";No";
      insert_statistics(today, getUserId(), 0,
          int.parse(payload[0]), s);
    }
    if(payload[2] != '0000000') {
      DateTime nextDay = calcularDiaSiguiente(today, payload[2]);
      debugPrint('HORA FINAL: ${nextDay.day}/${nextDay.month}/${nextDay.year}');
      //una_vez(int.parse(payload[4]), nextDay, payload[3], payload[1], int.parse(payload[0]), payload[2]);
    }
  }

  static Future<void> una_vez(int id, DateTime diaDeInicio, String hora, String name, int num, String days, int pill_id) async {
    debugPrint("HORA: $hora");
    int h = int.parse(hora.split(":")[0]);
    int m = int.parse(hora.split(":")[1].split(" ")[0]);

    if(hora.split(":")[1].split(" ").length > 1) {
      if (hora.split(":")[1].split(" ")[1] == "PM") h = h + 12;
    }
    String title = 'Tome $num unidades de $name.';
    String payload = '$num;$name;$days;$hora;$id;$pill_id';
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
      payload: payload,
      nd,
    );
    _checkPendingNotificationRequests();
  }

  Future<void> deleteAlarm(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  static Future<void> _checkPendingNotificationRequests() async {
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

  static DateTime calcularDiaSiguiente(DateTime today, String days) {
    int day = today.weekday - 1 + 1;
    int cont = 1;
    for(int i = 0; i < 7; i++){
      if(day > 6) day = 0;
      if(days[day] == '1') break;
      cont++;
      day++;
    }
    int dia = today.day, mes = today.month, anio = today.year;
    dia += cont;
    if(dia > daysInMonth(mes, anio)){
      dia -= daysInMonth(mes, anio);
      mes++;
      if(mes > 12){
        mes = 1;
        anio++;
      }
    }
    DateTime newdt = DateTime.utc(anio, mes, dia);
    return newdt;
  }

  static int daysInMonth(int mes, int anio){
    List<int> days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if ((anio % 4 == 0 && anio % 100 != 0) || (anio % 100 == 0 && anio % 400 == 0)) days[1] = 29;
    return days[mes - 1];
  }

  static void showNotificationNoPills(String name, int num) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('channel_id', 'Channel Name',
        channelDescription: 'Channel Description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');

    Random random = Random();
    int notification_id = random.nextInt(10000);
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    String title = name;
    String value = "";
    if (num == 1)
      value = "Queda una unidad de la medicación \"$name\"";
    else
      value = "Quedan $num unidades de la medicación \"$name\"";
    await flutterLocalNotificationsPlugin.show(
        notification_id, title, value, notificationDetails, payload: '');
  }
}





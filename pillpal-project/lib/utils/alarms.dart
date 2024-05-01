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
  static void notificationTapBackground(NotificationResponse notificationResponse) {
    List<String> payload = notificationResponse.payload!.split(';');
    DateTime today = DateTime.now();
    if (notificationResponse.actionId == 'Tomar') {
      debugPrint("PRINGAITO1");
      String s = payload[0] + ";" + payload[1] + ";Si";
      insert_statistics(today, getUserAsociadoId(), int.parse(payload[0]),
          int.parse(payload[0]), s);
      // do something
    }
    else {//Si se ignora o si se pulsa la noti
      debugPrint("PRINGAITO2");
      String s = payload[0] + ";" + payload[1] + ";No";
      insert_statistics(today, getUserAsociadoId(), 0,
          int.parse(payload[0]), s);
      // do something else
    }
    if(payload[2] != '0000000') {
      DateTime nextDay = calcularDiaSiguiente(today, payload[2]);
      debugPrint('HORA FINAL: ${nextDay.day}/${nextDay.month}/${nextDay.year}');
      //una_vez(int.parse(payload[4]), nextDay, payload[3], payload[1], int.parse(payload[0]), payload[2]);
    }
    //1;Algo Delulu;0000000;8:01 PM;3
    //1;Paracetamol;Si;3;Ibuprofeno;No
  }

  static Future<void> una_vez(int id, DateTime diaDeInicio, String hora, String name, int num, String days) async {
    int h = int.parse(hora.split(":")[0]);
    int m = int.parse(hora.split(":")[1].split(" ")[0]);
    if(hora.split(":")[1].split(" ")[1] == "PM") h = h + 12;
    String title = 'Tome $num unidades de $name.';
    String payload = '$num;$name;$days;$hora;$id';
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
}





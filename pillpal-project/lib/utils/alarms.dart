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

  Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Initialize native android notification
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
    tz.initializeTimeZones();
  }

  void showTimedNotification(int id, DateTime diaDeInicio, String hora, String name,
      int num){
    int notification_id = 1;

    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('repeating_daily', 'Repertir diaria',
        channelDescription: 'ALARMA PELIGRO',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');

    /*flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        "PRUEBA 1",
        "POR FAVOR FUNCIONA",
        tz.TZDateTime.now(tz.local).add(const Duration(days: 3)),
        const NotificationDetails(
            android: androidNotificationDetails,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime
    ));*/
  }

  // Future<void> zonedSchedule(int id, String? title, String? body,
  //     TZDateTime scheduledDate, NotificationDetails notificationDetails,
  //     {required UILocalNotificationDateInterpretation
  //         uiLocalNotificationDateInterpretation,
  //     required bool androidAllowWhileIdle,
  //     String? payload,
  //     DateTimeComponents? matchDateTimeComponents})

  void showNotificationAndroid(int id, DateTime diaDeInicio, String hora, String name,
      int num) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('channel_id', 'Channel Name',
        channelDescription: 'Channel Description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');

    int notification_id = 1;
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

   // await flutterLocalNotificationsPlugin
        //.show(notification_id, title, value, notificationDetails, payload: 'Not present');
  }

  Future<void> una_vez(int id, DateTime diaDeInicio, String hora, String name,
      int num) async {
    int h = int.parse(hora.split(":")[0]);
    int m = int.parse(hora.split(":")[1].split(" ")[0]);
    if(hora.split(":")[1].split(" ")[1] == "PM") h = h + 12;
    String title = 'Tome $num unidades de $name.';
    // Convertir la hora a un objeto TZDateTime
    Duration offsetTime = DateTime
        .now()
        .timeZoneOffset;
    tz.initializeTimeZones();
    tz.TZDateTime zonedTime = tz.TZDateTime.local(DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        DateTime.now().hour,
        DateTime.now().minute).subtract(offsetTime);
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
    debugPrint(h.toString());
    debugPrint(m.toString());
    final alarmTime = TZDateTime.from(
      DateTime(
        diaDeInicio.year,
        diaDeInicio.month,
        diaDeInicio.day,
        h,
        m,
      ),
      zonedTime.location,
    );
    debugPrint(alarmTime.year.toString());
    debugPrint(alarmTime.month.toString());
    debugPrint(alarmTime.day.toString());
    debugPrint(alarmTime.hour.toString());
    debugPrint(alarmTime.minute.toString());
    debugPrint(alarmTime.second.toString());

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
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation
          .absoluteTime,
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
              titleColor: Colors.lightGreen
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

  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    debugPrint("hay luz");
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
  }


  @pragma('vm:entry-point')
  void notificationTapBackground(NotificationResponse notificationResponse) {
    //2 casos, si ya hay registro y si no hay registro
    if (notificationResponse.actionId == 'Tomar') {
      insert_statistics(DateTime.now(), user_id!, 1, 1, "summary");
      debugPrint("Tomado");
    }
    else if (notificationResponse.actionId == 'Ignorar') {
      insert_statistics(DateTime.now(), user_id!, 0, 1, "summary");
      debugPrint("Outttt");
    }
  }

  Future<void> deleteAlarm(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
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


  void diarias(DateTime diaDeInicio, String hora, String name, int num) async {
    var uuid = Uuid();
    // Convertir la hora a un objeto TZDateTime
    final alarmTime = TZDateTime.from(
      DateTime(
          diaDeInicio.year,
          diaDeInicio.month,
          diaDeInicio.day /*,
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
    /*flutterLocalNotificationsPlugin.periodicallyShow(
      int.parse(uuid.v4()),
      name.toUpperCase(),
      'Tome $num unidades de $name.',
      RepeatInterval.daily,
      platformChannelSpecifics,
    );*/
  }

  Future<void> una_vez(int id, DateTime diaDeInicio, String hora, String name,
      int num) async {
    String title = 'Tome $num unidades de $name.';
    // Convertir la hora a un objeto TZDateTime
    Duration offsetTime = DateTime
        .now()
        .timeZoneOffset;
    tz.initializeTimeZones();
    tz.TZDateTime zonedTime = tz.TZDateTime.local(DateTime
        .now()
        .year, DateTime
        .now()
        .month,
        DateTime
            .now()
            .day, DateTime
            .now()
            .hour, DateTime
            .now()
            .minute).subtract(offsetTime);
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
    /*await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      title,
      alarmTime,
      //platformChannelSpecifics,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation
          .absoluteTime,
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
    );*/
  }



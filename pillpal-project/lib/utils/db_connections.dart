import 'package:pillpal/utils/alarma_type.dart';
import 'package:pillpal/utils/horario.dart';
import 'package:pillpal/utils/pills.dart';
import 'package:pillpal/utils/statistic_type.dart';
import 'package:supabase/src/supabase_stream_builder.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:pillpal/utils/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:quiver/time.dart';
import 'package:jiffy/jiffy.dart';


var databaseConnection = PostgreSQLConnection(
    'aws-0-eu-central-1.pooler.supabase.com',
    6543,
    'postgres',
    queryTimeoutInSeconds: 3600,
    timeoutInSeconds: 3600,
    username: 'postgres.amwzytiutgstvnrpaiju',
    password: 'PillPal19DB');

initDatabaseConnection() async {
  databaseConnection.open().then((value) {
    debugPrint("Database Connected!");
  });
}

Future<List<String>> getUser(int userId) async {
  List<Map<String, dynamic>> mapUser = await databaseConnection.mappedResultsQuery("""
    select u.user_id, u.user_name, u.user_email 
    from "Users" u
    where user_id = $userId
  """);
  List<String> listUsers = [];
  if(mapUser[0].isNotEmpty) {
    listUsers.add(mapUser[0]['Users']['user_id'].toString());
    listUsers.add(mapUser[0]['Users']['user_name']);
    listUsers.add(mapUser[0]['Users']['user_email']);
  }
  return listUsers;
}

Future<void> updateUser(int userId, String? email, String? name, String? pwd, String? desayuno, String? comida, String? cena, String? dormir)async{
    if(email != null){
      await databaseConnection.query("""
          UPDATE "Users"
          SET user_email = '$email'
          WHERE user_id = $userId;
      """);
    }
    if(name != null){
      await databaseConnection.query("""
          UPDATE "Users"
          SET user_name = '$name'
          WHERE user_id = $userId;
      """);
    }
    if(pwd != null && pwd != ''){
      await databaseConnection.query("""
          UPDATE "Users"
          SET user_pwd = '$pwd'
          WHERE user_id = $userId;
      """);
    }
    if(desayuno != null){
      await databaseConnection.query("""
          UPDATE "Users"
          SET hora_desayuno = '$desayuno'
          WHERE user_id = $userId;
      """);
    }
    if(comida != null){
      await databaseConnection.query("""
          UPDATE "Users"
          SET hora_comida = '$comida'
          WHERE user_id = $userId;
      """);
    }
    if(cena != null){
      await databaseConnection.query("""
          UPDATE "Users"
          SET hora_cena = '$cena'
          WHERE user_id = $userId;
      """);
    }
    if(dormir != null){
      await databaseConnection.query("""
          UPDATE "Users"
          SET hora_dormir = '$dormir'
          WHERE user_id = $userId;
      """);
    }
}

Future<void> insertPills(String pillName, int numPills, int userId, String pill_type, String url) async {
  debugPrint("HELP $url");
  await databaseConnection.query("""
    INSERT INTO "Pills"(pill_name, user_id, pill_quantity, pill_type, pill_photo)
    VALUES ('$pillName', $userId, $numPills, '$pill_type', '$url');
  """);
}

Future<void> updatePills(String pillName, int numPills, int userId, String pill_type, int pill_id, String url) async{
  await databaseConnection.query("""
    UPDATE "Pills"
    SET pill_name = '$pillName', pill_quantity = $numPills, pill_type = '$pill_type', pill_photo = '$url'
    WHERE user_id = $userId and pill_id = $pill_id
  """);
}

Future<void> deletePill(Pill pill) async {
  int? pillId = pill.getPillId();
  int? userId = pill.getUserId();

  await databaseConnection.query("""
      DELETE FROM "Horario"
    WHERE pill_id = $pillId AND user_id = $userId;
  """);

  await databaseConnection.query("""
      DELETE FROM "Pills"
    WHERE pill_id = $pillId AND user_id = $userId;
  """);

}

Future<List<Pill>> getPills(int userId) async {
  List<Map<String, dynamic>> mapPills = await databaseConnection
      .mappedResultsQuery("""
      SELECT * FROM "Pills" WHERE user_id = $userId """);
  List<Pill>listPills = [];
  debugPrint("ASTA");
  for(int i = 0; i < mapPills.length; i++) {
    debugPrint("Aqui " + mapPills[i]['Pills']['pill_photo']);
    listPills.add(Pill(
        mapPills[i]['Pills']['pill_id'],
        mapPills[i]['Pills']['pill_quantity'],
        mapPills[i]['Pills']['pill_name'],
        mapPills[i]['Pills']['user_id'],
        mapPills[i]['Pills']['pill_type'],
        mapPills[i]['Pills']['pill_photo']
    ));
  }
  return listPills;
}
Future<int> getPillId(String pillName, int userId) async {
  List<List<dynamic>> results = await databaseConnection.query(
    'SELECT pill_id FROM "Pills" WHERE pill_name = @pillName AND user_id = @userId',
    substitutionValues: {
      'pillName': pillName,
      'userId': userId,
    },
  );
  if (results.isNotEmpty) {
    return results.first.first as int;
  } else {
    return -1;
  }
}

Future<bool> getUserByEmail(String email) async {
  List<Map<String, dynamic>>? userList = await databaseConnection
      .mappedResultsQuery("""
      SELECT * FROM "Users" WHERE user_email = '$email'""");
  if(userList.isNotEmpty) {
    //debugPrint(userList[0]['Users']['user_role_id']);
    if(userList[0]['Users']['user_role_id'] == 0 || userList[0]['Users']['user_role_id'] == 2) {
      setUser(
          userList[0]['Users']['user_id'],
          userList[0]['Users']['user_email'],
          userList[0]['Users']['user_name'],
          userList[0]['Users']['user_role_id'],
          userList[0]['Users']['user_id'],
          userList[0]['Users']['hora_desayuno'],
          userList[0]['Users']['hora_comida'],
          userList[0]['Users']['hora_cena'],
          userList[0]['Users']['hora_dormir']);
    }
    else {
      int id_cuidador = userList[0]['Users']['user_id'];
      List<Map<String, dynamic>>? relationList = await databaseConnection
          .mappedResultsQuery("""
          SELECT r.paciente_id, u.hora_desayuno, u.hora_comida, u.hora_cena, u.hora_dormir 
          FROM "Relationships" r join "Users" u on r.paciente_id = u.user_id  
          WHERE r.cuidador_id = $id_cuidador
          """);
      if(relationList.isNotEmpty) {
        setUser(
            userList[0]['Users']['user_id'],
            userList[0]['Users']['user_email'],
            userList[0]['Users']['user_name'],
            userList[0]['Users']['user_role_id'],
            relationList[0]['Relationships']['paciente_id'],
            relationList[0]['Users']['hora_desayuno'],
            relationList[0]['Users']['hora_comida'],
            relationList[0]['Users']['hora_cena'],
            relationList[0]['Users']['hora_dormir']);
        debugPrint("MIRA:");
        debugPrint(relationList[0]['Users']['hora_desayuno']);
      }
      else{
        setUser(
            userList[0]['Users']['user_id'],
            userList[0]['Users']['user_email'],
            userList[0]['Users']['user_name'],
            userList[0]['Users']['user_role_id'],
            userList[0]['Users']['user_id'],
            userList[0]['Users']['hora_desayuno'],
            userList[0]['Users']['hora_comida'],
            userList[0]['Users']['hora_cena'],
            userList[0]['Users']['hora_dormir']);

        debugPrint("MIRA:");
        debugPrint(userList[0]['Users']['hora_desayuno']);
      }
    }
    return true;
  }
  return false;
}

Future<bool> checkUser(String email, String pwd) async {
  List<Map<String, dynamic>>? userList = await databaseConnection
      .mappedResultsQuery("""
      SELECT * FROM "Users" WHERE user_email = '$email' and user_pwd = '$pwd'""");
  if(userList.isNotEmpty) {
    //debugPrint(userList[0]['Users']['user_role_id']);
    if(userList[0]['Users']['user_role_id'] == 0 || userList[0]['Users']['user_role_id'] == 2) {
      setUser(
          userList[0]['Users']['user_id'],
          userList[0]['Users']['user_email'],
          userList[0]['Users']['user_name'],
          userList[0]['Users']['user_role_id'],
          userList[0]['Users']['user_id'],
          userList[0]['Users']['hora_desayuno'],
          userList[0]['Users']['hora_comida'],
          userList[0]['Users']['hora_cena'],
          userList[0]['Users']['hora_dormir']);
    }
    else {
      int id_cuidador = userList[0]['Users']['user_id'];
      List<Map<String, dynamic>>? relationList = await databaseConnection
          .mappedResultsQuery("""
          SELECT r.paciente_id, u.hora_desayuno, u.hora_comida, u.hora_cena, u.hora_dormir 
          FROM "Relationships" r join "Users" u on r.paciente_id = u.user_id  
          WHERE r.cuidador_id = $id_cuidador
          """);
      if(relationList.isNotEmpty) {
        setUser(
            userList[0]['Users']['user_id'],
            userList[0]['Users']['user_email'],
            userList[0]['Users']['user_name'],
            userList[0]['Users']['user_role_id'],
            relationList[0]['Relationships']['paciente_id'],
            relationList[0]['Users']['hora_desayuno'],
            relationList[0]['Users']['hora_comida'],
            relationList[0]['Users']['hora_cena'],
            relationList[0]['Users']['hora_dormir']);
          debugPrint("MIRA:");
          debugPrint(relationList[0]['Users']['hora_desayuno']);
      }
      else{
        setUser(
            userList[0]['Users']['user_id'],
            userList[0]['Users']['user_email'],
            userList[0]['Users']['user_name'],
            userList[0]['Users']['user_role_id'],
            userList[0]['Users']['user_id'],
            userList[0]['Users']['hora_desayuno'],
            userList[0]['Users']['hora_comida'],
            userList[0]['Users']['hora_cena'],
            userList[0]['Users']['hora_dormir']);

          debugPrint("MIRA:");
          debugPrint(userList[0]['Users']['hora_desayuno']);
      }
    }
    return true;
  }
  return false;
}
Future<bool> correctPwd(String email, String pwd) async {
  List<Map<String, dynamic>>? userList = await databaseConnection
      .mappedResultsQuery("""
      SELECT * FROM "Users" WHERE user_email = '$email' and user_pwd = '$pwd'""");
  if (userList.isNotEmpty) {
    return true;
  }
  else
    return false;
}
Future<bool> userExists(String email) async {
  List<Map<String, dynamic>>? userList = await databaseConnection
      .mappedResultsQuery("""
      SELECT * FROM "Users" WHERE user_email = '$email'""");
  if(userList.isNotEmpty)
    return true;
  else
    return false;
}

Future<void> insertUser(String nombre, String email, String pwd, int rol, int op) async {
  //op 2 == Registro usuario asociado y 1 == el que va a usar la app en este dispositivo
  await databaseConnection.query("""
    INSERT INTO "Users"(user_name, user_email, user_pwd, user_role_id)
    VALUES ('$nombre', '$email', '$pwd', $rol);
  """);
  if(op == 1)
    checkUser(email, pwd);
}

Future<int> getUsId(String email) async {
  List<Map<String, dynamic>>? userList = await databaseConnection
      .mappedResultsQuery("""
      SELECT user_id FROM "Users" WHERE user_email = '$email'""");
  if(userList.isNotEmpty)
    return userList[0]['Users']['user_id'];
  else
    return 0;
}
Future<int> getRolId(int id) async {
  List<Map<String, dynamic>>? userList = await databaseConnection
      .mappedResultsQuery("""
      SELECT user_role_id FROM "Users" WHERE user_id = $id""");
  if(userList.isNotEmpty)
    return userList[0]['Users']['user_role_id'];
  else
    return 0;
}

Future<void> addRelationship(int idSup, int idDep) async {
  await databaseConnection.query("""
    INSERT INTO "Relationships"(cuidador_id, paciente_id)
    VALUES ($idSup, $idDep);
  """);
}

Future<void> deleteRelationship(int id) async {
  await databaseConnection.query("""
      DELETE FROM "Relationships"
      WHERE cuidador_id = $id OR paciente_id = $id;
  """);
}
Future<void> deleteRelationshipUna(int idSup, int idDep) async {
  await databaseConnection.query("""
      DELETE FROM "Relationships"
      WHERE cuidador_id = $idSup AND paciente_id = $idDep;
  """);
}
Future<void> deleteUser(int id) async {
  //borramos user de las relaciones
  await deleteRelationship(id);

  //Borramos el horario de las pastillas del user
  await databaseConnection.query("""
      DELETE FROM "Horario"
      WHERE user_id = $id;
  """);

  //Borramos todas las pastillas del user
  await databaseConnection.query("""
      DELETE FROM "Pills"
      WHERE user_id = $id;
  """);

  //Borramos al user
  await databaseConnection.query("""
      DELETE FROM "Users"
      WHERE user_id = $id;
  """);

}

Future<List<Horario>> getDayPills(DateTime day, int userId) async {
  int dayOfWeek = day.weekday;

  List<Map<String, dynamic>> mapHorario = await databaseConnection
      .mappedResultsQuery("""
      SELECT p.pill_name, h."time_of_day", h.quantity, 
      EXTRACT (HOUR from h."hour") as actual_hour, 
      EXTRACT (MINUTE FROM h."hour") as minute
      FROM "Horario" h JOIN "Pills" p on h.pill_id = p.pill_id 
      WHERE h.user_id = $userId AND p.user_id = $userId AND ((h."period" = 0 and h.date <= '$day') OR 
      (h."period" = 2 and h.date = '$day') 
      OR (h."period" = 1 and substring(h.days, $dayOfWeek , 1) ='1' and h.date <= '$day'))
      ORDER BY h."hour"
      """);

  List<Horario>listHorario = [];
  debugPrint('longitud inicial de listHorario: ${listHorario.length}');
  for(int i = 0; i < mapHorario.length; i++) {
    String real_min = mapHorario[i]['']['minute'], real_hour = mapHorario[i]['']['actual_hour'];
    if(int.parse(mapHorario[i]['']['minute']) < 10) {
      real_min = '0$real_min';
    }
    if(int.parse(mapHorario[i]['']['actual_hour']) < 10) {
      real_hour = '0$real_hour';
    }
    listHorario.add(Horario(
        "$real_hour:$real_min",
        mapHorario[i]['Horario']['quantity'],
        mapHorario[i]['Pills']['pill_name'],
        mapHorario[i]['Horario']['time_of_day']
    ));
  }
  debugPrint('longitud final de listHorario: ${listHorario.length}');
  return listHorario;
}

Future<void> insertSchedule(String pillName, int userId, String time_of_day,
    DateTime? day, String hour, int quantity, int period, String daysOfWeek, int id) async {
  int num_time_of_day = 0;
  if(time_of_day == "Desayuno") {
    num_time_of_day = 1;
    hour = await getHour(num_time_of_day);
  }
  else if(time_of_day == "Comida") {
    num_time_of_day = 2;
    hour = await getHour(num_time_of_day);
  }
  else if(time_of_day == "Cena") {
    num_time_of_day = 3;
    hour = await getHour(num_time_of_day);
  }
  else if(time_of_day == "Dormir") {
    num_time_of_day = 4;
    hour = await getHour(num_time_of_day);
  }

  String query = """INSERT INTO "Horario"(pill_id, user_id, date, hour, time_of_day, quantity, period, days, alarm_id)
    VALUES ((select p.pill_id from "Pills" p where p.user_id = $userId 
      and p.pill_name  = '$pillName' limit 1), $userId, '$day', '$hour',
      $num_time_of_day, $quantity, $period, '$daysOfWeek', $id)""";
  await databaseConnection.query(query);

}

Future<String> getHour(int time_of_day) async{
  user_id = getUserAsociadoId();

  List<Map<String, dynamic>> mapUserTime = await databaseConnection
      .mappedResultsQuery('''
    SELECT 
      EXTRACT(HOUR FROM TO_TIMESTAMP(u."hora_desayuno", 'HH24:MI')) AS hora_desayuno,
      EXTRACT(MINUTE FROM TO_TIMESTAMP(u."hora_desayuno", 'HH24:MI')) AS minuto_desayuno,
      EXTRACT(HOUR FROM TO_TIMESTAMP(u."hora_comida", 'HH24:MI')) AS hora_comida,
      EXTRACT(MINUTE FROM TO_TIMESTAMP(u."hora_comida", 'HH24:MI')) AS minuto_comida,
      EXTRACT(HOUR FROM TO_TIMESTAMP(u."hora_cena", 'HH24:MI')) AS hora_cena,
      EXTRACT(MINUTE FROM TO_TIMESTAMP(u."hora_cena", 'HH24:MI')) AS minuto_cena,
      EXTRACT(HOUR FROM TO_TIMESTAMP(u."hora_dormir", 'HH24:MI')) AS hora_dormir,
      EXTRACT(MINUTE FROM TO_TIMESTAMP(u."hora_dormir", 'HH24:MI')) AS minuto_dormir
          from "Users" u
          where u.user_id = $user_id
      ''');

  String real_min = "00";
  String real_hour = "09";
  if(time_of_day == 1) {
    real_min = mapUserTime[0]['']['minuto_desayuno'];
    real_hour = mapUserTime[0]['']['hora_desayuno'];
    if (int.parse(real_min) < 10) {
      real_min = '0$real_min';
    }
    if (int.parse(real_hour) < 10) {
      real_hour = '0$real_hour';
    }
  }
  else if(time_of_day == 2) {
    real_min = mapUserTime[0]['']['minuto_comida'];
    real_hour = mapUserTime[0]['']['hora_comida'];
    if (int.parse(real_min) < 10) {
      real_min = '0$real_min';
    }
    if (int.parse(real_hour) < 10) {
      real_hour = '0$real_hour';
    }
  }
  else if(time_of_day == 3) {
    real_min = mapUserTime[0]['']['minuto_cena'];
    real_hour = mapUserTime[0]['']['hora_cena'];
    if (int.parse(real_min) < 10) {
      real_min = '0$real_min';
    }
    if (int.parse(real_hour) < 10) {
      real_hour = '0$real_hour';
    }
  }
  else{
    real_min = mapUserTime[0]['']['minuto_dormir'];
    real_hour = mapUserTime[0]['']['hora_dormir'];
    if (int.parse(real_min) < 10) {
      real_min = '0$real_min';
    }
    if (int.parse(real_hour) < 10) {
      real_hour = '0$real_hour';
    }
  }

  return "$real_hour:$real_min";
}
void edit_stadistics(DateTime date, int userId, int taken, int programmed, String summary) async{

  await databaseConnection.query("""
          UPDATE "Statistics"
          SET taken = $taken, programmed = $programmed, summary = '$summary'
          WHERE user_id = $userId and fecha = '$date'
      """);
}

void insert_statistics(DateTime date, int userId, int taken, int programmed, String summary) async{
  List<Map<String, dynamic>>? estadisticas = await databaseConnection
      .mappedResultsQuery("""
      select * from "Statistics" s where user_id = $userId and fecha = '$date'""");
  if(estadisticas.isNotEmpty) {
    //debugPrint(userList[0]['Users']['user_role_id'];
    int take = estadisticas[0]['Statistics']['taken'] + taken;
    int progs = estadisticas[0]['Statistics']['programmed'] + programmed;
    String suma = estadisticas[0]['Statistics']['summary'] + ';' + summary;
    await databaseConnection.query("""
          UPDATE "Statistics"
          SET taken = $take, programmed = $progs, summary = '$suma'
          WHERE user_id = $userId and fecha = '$date'
      """);
  }
  else {
    await databaseConnection.query("""INSERT INTO "Statistics" (fecha, user_id, taken, programmed, summary)
    VALUES ('$date', $userId, $taken, $programmed, '$summary')""");
  }
}

//Devuelve una lista con cada usuario.
// Dentro de un usuario se accede asi: user[i][0] -> user_id; user[i][1] -> user_name; user[i][2] -> user_email. 3 desayuno, 4 comida...
Future<List<List<String>>> getAsociados(int user_id) async{
  List<Map<String, dynamic>> mapUser = await databaseConnection
      .mappedResultsQuery("""
          select u.user_id, u.user_name, u.user_email, u.hora_desayuno, u.hora_comida, u.hora_cena, u.hora_dormir 
          from "Relationships" r join "Users" u on u.user_id = r.paciente_id  
          where r.cuidador_id = $user_id
      """);
  List<List<String>> listUsers = [];
  for(int i = 0; i < mapUser.length; i++) {
    listUsers.add([mapUser[i]['Users']['user_id'].toString(),
                  mapUser[i]['Users']['user_name'],
                  mapUser[i]['Users']['user_email'],
                  mapUser[i]['Users']['hora_desayuno'],
                  mapUser[i]['Users']['hora_comida'],
                  mapUser[i]['Users']['hora_cena'],
                  mapUser[i]['Users']['hora_dormir']
    ]);
  }
  return listUsers;
}

Future<List<Alarma_type>>getAlarmas(int user_id) async {
  //pill name, id, id_alarma, fecha, hora, periodo, timeofday, cantidad, dias
  List<Map<String, dynamic>> mapAlarms = await databaseConnection
      .mappedResultsQuery("""
          select p.pill_name, h.id, h.alarm_id, h."date", h."period", h.time_of_day, h.quantity, h.days, p.pill_id,
	        EXTRACT (HOUR from h."hour") as actual_hour, 
          EXTRACT (MINUTE FROM h."hour") as minute
          from "Horario" h join "Pills" p on h.pill_id = p.pill_id
          where p.user_id = $user_id and h.user_id = $user_id and 
          (h."period" = 0 or h."period" = 1 or 
          (h."period" = 2 and h."date" > TIMESTAMP 'yesterday'))
      """);
  List<Alarma_type> listAlarms = [];
  for(int i = 0; i < mapAlarms.length; i++) {
    String real_min = mapAlarms[i]['']['minute'], real_hour = mapAlarms[i]['']['actual_hour'];
    if(int.parse(mapAlarms[i]['']['minute']) < 10) {
      real_min = '0$real_min';
    }
    if(int.parse(mapAlarms[i]['']['actual_hour']) < 10) {
      real_hour = '0$real_hour';
    }
     listAlarms.add(Alarma_type("$real_hour:$real_min", mapAlarms[i]['Horario']['quantity'],
         mapAlarms[i]['Pills']['pill_name'],  mapAlarms[i]['Horario']['time_of_day'],
         mapAlarms[i]['Horario']['id'], mapAlarms[i]['Horario']['alarm_id'],
         mapAlarms[i]['Horario']['period'], mapAlarms[i]['Horario']['date'],
         mapAlarms[i]['Horario']['days'],  mapAlarms[i]['Pills']['pill_id']));
  }
  return listAlarms;
}


Future<void> deleteAlarmBd(int alarm_id) async {
  await databaseConnection.query("""
      DELETE FROM "Horario"
      WHERE id = $alarm_id
  """);
}

Future<Statistic_type> getSta(DateTime dia, DateTime semMes, int user_id) async {
  DateTime hoyAM = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0, 0, 0);
  DateTime hoyPM = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59, 99, 99);
  int taken = 0;
  int nt = 0;
  String pills = "";
  int wt = 0;
  int wp = 0;
  int mt = 0;
  int mp = 0;

  List<Map<String, dynamic>> map = await databaseConnection.mappedResultsQuery("""
    select * from "Statistics" s where user_id  = $user_id and fecha = '$dia'
  """);

  if(map.isNotEmpty) {
    taken = map[0]['Statistics']['taken'];
    nt = map[0]['Statistics']['programmed'];
    pills = map[0]['Statistics']['summary'];
  }

  List<Map<String, dynamic>> map2 = await databaseConnection.mappedResultsQuery("""
     select sum(programmed) as prog, sum(taken) as take 
     from "Statistics" s 
     where user_id = $user_id and 
     DATE_TRUNC('week', fecha::date) = DATE_TRUNC('week', '$semMes'::date)
     and EXTRACT(YEAR FROM fecha) = ${semMes.year} 
     and s.fecha < '$hoyAM'
  """);

  if(map2[0]['']['take'] != null &&  map2[0]['']['prog'] != null) {
    wt = map2[0]['']['take'];
    wp = map2[0]['']['prog'];
  }

  List<DateTime> futureDays = futuredays(dia);
  for(int i = 0; i < futureDays.length; i++){
    List<Map<String, dynamic>> map4 = await databaseConnection.mappedResultsQuery("""
     SELECT sum(h.quantity) as prog
      FROM "Horario" h
      WHERE h.user_id = $user_id AND ((h."period" = 0 and h.date <= '${futureDays[i]}') OR 
      (h."period" = 2 and h.date = '${futureDays[i]}') 
      OR (h."period" = 1 and substring(h.days, ${futureDays[i].weekday} , 1) ='1' and h.date <= '${futureDays[i]}'))
  """);
    if(map4[0]['']['prog'] != null) wp = map4[0]['']['prog'] + wp;
  }

  List<Map<String, dynamic>> map3 = await databaseConnection.mappedResultsQuery("""
     select sum(programmed) as prog, sum(taken) as take 
     from "Statistics" s 
     where user_id = $user_id and EXTRACT(MONTH FROM fecha) = ${semMes.month}
     and EXTRACT(YEAR FROM fecha) = ${semMes.year}
     and s.fecha < '$hoyAM'
  """);

  if( map3[0]['']['take'] != null && map3[0]['']['prog'] != null) {
    mt = map3[0]['']['take'];
    mp = map3[0]['']['prog'];
  }


  List<DateTime> futureDaysM = futuredaysMonth(dia);
  for(int i = 0; i < futureDaysM.length; i++){
    List<Map<String, dynamic>> map5 = await databaseConnection.mappedResultsQuery("""
     SELECT sum(h.quantity) as prog
      FROM "Horario" h
      WHERE h.user_id = $user_id AND ((h."period" = 0 and h.date <= '${futureDaysM[i]}') OR 
      (h."period" = 2 and h.date = '${futureDaysM[i]}') 
      OR (h."period" = 1 and substring(h.days, ${futureDaysM[i].weekday} , 1) ='1' and h.date <= '${futureDaysM[i]}'))
  """);
    if(map5[0]['']['prog'] != null) mp = map5[0]['']['prog'] + mp;
  }
  int hoyWeek = Jiffy.parse('${hoyAM.year}-${hoyAM.month}-${hoyAM.day}').weekOfYear;
  int diaWeek = Jiffy.parse('${dia.year}-${dia.month}-${dia.day}').weekOfYear;
  if(hoyAM.year == dia.year && hoyWeek == diaWeek){
    List<int> hoyPills = await hoypills(user_id);
    wp = hoyPills[1] + wp;
    wt = hoyPills[0] + wt;
    mp = hoyPills[1] + mp;
    mt = hoyPills[0] + mt;
  }
  else if(hoyAM.year == dia.year && hoyAM.month == dia.month){
    List<int> hoyPills = await hoypills(user_id);
    mp = hoyPills[1] + mp;
    mt = hoyPills[0] + mt;
  }

  debugPrint('pastillas tomadas: $taken');
  debugPrint('pastillas NO tomadas: $nt');
  debugPrint('pastillas: $pills');
  debugPrint('pastillas tomadas SEMANALES: $wt');
  debugPrint('pastillas NO tomadas SEMANALES: $taken');
  debugPrint('pastillas tomadas MENSUALES: $mt');
  debugPrint('pastillas NO tomadas MENSUALES: $mp');

  return Statistic_type(taken, nt, pills, wt, wp, mt, mp);
}

Future<List<int>> hoypills(int user_id) async {
  List<int> pillFinales = [];
  pillFinales.add(0);
  pillFinales.add(0);
  List<String> nameSta = [];
  List<int> qsta = [];
  List<String> nameHor = [];
  List<int> qhor = [];
  DateTime hoy = DateTime.now();
  List<Map<String, dynamic>> map = await databaseConnection.mappedResultsQuery("""
    select * from "Statistics" s where user_id  = $user_id and fecha = '$hoy'
  """);
  if(map.isNotEmpty){
    String pills = map[0]['Statistics']['summary'];
    List<String> splitPills = pills.split(";");
    for(int i = 0; i < splitPills.length; i = i+4) {
      if (splitPills[i + 3] == "Si") {
        pillFinales[0] = int.parse(splitPills[i]) + pillFinales[0];
      }
      nameSta.add(splitPills[i + 1]);
      qsta.add(int.parse(splitPills[i]));
    }
  }
  List<Map<String, dynamic>> map2 = await databaseConnection.mappedResultsQuery("""
      SELECT p.pill_name, h.quantity
      FROM "Horario" h JOIN "Pills" p on h.pill_id = p.pill_id 
      WHERE h.user_id = $user_id AND p.user_id = $user_id AND ((h."period" = 0 and h.date <= '$hoy') OR 
      (h."period" = 2 and h.date = '$hoy') 
      OR (h."period" = 1 and substring(h.days, ${hoy.weekday} , 1) ='1' and h.date <= '$hoy'))
  """);
  if(map2.isNotEmpty){
    debugPrint(map2.toString());
    for(int i = 0; i < map2.length; i++) {
      nameHor.add(map2[i]['Pills']['pill_name']);
      qhor.add(map2[i]['Horario']['quantity']);
    }
  }
  for (int i = 0; i < nameSta.length; i++){
    pillFinales[1] = pillFinales[1] + qsta[i];
    bool found = false;
    int j = 0;
    while (!found && j < nameHor.length) {
      if (nameSta[i] == nameHor[j] && qsta[i] == qhor[j]) {
        found = true;
        nameHor.removeAt(j);
        qhor.removeAt(j);
      }
      j++;
    }
  }
  for(int i = 0; i < qhor.length; i++){
    pillFinales[1] = pillFinales[1] + qhor[i];
  }
  return pillFinales;
}

List<DateTime> futuredaysMonth(DateTime dia) {
  List<DateTime> daysInM = [];
  DateTime hoy = DateTime.now();
  if(dia.year < hoy.year || (dia.year == hoy.year && dia.month < hoy.month)){
  }
  else if(dia.year > hoy.year || (dia.year == hoy.year && dia.month > hoy.month)){
   int days = daysInMonth(dia.year, dia.month);
   for (int i = 1; i <= days;i++){
     daysInM.add(DateTime(dia.year, dia.month, i));
   }
  }
  else if(dia.year == hoy.year && dia.month == hoy.month){
    int days = daysInMonth(dia.year, dia.month);
    for (int i = hoy.day + 1; i <= days;i++){
      daysInM.add(DateTime(dia.year, dia.month, i));
    }
  }
  return daysInM;
}

List<DateTime> futuredays(DateTime dia) {
  DateTime hoy = DateTime.now();
  List<DateTime> daysInWeek = [];
  DateTime sun = dia.add(Duration(days: (7 - dia.weekday)));
  DateTime mon = dia.subtract(Duration(days: (dia.weekday - 1)));
  if (hoy.isAfter(sun)){
  }
  else if(hoy.isBefore(mon)){
    daysInWeek.add(mon);
    for(int i = 0; i < 6; i++){
      daysInWeek.add(daysInWeek.last.add(const Duration(days: 1)));
    }
  }
  else{
    if(hoy.weekday != 7){
      int aux = hoy.weekday + 2;
      daysInWeek.add(hoy.add(const Duration(days: 1)));
      while (aux <= 7){
        daysInWeek.add(daysInWeek.last.add(const Duration(days: 1)));
        aux++;
      }
    }
  }
  return daysInWeek;
}

Future<Statistic_type> getStaDia(DateTime dia, int user_id) async {
  int taken = 0;
  int nt = 0;
  String pills = "";
  int wt = 0;
  int wp = 0;
  int mt = 0;
  int mp = 0;

  List<Map<String, dynamic>> map = await databaseConnection.mappedResultsQuery("""
    select * from "Statistics" s where user_id  = $user_id and fecha = '$dia'
  """);

  if(map.isNotEmpty) {
    taken = map[0]['Statistics']['taken'];
    nt = map[0]['Statistics']['programmed'];
    pills = map[0]['Statistics']['summary'];
  }

  return Statistic_type(taken, nt, pills, wt, wp, mt, mp);
}

Future<int> subPills(int user_id, int pill_id, int q) async {
  List<Map<String, dynamic>> map = await databaseConnection.mappedResultsQuery(
      """
    select * from "Pills" p  where user_id = $user_id and pill_id = $pill_id
  """);
  int final_q = -1;
  if (map[0].isNotEmpty) {
    final_q = map[0]['Pills']['pill_quantity'] - q;
    if (final_q < 0) final_q = 0;
    await databaseConnection.query("""
          UPDATE "Pills" 
          SET pill_quantity  = $final_q
          WHERE user_id = $user_id and pill_id = $pill_id;
      """);
  }
  return final_q;
}

Future<void> changePills(int user_id, int pill_id, int q, int op) async {
  List<Map<String, dynamic>> map = await databaseConnection.mappedResultsQuery(
      """
    select * from "Pills" p  where user_id = $user_id and pill_id = $pill_id
  """);
  int final_q = -1;
  if (map[0].isNotEmpty) {
    final_q = op == 1? map[0]['Pills']['pill_quantity'] + q : map[0]['Pills']['pill_quantity'] - q;
    if (final_q < 0) final_q = 0;
    await databaseConnection.query("""
          UPDATE "Pills" 
          SET pill_quantity  = $final_q
          WHERE user_id = $user_id and pill_id = $pill_id;
      """);
  }

}

Future<void>actualizar_alarmas(int user_id, int alarm_id,
    int numPills, DateTime day, String hour, int timeOfDay, int period) async {
  await databaseConnection.query("""
          UPDATE "Horario" 
          SET quantity  = $numPills, date = '$day', hour = '$hour', time_of_day = $timeOfDay, period = $period
          WHERE user_id = $user_id and alarm_id = $alarm_id;
      """);

}

Future<String>getUrlPhoto(int id) async {
  List<Map<String, dynamic>>? list = await databaseConnection
      .mappedResultsQuery("""
      SELECT pill_photo FROM "Pills" WHERE pill_id = $id""");
  if(list.isNotEmpty)
    return list[0]['Pills']['pill_photo'];
  else
    return "";

}
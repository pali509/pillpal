import 'package:pillpal/utils/horario.dart';
import 'package:pillpal/utils/pills.dart';
import 'package:supabase/src/supabase_stream_builder.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:pillpal/utils/user.dart';

var databaseConnection = PostgreSQLConnection(
    'aws-0-eu-central-1.pooler.supabase.com',
    5432,
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

/*Future<void> connecting() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://amwzytiutgstvnrpaiju.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFtd3p5dGl1dGdzdHZucnBhaWp1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTgzNDA3MzQsImV4cCI6MjAxMzkxNjczNH0.-15tfv5ltd59NnnC00FKUL-IsCmWvrpk1y4ktfHA2Y4',
  );
}*/

Future<List<List<String>> > getUser(int userId) async {
  List<Map<String, dynamic>> mapUser = await databaseConnection.mappedResultsQuery("""
    select u.user_id, u.user_name, u.user_email 
    from "Users" u
    where user_id = $userId
  """);
  List<List<String>> listUsers = [];
  for(int i = 0; i < mapUser.length; i++) {
    listUsers.add([mapUser[i]['Users']['user_id'].toString(),
      mapUser[i]['Users']['user_name'],
      mapUser[i]['Users']['user_email']]);
  }
  return listUsers;
}

Future<void> updateUser(int userId, String? email, String? name, String? pwd)async{
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
    if(pwd != null){
      await databaseConnection.query("""
          UPDATE "Users"
          SET user_pwd = '$pwd'
          WHERE user_id = $userId;
      """);
    }
}

Future<void> insertPills(String pillName, int numPills, int userId) async {
  await databaseConnection.query("""
    INSERT INTO "Pills"(pill_name, user_id, pill_quantity)
    VALUES ('$pillName', $userId, $numPills);
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

Future<List<Pill>>? getPills(int userId) async {
  List<Map<String, dynamic>> mapPills = await databaseConnection
      .mappedResultsQuery("""
      SELECT * FROM "Pills" WHERE user_id = $userId """);
  List<Pill>listPills = [];
  for(int i = 0; i < mapPills.length; i++) {
    listPills.add(Pill(
        mapPills[i]['Pills']['pill_id'],
        mapPills[i]['Pills']['pill_quantity'],
        mapPills[i]['Pills']['pill_name'],
        mapPills[i]['Pills']['user_id']
    ));
  }
  return listPills;
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
Future<int> getRolId(int email) async {
  List<Map<String, dynamic>>? userList = await databaseConnection
      .mappedResultsQuery("""
      SELECT user_role_id FROM "Users" WHERE user_email = '$email'""");
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
      real_min = '0' + real_min;
    }
    if(int.parse(mapHorario[i]['']['actual_hour']) < 10) {
      real_hour = '0' + real_hour;
    }
    listHorario.add(Horario(
        real_hour + ":" + real_min,
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
  List<Map<String, dynamic>> mapUserTime = await databaseConnection
      .mappedResultsQuery("""
          select EXTRACT (HOUR from u.hora_desayuno) as hora_desayuno,
          EXTRACT (MINUTE FROM u.hora_desayuno) as minuto_desayuno,
          EXTRACT (HOUR from u.hora_comida) as hora_comida,
          EXTRACT (MINUTE FROM u.hora_comida) as minuto_comida,
          EXTRACT (HOUR from u.hora_cena) as hora_cena,
          EXTRACT (MINUTE FROM u.hora_cena) as minuto_cena,
          EXTRACT (HOUR from u.hora_dormir) as hora_dormir,
          EXTRACT (MINUTE FROM u.hora_dormir) as minuto_dormir
          from "Users" u
          where u.user_id = $user_id
      """);
  String real_min = "00";
  String real_hour = "09";
  if(time_of_day == 1) {
    real_min = mapUserTime[0]['']['minuto_desayuno'];
    real_hour = mapUserTime[0]['']['hora_desayuno'];
    if (int.parse(real_min) < 10) {
      real_min = '0' + real_min;
    }
    if (int.parse(real_hour) < 10) {
      real_hour = '0' + real_hour;
    }
  }
  else if(time_of_day == 2) {
    real_min = mapUserTime[0]['']['minuto_comida'];
    real_hour = mapUserTime[0]['']['hora_comida'];
    if (int.parse(real_min) < 10) {
      real_min = '0' + real_min;
    }
    if (int.parse(real_hour) < 10) {
      real_hour = '0' + real_hour;
    }
  }
  else if(time_of_day == 3) {
    real_min = mapUserTime[0]['']['minuto_cena'];
    real_hour = mapUserTime[0]['']['hora_cena'];
    if (int.parse(real_min) < 10) {
      real_min = '0' + real_min;
    }
    if (int.parse(real_hour) < 10) {
      real_hour = '0' + real_hour;
    }
  }
  else{
    real_min = mapUserTime[0]['']['minuto_dormir'];
    real_hour = mapUserTime[0]['']['hora_dormir'];
    if (int.parse(real_min) < 10) {
      real_min = '0' + real_min;
    }
    if (int.parse(real_hour) < 10) {
      real_hour = '0' + real_hour;
    }
  }

  return "$real_hour:$real_min";
}

void insert_statistics(DateTime date, int userId, int taken, int programmed, String summary) async{
  await databaseConnection.query("""INSERT INTO "Statistics" (fecha, user_id, taken, programmed, summary)
    VALUES ('$date', $userId, $taken, $programmed, '$summary')""");
}

//Devuelve una lista con cada usuario. Dentro de un usuario se accede asi: user[i][0] -> user_id; user[i][1] -> user_name; user[i][2] -> user_email.
Future<List<List<String>>> getAsociados(int user_id) async{
  List<Map<String, dynamic>> mapUser = await databaseConnection
      .mappedResultsQuery("""
          select u.user_id, u.user_name, u.user_email 
          from "Relationships" r join "Users" u on u.user_id = r.paciente_id  
          where r.cuidador_id = $user_id
      """);
  List<List<String>> listUsers = [];
  for(int i = 0; i < mapUser.length; i++) {
    listUsers.add([mapUser[i]['Users']['user_id'].toString(),
                  mapUser[i]['Users']['user_name'],
                  mapUser[i]['Users']['user_email']]);
  }
  return listUsers;
}
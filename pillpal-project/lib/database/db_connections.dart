import 'package:pillpal/database/horario.dart';
import 'package:pillpal/database/pills.dart';
import 'package:supabase/src/supabase_stream_builder.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:pillpal/database/user.dart';

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
      DELETE FROM "Pills"
    WHERE pill_id = $pillId AND user_id = $userId;
  """);

  await databaseConnection.query("""
      DELETE FROM "Horario"
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
          userList[0]['Users']['user_id']);
    }
    else {
      int id_cuidador = userList[0]['Users']['user_id'];
      List<Map<String, dynamic>>? relationList = await databaseConnection
          .mappedResultsQuery("""
            SELECT r.paciente_id FROM "Relationships" r  WHERE r.cuidador_id = $id_cuidador
              """);
      if(relationList.isNotEmpty) {
        setUser(
            userList[0]['Users']['user_id'],
            userList[0]['Users']['user_email'],
            userList[0]['Users']['user_name'],
            userList[0]['Users']['user_role_id'],
            relationList[0]['Relationships']['paciente_id']);
      }
      else{
        setUser(
            userList[0]['Users']['user_id'],
            userList[0]['Users']['user_email'],
            userList[0]['Users']['user_name'],
            userList[0]['Users']['user_role_id'],
            userList[0]['Users']['user_id']);
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
  List<Map<String, dynamic>> mapHorario = await databaseConnection
      .mappedResultsQuery("""
      SELECT p.pill_name, h."period", h.quantity, 
      EXTRACT (HOUR from h."hour") as actual_hour, 
      EXTRACT (MINUTE FROM h."hour") as minute
      FROM "Horario" h JOIN "Pills" p on h.pill_id = p.pill_id 
      WHERE h.user_id = $userId AND p.user_id = $userId AND (h.date = '$day' OR h.date is NULL) 
      ORDER BY h."hour"
      """);
  List<Horario>listHorario = [];
  debugPrint('${mapHorario.length}');
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
        mapHorario[i]['Horario']['period']
    ));
    debugPrint('aaaaaaaaaaaaaaaaaaaa');
    debugPrint('$listHorario[i]');
  }

  return listHorario;
}


import 'package:pillpal/database/pills.dart';
import 'package:supabase/src/supabase_stream_builder.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:pillpal/database/user.dart';

var databaseConnection = PostgreSQLConnection(
    'db.amwzytiutgstvnrpaiju.supabase.co',
    5432,
    'postgres',
    queryTimeoutInSeconds: 3600,
    timeoutInSeconds: 3600,
    username: 'postgres',
    password: 'PillPal19DB');

initDatabaseConnection() async {
  databaseConnection.open().then((value) {
    debugPrint("Database Connected!");
  });
}

Future<void> connecting() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://amwzytiutgstvnrpaiju.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFtd3p5dGl1dGdzdHZucnBhaWp1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTgzNDA3MzQsImV4cCI6MjAxMzkxNjczNH0.-15tfv5ltd59NnnC00FKUL-IsCmWvrpk1y4ktfHA2Y4',
  );
}

Future<void> insertPills(String pillName, int numPills, int userId) async {
  await databaseConnection.query("""
    INSERT INTO "Pills"(pill_name, user_id, pill_quantity)
    VALUES ('$pillName', $userId, $numPills);
  """);
}
Future<void> deletePill(Pill pill) async {
  int? pillId = pill.getPillId();
  await databaseConnection.query("""
      DELETE FROM "Pills"
    WHERE pill_id = $pillId;
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
    debugPrint(userList[0]['Users']['user_role_id']);
    setUser(userList[0]['Users']['user_id'], userList[0]['Users']['user_email'], userList[0]['Users']['user_name'], userList[0]['Users']['user_role_id']);
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

Future<void> insertUser(String nombre, String email, String pwd, int rol) async {
  await databaseConnection.query("""
    INSERT INTO "Users"(user_name, user_email, user_pwd, user_role_id)
    VALUES ('$nombre', '$email', '$pwd', $rol);
  """);
  checkUser(email, pwd);
}

import 'package:pillpal/database/pills.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:pillpal/database/pills.dart';


Future<void> connecting() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://amwzytiutgstvnrpaiju.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFtd3p5dGl1dGdzdHZucnBhaWp1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTgzNDA3MzQsImV4cCI6MjAxMzkxNjczNH0.-15tfv5ltd59NnnC00FKUL-IsCmWvrpk1y4ktfHA2Y4',
  );
}

Future<void> insertPill(String pillName, int numPills, int userId) async {
  await Supabase.instance.client.from('Pills').insert({
    'pill_name': pillName,
    'pill_quantity': numPills,
    'user_id': userId,
  });
}

List<Pill>? getPills(int userId){
    List<Pill> pills = [];

    pills.add(new Pill(1,1,"",1));
    return null;
}

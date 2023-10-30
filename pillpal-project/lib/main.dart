import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'pantalla_inicial.dart';
import 'pantalla_pastillero.dart';
import 'navigation_drawer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Supabase.initialize(url: 'https://amwzytiutgstvnrpaiju.supabase.co', anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFtd3p5dGl1dGdzdHZucnBhaWp1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTgzNDA3MzQsImV4cCI6MjAxMzkxNjczNH0.-15tfv5ltd59NnnC00FKUL-IsCmWvrpk1y4ktfHA2Y4', );
      runApp(MyApp());
  }


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/home', // Ruta inicial
      routes: {
        '/home': (context) => PantallaInicial(),
        '/pastis': (context) => Pastillero(),
      },
    );
  }
}


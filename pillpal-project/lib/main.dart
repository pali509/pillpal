import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pillpal/pantallas/pantalla_inicial.dart';
import 'package:pillpal/pantallas/pantalla_pastillero.dart';
import 'package:pillpal/pantallas/navigation_drawer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pillpal/database/db_connections.dart';

  Future<void> main() async {
    initDatabaseConnection();
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


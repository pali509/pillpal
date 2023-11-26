import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pillpal/pantallas/pantalla_inicial.dart';

import 'package:pillpal/pantallas/pantalla_pastillero.dart';
import 'package:pillpal/pantallas/navigation_drawer.dart';
import 'package:pillpal/pantallas/pantalla_registro.dart';

import 'package:pillpal/pantallas/pantalla_sesion.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pillpal/database/db_connections.dart';

Future<void> main() async {
  initDatabaseConnection();
  connecting();
  runApp(MyApp());
}
final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/cuenta', // Ruta inicial
      routes: {
        '/home': (context) => PantallaInicial(),
        '/pastis': (context) => Pastillero(),
        '/cuenta': (context) => LoginDemo(),
        '/registro': (context) => Registro(),
      },
    );
  }
}


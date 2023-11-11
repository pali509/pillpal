import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'pantalla_inicial.dart';
import 'pantalla_pastillero.dart';
import 'navigation_drawer.dart';
import 'database_connection.dart';

Future<void> main() async {
  connecting();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    connecting();
    return MaterialApp(
      initialRoute: '/home', // Ruta inicial
      routes: {
        '/home': (context) => PantallaInicial(),
        '/pastis': (context) => Pastillero(),
        '/prueba' : (context) => trial(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pillpal/pantallas/pantalla_informacionMed.dart';
import 'package:pillpal/pantallas/pantalla_inicial.dart';

import 'package:pillpal/pantallas/pantalla_pastillero.dart';
import 'package:pillpal/pantallas/navigation_drawer.dart';
import 'package:pillpal/pantallas/pantallas_sesion/pantalla_login_dependienteAsociado.dart';
import 'package:pillpal/pantallas/pantallas_sesion/pantalla_login_supervisorAsociado.dart';
import 'package:pillpal/pantallas/pantallas_sesion/pantalla_registro.dart';
import 'package:pillpal/pantallas/pantalla_calendario.dart';
import 'package:pillpal/pantallas/pantallas_sesion/pantalla_registro_dependienteAsociado.dart';
import 'package:pillpal/pantallas/pantallas_sesion/pantalla_registro_supervisorAsociado.dart';


import 'package:pillpal/pantallas/pantallas_sesion/pantalla_sesion.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pillpal/database/db_connections.dart';

Future<void> main() async {
  initDatabaseConnection();
  //connecting()
  runApp(MyApp());
  //var moonLanding = DateTime.parse("2020-02-10 12:00:00Z");
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
        '/cuenta': (context) => Login(),
        '/registro': (context) => Registro(),
        '/infoMed': (context) => InfoMed(),
        '/calendario': (context) => PantallaCalendario(),

        /*
        '/loginDep': (context) => LoginDep(),
        '/loginSup': (context) => LoginSup(),
        '/registroDep': (context) => RegistroDepAsociado(),
        '/registroSup': (context) => RegistroSupAsociado(),
        */
      },
         /*

         theme: ThemeData(
        // Para cambiar la animacion de cambio de pantalla
        pageTransitionsTheme: PageTransitionsTheme(builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        }),
        ),

          */
    );
  }
}


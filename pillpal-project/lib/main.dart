import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pillpal/pantallas/add_calendario_desdePastillero.dart';
import 'package:pillpal/pantallas/pantalla_alarmas.dart';
import 'package:pillpal/pantallas/pantalla_estadisticas.dart';
import 'package:pillpal/pantallas/pantalla_inicial.dart';

import 'package:pillpal/pantallas/pantalla_pastillero.dart';
import 'package:pillpal/pantallas/navigation_drawer.dart';
import 'package:pillpal/pantallas/pantallas_sesion/pantalla_configurarHorario.dart';
import 'package:pillpal/pantallas/pantallas_sesion/pantalla_login_asociado.dart';
import 'package:pillpal/pantallas/pantallas_sesion/pantalla_registro.dart';
import 'package:pillpal/pantallas/pantalla_calendario.dart';
import 'package:pillpal/pantallas/pantallas_sesion/pantalla_registro_asociado.dart';


import 'package:pillpal/pantallas/pantallas_sesion/pantalla_sesion.dart';
import 'package:pillpal/utils/alarms.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pillpal/utils/db_connections.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


Future<void> main() async {
  initDatabaseConnection();
  await alarms_class().initialize();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeDateFormatting().then((_) => runApp(MyApp()));
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
        '/calendario': (context) => PantallaCalendario(),
        '/alarmas' : (context) => AlarmaScreen(),
        '/estadisticas' : (context) => PantallaEstadisticas(),
        '/horario': (context) => ConfigurarHorario(),

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


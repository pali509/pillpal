import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/alarms.dart';
import '../../utils/db_connections.dart';
import '../../utils/user.dart';

class PantallaCargaSesion extends StatefulWidget {
  @override
  _PantallaCargaSesionState createState() => _PantallaCargaSesionState();
}

class _PantallaCargaSesionState extends State<PantallaCargaSesion> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLoginStatus();
    });
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');
    // Esperar 2 segundos para simular la carga
    await Future.delayed(Duration(seconds: 2));
    if (storedUsername != null && storedUsername.isNotEmpty) {
      // Navegar directamente a la pantalla principal si ya hay una sesión iniciada
      if (await getUserByEmail(storedUsername)) {
        Navigator.of(context).pushReplacementNamed('/home');
        alarms_class().cancelAll();
        alarms_class().cargarAlarmas(getUserId());
      }
    }
    else {
      // Si no hay sesión, navega a la pantalla de inicio de sesión
      Navigator.pushReplacementNamed(context, '/cuenta');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Container(
                width: 200,
                height: 150,
                child: Image.asset('android/app/src/assets/images/Logo.png'),
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

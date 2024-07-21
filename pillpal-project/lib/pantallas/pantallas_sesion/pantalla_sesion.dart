import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../utils/db_connections.dart';
import '../../utils/alarms.dart';
import 'package:pillpal/constants/colors.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


import '../../email.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<Login> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String? email, password;

  @override
  Widget build(BuildContext context) {
    String url = 'https://www.4shared.com/img/yVf4sXocge/s25/190c6dfef78/jojo'; // The download link
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    return Scaffold(
      backgroundColor: ColorsApp.backgroundColor,
      appBar: AppBar(
        title: const Text("Inicio de sesión"),
        backgroundColor: ColorsApp.toolBarColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
              child: Center(
                child: Container(
                  width: 200,
                  height: 150,
                  child: Image.network(url),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Correo electrónico',
                  hintText: 'Inserta en formato algo@gmail.com',
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Contraseña'
                ),
              ),
            ),

            Padding(
            padding: EdgeInsets.only(top: 30.0),
              child: Container(
                height: 50,
                width: 250,
                child: ElevatedButton(
                  onPressed: () async {
                    //getDayPills(DateTime(2024,3,3), 1);
                    email = _emailController.text;
                    password = _passwordController.text;
                    if (await checkUser(email!, password!)) {
                      Navigator.of(context).pushReplacementNamed('/home');
                      //await flutterLocalNotificationsPlugin.cancelAll();

                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Correo o contraseña incorrectas!')),
                      );
                      _emailController.clear();
                      _passwordController.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple, // Ajusta el color del fondo aquí
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Entrar',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 90.0),  // Ajusta el valor top según tus necesidades
              child: GestureDetector(
                onTap: () {
                  // Navegar a la nueva pantalla al pulsar el SizedBox
                  Navigator.of(context).pushReplacementNamed('/registro');
                },
                child: const SizedBox(
                  height: 130,
                  child: Text('Usuario nuevo? Crea una cuenta'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Libera los recursos de los controladores al cerrar el widget
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

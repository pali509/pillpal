import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../database/db_connections.dart';
import 'package:pillpal/constants/colors.dart';

import '../email.dart';
import '../main.dart';

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
                  child: Image.asset('asset/images/flutter-logo.png'),
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
                    email = _emailController.text;
                    password = _passwordController.text;
                    if (await checkUser(email!, password!)) {
                      Navigator.of(context).pushReplacementNamed('/home');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Correo o contraseña incorrectas!')),
                      );
                      _emailController.clear();
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
              padding: EdgeInsets.only(top: 20.0),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                    String correo = '';
                    return SimpleDialog(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12),
                      children: [
                        const SizedBox(height: 30),
                        const Text('Correo registrado:', style: TextStyle(fontSize: 20)),
                        TextFormField(
                          onChanged: (value) {
                            correo = value;
                          },
                        ),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            //alignment: Alignment.center, ???
                            backgroundColor: Colors.purple, // Ajusta el color del fondo aquí
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () async {
                            email = _emailController.text;
                            //String? pwd = await getPassword(email) as String?;
                            String? pwd = "d";
                            if(pwd == null){
                              //Enseñar mensaje: Su usuario no está registrado.
                            }
                            else{
                              sendPassword(email, pwd);
                            }
                            /*await supabase.auth.signInWithOtp( //tiene que ser otra cosa, esto es para enviar link
                              email: correo,

                            );
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Contraseña enviada por correo')),
                              );*/
                            _emailController.clear();
                            //}
                            Navigator.of(context).pop();
                          },
                          child: Text('Recuperar contraseña'),
                        ),
                      ],
                    );
                  },
                  );
                },
                child: const SizedBox(
                  height: 30,
                  child: Text('He olvidado mi contraseña'),
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

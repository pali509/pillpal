import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../database/db_connections.dart';

class Registro extends StatefulWidget {
  const Registro({Key? key}) : super(key: key);

  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  @override
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nombreController = TextEditingController();
  String? email, password, nombre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Nueva Cuenta"),
        backgroundColor: ColorsApp.toolBarColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding:EdgeInsets.only(left: 15, right:15, top:40),
              child: TextField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nombre',
                  hintText: 'Tu nombre de usuario',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, right:15, top:30),
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Enter valid email id as abc@gmail.com',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 35.0, bottom: 0),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter secure password',
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
                    // Guarda el texto de los campos en las variables email y password
                    email = _emailController.text;
                    password = _passwordController.text;
                    nombre = _nombreController.text;
                    if(await userExists(email!)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Correo o contraseña incorrectas!')),
                      );

                    } else{
                      await insertUser(nombre!, email!, password!);
                      // Navega a la pantalla '/home' con los datos ingresados
                      Navigator.of(context).pushReplacementNamed('/home');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple, // Ajusta el color del fondo aquí
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Crear cuenta',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }




}
import 'package:flutter/material.dart';

import '../database/db_connections.dart';

class LoginDemo extends StatefulWidget {
  const LoginDemo({Key? key}) : super(key: key);

  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String? email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
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
                  labelText: 'Email',
                  hintText: 'Enter valid email id as abc@gmail.com',
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
                  labelText: 'Password',
                  hintText: 'Enter secure password',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: FORGOT PASSWORD SCREEN GOES HERE
              },
              child: const Text(
                'Forgot Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ElevatedButton(
                onPressed: () async {
                  // Guarda el texto de los campos en las variables email y password
                  email = _emailController.text;
                  password = _passwordController.text;
                  if(await checkUser(email!, password!)) {
                    // Navega a la pantalla '/home' con los datos ingresados
                    Navigator.of(context).pushReplacementNamed('/home');
                  } else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Correo o contraseña incorrectas!')),
                    );
                    _emailController.clear();
                  }
                },
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            const SizedBox(
              height: 130,
            ),
            Text('New User? Create Account'),
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

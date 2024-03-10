import 'package:flutter/material.dart';
import 'package:pillpal/utils/user.dart';
import 'package:pillpal/pantallas/pantallas_sesion/pantalla_login_asociado.dart';

import '../../constants/colors.dart';
import '../../utils/db_connections.dart';

class RegistroAs extends StatefulWidget {
  final int id_asociado;
  const RegistroAs({Key? key, required this.id_asociado}) : super(key: key);

  @override
  _RegistroAsState createState() {
    return _RegistroAsState(this.id_asociado);
  }
}

class _RegistroAsState extends State<RegistroAs> {
  int id_asociado;
  _RegistroAsState(this.id_asociado);

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
          title: const Text("Nueva Cuenta de Supervisor"),
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
                    labelText: 'Correo',
                    hintText: 'Inserta un correo valido como abc@gmail.com',
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
                    labelText: 'Contraseña',
                    hintText: 'Inserta una contraseña segura',
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 50.0),
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

                      } else {
                        int rol = await getRolId(id_asociado); //Rol de el que creo la primera cuenta
                        if (rol == 2) { //dependiente
                          await insertUser(nombre!, email!, password!, 1, 2); //1 porque es supervisor
                          addRelationship(id_asociado, id_asociado);
                        }
                        else {
                          await insertUser(nombre!, email!, password!, 2, 2);
                          int id = await getUsId(email!); //id de el asociado
                          addRelationship(id_asociado, id);
                          // Navega a la pantalla '/home' con los datos ingresados
                          Navigator.of(context).pushReplacementNamed('/home');
                        }
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
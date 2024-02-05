import 'package:flutter/material.dart';
import 'package:pillpal/database/user.dart';

import '../../constants/colors.dart';
import '../../database/db_connections.dart';

class RegistroDepAsociado extends StatefulWidget {
  final int id_asociado;
  const RegistroDepAsociado({Key? key, required this.id_asociado}) : super(key: key);

  @override
  _DepAsociadoState createState() {
    return _DepAsociadoState(this.id_asociado);
  }

}

class _DepAsociadoState extends State<RegistroDepAsociado> {
  int id_asociado;
  _DepAsociadoState(this.id_asociado);

  @override
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nombreController = TextEditingController();
  String? email, password, nombre;




  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RegistroDepAsociado(id_asociado: getUserId())));
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Nueva Cuenta Dependiente"),
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

                      } else{
                        await insertUser(nombre!, email!, password!, 2); //2 porque es dependiente

                        //FALTA CAMBIAR EL USER_ASOCIADO DE EL OTRO USER!

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
      ),
    );
  }





}
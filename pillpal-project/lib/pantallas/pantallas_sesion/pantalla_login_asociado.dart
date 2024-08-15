import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pillpal/utils/user.dart';
import 'package:pillpal/pantallas/pantallas_sesion/pantalla_registro_asociado.dart';

import '../../utils/db_connections.dart';

import 'package:pillpal/constants/colors.dart';

import '../../email.dart';

class LoginAs extends StatefulWidget {
  final int id_asociado;
  final int op;
  const LoginAs({Key? key, required this.id_asociado, required this.op}) : super(key: key);

  @override
  _LoginAsState createState() {
    return _LoginAsState(this.id_asociado, this.op);
  }
}

class _LoginAsState extends State<LoginAs> {
  int id_asociado;
  int op;
  _LoginAsState(this.id_asociado, this.op);

  @override
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String? email, password;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(op !=1)
          await deleteUser(id_asociado);
        return true;
      },
      child: Scaffold(
        backgroundColor: ColorsApp.backgroundColor,
        appBar: AppBar(
          title: const Text("Vincular usuario asociado"),
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
              //const SizedBox(height: 30.0),
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
                      if (await userExists(email!) && (await correctPwd(email!, password!))) {
                        //Asociar en la BD a este usuario con el dependiente
                        int rol = await getRolId(id_asociado); //Rol de el que creo la primera cuenta
                        int id = await getUsId(email!); //id de el asociado
                        //int rol = await getRolId(id);
                        debugPrint('ID: ${getUserId()}');
                        debugPrint('ID asociado: ${id}');
                        debugPrint('ROL:$rol');
                        if(rol == 2) {
                          await addRelationship(id, getUserId());
                          Navigator.of(context).pushReplacementNamed('/horario');
                        }
                        else {
                          await addRelationship(getUserId(), id);
                          setUserAsociadoSoloId(id);
                          Navigator.of(context).pushReplacementNamed('/home');
                        }

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

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistroAs(id_asociado: id_asociado)));
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

import 'package:flutter/material.dart';
import 'package:pillpal/database/user.dart';
import 'package:pillpal/pantallas/pantallas_sesion/pantalla_login_asociado.dart';


import '../../constants/colors.dart';
import '../../database/db_connections.dart';

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
  String? rol;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pushReplacementNamed('/cuenta');
          return true;
        },
    child: Scaffold(
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
            const Padding(
              padding: EdgeInsets.only(left: 0, right: 335, top: 35.0, bottom: 0),
              child: Text("Rol",
                  style: TextStyle(fontSize: 18.0)
              ),

            ),

             Padding(
              padding: EdgeInsets.only(left: 15, right: 200, top: 15.0, bottom: 0),
              child:DropdownMenu<String>(
                  onSelected: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      rol = value!;
                    });
                  },
                  dropdownMenuEntries: ['Autosuficiente', 'Dependiente', 'Supervisor'].map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(value: value, label: value);
                  }).toList(),
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
                    if(email != null && password != null && nombre != null && rol != null) {
                      if (await userExists(email!)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text(
                              'Correo o contraseña incorrectas!')),
                        );
                      } else {

                        if(rol == 'Autosuficiente') {
                          await insertUser(nombre!, email!, password!, rolAint(rol));
                          // Navega a la pantalla '/home' con los datos ingresados
                          int id = await getUsId(email!);
                          addRelationship(id, id); //Le añade como cuidador de si mismo
                          Navigator.of(context).pushReplacementNamed('/home');
                        }
                        else if(rol == 'Dependiente'||rol == 'Supervisor') {
                          await insertUser(nombre!, email!, password!, rolAint(rol));
                          // Navega a la pantalla con los datos ingresados
                          debugPrint("$getUserEmail()");
                          int id = await getUsId(email!);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginAs(id_asociado: id)));
                        }
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
    ),
    );
  }

  int rolAint(String? rol) {
    if(rol == 'Dependiente')
      return 2;
    else if(rol == 'Autosuficiente')
      return 0;
    else
      return 1;
  }




}
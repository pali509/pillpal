


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pillpal/utils/user.dart';

import '../constants/colors.dart';

class PantallaPerfil extends StatefulWidget {
  const PantallaPerfil({super.key});

  @override
  _PantallaPerfilState createState() => _PantallaPerfilState();
}
class _PantallaPerfilState extends State<PantallaPerfil> {
  String name = getUserName();
  String correo = getUserEmail();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsApp.toolBarColor,
          title: const Text(
            'Perfil',
            style: TextStyle(fontSize: 25.0),
          ),
        ),
      body: Column(
       crossAxisAlignment: CrossAxisAlignment.center,

        children: [
        const SizedBox(height: 30.0),
          const Text(
            'Tu perfil',
            style: TextStyle(fontSize: 30.0)
          ),
          const SizedBox(height: 20.0),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.black, width: 1),
            ),
            child: Column(
              children:[
                const SizedBox(height: 10.0),
              const Text(
                'Información de usuario:',
                style: TextStyle(fontSize: 20.0),
              ),
              const SizedBox(height: 20.0),

              Row(
                children: [
                  const Text(
                  '     Nombre usuario:', style: TextStyle(fontSize: 15.0),
                  ),
                  const SizedBox(width: 30.0),
                  Text(
                    '$name', style: TextStyle(fontSize: 15.0),
                  ),
                ],
              ),

              const SizedBox(height: 10.0),

              Row(
                 children: [
                 const Text(
                   '     Correo electrónico:', style: TextStyle(fontSize: 15.0),
                 ),
                 const SizedBox(width: 30.0),
                 Text(
                   '$correo', style: TextStyle(fontSize: 15.0),
                  ),
                 ],
              ),
              const SizedBox(height: 15.0),

              ElevatedButton(
                onPressed: () {
                showDialog(
                context: context,
                builder: (context) {
                  String nuevoName;
                  String nuevoCorreo;
                  return SimpleDialog(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      children: [
                      const SizedBox(height: 20),
                         const Text('Editar nombre:'),
                         TextFormField(
                          initialValue: name,
                           onChanged: (value) {
                            nuevoName = value;
                           },
                         ),
                         const SizedBox(height: 15),
                         const Text('Editar correo:'),
                         TextFormField(
                          initialValue: correo,
                           onChanged: (value) {
                           nuevoCorreo = value;
                           },
                         ),

                         const SizedBox(height: 20),

                         ElevatedButton(
                           onPressed: () async {
                            //TODO
                           setState(() {});
                           Navigator.of(context).pop();
                         },
                         child: Text('Guardar cambios'),
                         style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.blue,
                         shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(20),
                         ),
                         textStyle: const TextStyle(
                         fontSize: 15,
                         fontWeight: FontWeight.bold,
                         ),
                         ),
                         ),
                      ],
                    );
                  },
                );
                },
                child: Text('Editar Información'),
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  ),
                  ),
              ),
                const SizedBox(height: 10.0),
              ],
            ),
          ),
          const SizedBox(height: 20.0),

          Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.black, width: 1),
            ),
            child: Column(
              children:[
                   Text(
                     'Usuario seleccionado:',
                     style: TextStyle(fontSize: 20.0),
                   ),
                const SizedBox(height: 15.0),
                //TODO poder hacer un getUser(userSeleccionadoId) y meterlo en un Text

                const SizedBox(height: 15.0),
                Text(
                  'Horario establecido:',
                  style: TextStyle(fontSize: 18.0),
                ),
                Divider(
                  height: 10.0, // Set a small height for the line
                  color: Colors.black, // Set the line color
                  thickness: 1.0, // Optional: Set line thickness (defaults to 1.0)
                ),
                Text(
                  'Desayuno:  ',
                  style: TextStyle(fontSize: 15.0),
                ),
                const Divider(
                  height: 10.0, // Set a small height for the line
                  color: Colors.black, // Set the line color
                  thickness: 1.0, // Optional: Set line thickness (defaults to 1.0)
                ),
                Text(
                  'Comida: ',
                  style: TextStyle(fontSize: 15.0),
                ),
                const Divider(
                  height: 10.0, // Set a small height for the line
                  color: Colors.black, // Set the line color
                  thickness: 1.0, // Optional: Set line thickness (defaults to 1.0)
                ),
                Text(
                  'Cena:  ',
                  style: TextStyle(fontSize: 15.0),
                ),
                const Divider(
                  height: 10.0, // Set a small height for the line
                  color: Colors.black, // Set the line color
                  thickness: 1.0, // Optional: Set line thickness (defaults to 1.0)
                ),
                Text(
                  'Dormir:  ',
                  style: TextStyle(fontSize: 15.0),
                ),
                ],
            ),
          ),
          const SizedBox(height: 20.0),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.black, width: 1),
            ),
            child: Column(
              children:[
                const SizedBox(height: 10.0),
                const Text(
                  'Usuarios dependientes vinculados:',
                  style: TextStyle(fontSize: 20.0),
                ),
                const SizedBox(height: 20.0),
                /*TODO
                  Lista como la de pastillas (CARDS!!!)
                  Mostrar nombre y correo
                  Icono a la derecha de editar
                   */
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {

                        return SimpleDialog(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                          children: [
                            const SizedBox(height: 20),
                            //La lista de dependientes pero con un seleccionador

                            const SizedBox(height: 20),

                            ElevatedButton(
                              onPressed: () async {
                                //TODO
                                setState(() {});
                                Navigator.of(context).pop();
                              },
                              child: Text('Confirmar'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Cambiar usuario seleccionado'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),
              ],
            ),
          ),
          /*
          Cosas que queremos que aparezcan:

          HECHAS:
          Informacion usuario:
            Nombre usuario
            Correo
            Botón editar informacion usuario

          TODO:
          Centrar usuario y correo
          Que editar info la edite de verdad xd
          Informacion dependientes:
            Sus nombres y sus correos
            Boton editar informacion -> Que haga cosas
          Informar de que dependiente se esta mirando ahora
          Horario establecido -> Meterle las llamadas de las funciones
          Boton para cambiarlo -> Ver como lo pongo
          Boton cambiar dependiente -> Que haga cosas

          Boton cerrar sesion
          Boton eliminar cuenta
           */
      ],
    ),
    );
  }

}

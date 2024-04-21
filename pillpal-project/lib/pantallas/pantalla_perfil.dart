
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pillpal/utils/db_connections.dart';
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
  Future<List<String>> userAsociado = getUser(getUserAsociadoId());
  Future<List<List<String>>>? listaUsers = getAsociados(getUserId());
  List<String> datosAsociado =[];
  List<List<String>> users = [];
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
      body:SingleChildScrollView(
        child: Column(
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
                  String nuevoName = name;
                  String nuevoCorreo = correo;
                  String nuevaCont = "";
                  bool cont = false;
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
                          const SizedBox(height: 15),
                          const Text('Cambiar contraseña:'),
                          TextFormField(
                          initialValue: nuevaCont,
                          onChanged: (value) {
                            cont = true;
                            nuevaCont = value;
                          },
                         ),

                         const SizedBox(height: 20),
                        Row(
                          children:[
                            ElevatedButton(
                              onPressed: () async {
                                if(cont)
                                  updateUser(getUserId(), nuevoCorreo, nuevoName, nuevaCont);
                                else
                                  updateUser(getUserId(), nuevoCorreo, nuevoName, null);
                                setState(() {
                                  name = nuevoName;
                                  correo = nuevoCorreo;
                                  setUserEmail(correo);
                                  setUserName(name);
                                });
                                Navigator.of(context).pop();
                              },
                              child: Text('Guardar cambios'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 45.0),
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancelar'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
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

          Visibility(
            visible: getRoleId() != 1,
              child:  Column(
                children: [
                const SizedBox(height: 20.0),

                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black, width: 1),
                  ),
                  child: Column(
                    children:[

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
                        'Desayuno: ${getHoraDesayuno()} ',
                        style: TextStyle(fontSize: 15.0),
                      ),
                      const Divider(
                        height: 10.0, // Set a small height for the line
                        color: Colors.black, // Set the line color
                        thickness: 1.0, // Optional: Set line thickness (defaults to 1.0)
                      ),
                      Text(
                        'Comida: ${getHoraComida()}',
                        style: TextStyle(fontSize: 15.0),
                      ),
                      const Divider(
                        height: 10.0, // Set a small height for the line
                        color: Colors.black, // Set the line color
                        thickness: 1.0, // Optional: Set line thickness (defaults to 1.0)
                      ),
                      Text(
                        'Cena:   ${getHoraCena()}',
                        style: TextStyle(fontSize: 15.0),
                      ),
                      const Divider(
                        height: 10.0, // Set a small height for the line
                        color: Colors.black, // Set the line color
                        thickness: 1.0, // Optional: Set line thickness (defaults to 1.0)
                      ),
                      Text(
                        'Dormir:  ${getHoraDormir()}',
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20.0),
                ],
              ),
          ),

          Visibility(
            visible: getRoleId() == 1,
            child: Column(
              children: [
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

                      FutureBuilder(
                          future: userAsociado,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(child: Text(
                                  'No hay usuario asociado.'));
                            } else {
                              datosAsociado = snapshot.data!;
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: 1,
                                itemBuilder: (context, index) {
                                  return Card(
                                    clipBehavior: Clip.hardEdge,
                                    child: InkWell(
                                      splashColor: Colors.grey,
                                      child: ListTile(
                                        leading: Icon(Icons.account_circle_sharp),
                                        title: Text('Nombre: ${datosAsociado[1]}'),
                                        subtitle: Text('Correo: ${datosAsociado[2]}'),
                                        trailing: IconButton(
                                          icon: Icon(Icons.edit),
                                          color: Colors.black,
                                          onPressed: () {
                                          showDialog(
                                          context: context,
                                          builder: (context) {
                                            String nuevoName = datosAsociado[1];
                                            String nuevoCorreo = datosAsociado[2];
                                            String nuevaCont = "";
                                            return SimpleDialog(
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                              children: [
                                                const SizedBox(height: 20),
                                                const Text('Editar nombre:'),
                                                TextFormField(
                                                  initialValue: datosAsociado[1],
                                                  onChanged: (value) {
                                                    nuevoName = value;
                                                  },
                                                ),
                                                const SizedBox(height: 15),
                                                const Text('Editar correo:'),
                                                TextFormField(
                                                  initialValue: datosAsociado[2],
                                                  onChanged: (value) {
                                                    nuevoCorreo = value;
                                                  },
                                                ),
                                                const SizedBox(height: 15),
                                                const Text('Cambiar contraseña:'),
                                                TextFormField(
                                                  initialValue: nuevaCont,
                                                  onChanged: (value) {
                                                    nuevaCont = value;
                                                  },
                                                ),

                                                const SizedBox(height: 20),
                                                Row(
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        updateUser(
                                                            getUserAsociadoId(), nuevoCorreo, nuevoName, nuevaCont);
                                                        setState(() {
                                                          userAsociado = getUser(getUserAsociadoId());
                                                          listaUsers = getAsociados(getUserId());
                                                        }); //Alomejor hay que poner aqui name = nuevoName etc?
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text('Guardar cambios'),
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.green,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(20),
                                                        ),
                                                        textStyle: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 45.0),
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text('Cancelar'),
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.red,
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
                                                ),

                                              ],
                                            );
                                          },
                                          );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          }
                      ),

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
                        'Desayuno: ${getHoraDesayuno()} ',
                        style: TextStyle(fontSize: 15.0),
                      ),
                      const Divider(
                        height: 10.0, // Set a small height for the line
                        color: Colors.black, // Set the line color
                        thickness: 1.0, // Optional: Set line thickness (defaults to 1.0)
                      ),
                      Text(
                        'Comida: ${getHoraComida()}',
                        style: TextStyle(fontSize: 15.0),
                      ),
                      const Divider(
                        height: 10.0, // Set a small height for the line
                        color: Colors.black, // Set the line color
                        thickness: 1.0, // Optional: Set line thickness (defaults to 1.0)
                      ),
                      Text(
                        'Cena:   ${getHoraCena()}',
                        style: TextStyle(fontSize: 15.0),
                      ),
                      const Divider(
                        height: 10.0, // Set a small height for the line
                        color: Colors.black, // Set the line color
                        thickness: 1.0, // Optional: Set line thickness (defaults to 1.0)
                      ),
                      Text(
                        'Dormir:  ${getHoraDormir()}',
                        style: TextStyle(fontSize: 15.0),
                      ),
                      /*
                      TODO: BOTON EDITAR HORARIO
                       */

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

                      FutureBuilder(
                          future: listaUsers,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(child: Text(
                                  'No hay ningún medicamento registrado.'));
                            } else {
                              users = snapshot.data!;
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: users.length,
                                itemBuilder: (context, index) {
                                  List<String> currentUser = users[index];

                                  return Card(
                                    clipBehavior: Clip.hardEdge,
                                    child: InkWell(
                                      splashColor: Colors.grey,
                                      child: ListTile(
                                        leading: Icon(Icons.account_circle_sharp),
                                        title: Text('Nombre: ${currentUser[1]}'),
                                        subtitle: Text('Correo: ${currentUser[2]}'),
                                        trailing: IconButton(
                                          icon: Icon(Icons.edit),
                                          color: Colors.black,
                                          onPressed: () {

                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                String nuevoName = currentUser[1];
                                                String nuevoCorreo = currentUser[2];
                                                String nuevaCont = "";
                                                return SimpleDialog(
                                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                                  children: [
                                                    const SizedBox(height: 20),
                                                    const Text('Editar nombre:'),
                                                    TextFormField(
                                                      initialValue: currentUser[1],
                                                      onChanged: (value) {
                                                        nuevoName = value;
                                                      },
                                                    ),
                                                    const SizedBox(height: 15),
                                                    const Text('Editar correo:'),
                                                    TextFormField(
                                                      initialValue: currentUser[2],
                                                      onChanged: (value) {
                                                        nuevoCorreo = value;
                                                      },
                                                    ),
                                                    const SizedBox(height: 15),
                                                    const Text('Cambiar contraseña:'),
                                                    TextFormField(
                                                      initialValue: nuevaCont,
                                                      onChanged: (value) {
                                                        nuevaCont = value;
                                                      },
                                                    ),

                                                    const SizedBox(height: 20),
                                                    Row(
                                                      children: [
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            updateUser(
                                                                currentUser[0], nuevoCorreo, nuevoName, nuevaCont);
                                                            setState(() {
                                                              listaUsers = getAsociados(getUserId());
                                                              userAsociado = getUser(getUserAsociadoId());
                                                            }); //Alomejor hay que poner aqui name = nuevoName etc?
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: Text('Guardar cambios'),
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: Colors.green,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(20),
                                                            ),
                                                            textStyle: const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 45.0),
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: Text('Cancelar'),
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: Colors.red,
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
                                                    ),

                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          }
                          ),
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
                                  Text('Selecciona usuario a supervisar',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),),

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
              ],
            ),
          ),
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
                      Text('¿Estas seguro de querer cerrar sesión?'),
                      const SizedBox(height: 20),
                      Row(
                        children:[
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/cuenta');
                          },
                          child: Text('Confirmar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                          const SizedBox(width: 45.0),
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancelar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
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
                      ),
                    ],
                  );
                },
              );
            },
            child: Text('Cerrar sesión'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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
                      Text('¿Estas seguro de querer borrar tu cuenta?'),

                      const SizedBox(height: 20),
                      Row(
                        children:[
                          ElevatedButton(
                            onPressed: () async {
                              deleteUser(getUserId());
                              Navigator.of(context).pushReplacementNamed('/cuenta');
                              Navigator.of(context).pop();
                            },
                            child: Text('Confirmar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 45.0),
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancelar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
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
                      ),
                    ],
                  );
                },
              );
            },
            child: Text('Borrar cuenta'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 15.0),
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

          Boton cerrar sesion -> Que se vea mas bonito y no te deje ir hacia atras
          Boton eliminar cuenta -> Que se vea mas bonito
           */
      ],
    ),
    ),
    );
  }

}

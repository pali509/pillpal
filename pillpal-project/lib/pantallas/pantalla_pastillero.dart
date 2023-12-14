import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pillpal/database/db_connections.dart';
import 'package:pillpal/database/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pillpal/constants/colors.dart';

import '../database/pills.dart';
import 'navigation_drawer.dart';

class Pastillero extends StatefulWidget {
  Pastillero({super.key});
  @override
  State<Pastillero> createState() => PastilleroState();

}

class PastilleroState extends State<Pastillero>{

  //final pastillaStream = Supabase.instance.client.from('Pills').stream(primaryKey: ['pill_id']);
  int rol = getRoleId();


  Future<List<Pill>>? listaDePills = getPills(getUserId());
  List<Pill> pills = [];
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('Pastillero', style: TextStyle(fontSize: 25.0)),
        backgroundColor: ColorsApp.toolBarColor,
      ),
      drawer: MyDrawer(),
        body: FutureBuilder<List<Pill>>(
          future: listaDePills,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No hay datos disponibles.'));
            } else {
              pills = snapshot.data!;

              return ListView.builder(
                itemCount: pills.length,
                itemBuilder: (context, index) {
                  Pill currentPill = pills[index];

                  return Card(
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      splashColor: Colors.grey,
                      onTap: () {
                        debugPrint('Card tapped.');
                        Navigator.of(context).pushReplacementNamed('/infoMed');
                      },
                      child: ListTile(
                        leading: Icon(Icons.add_a_photo_rounded),
                        title: Text(' ${currentPill.pillName}'),
                        subtitle: Text('Cantidad: ${currentPill.numPills} ud.'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.redAccent,
                          onPressed: () {
                            _showDeleteConfirmationDialog(context, currentPill);
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),

        //Boton para añadir pastis

      floatingActionButton:
      Padding(
        padding: EdgeInsets.only(left: 30.0, top: 750.0),
        // Ajusta este valor según tus necesidades
        child: Center(
          child: Visibility(
            visible: (rol != 2),
            child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  String pillName = '';
                  int numberOfPills = 0;

                  return SimpleDialog(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    children: [
                      const SizedBox(height: 20),
                      const Text('Nombre:'),
                      TextFormField(
                        onChanged: (value) {
                          pillName = value;
                        },
                      ),
                      const SizedBox(height: 15),
                      const Text('Núm. pastillas:'),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          numberOfPills = int.tryParse(value) ?? 0;
                        },
                      ),

                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          insertPills(pillName, numberOfPills, getUserId());
                          listaDePills = getPills(getUserId());
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                        child: Text('Añadir medicación'),
                      ),

                    ],
                  );
                },
              );
            },
            child: Text('Añadir Medicación'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              textStyle: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ),
        ),
      ),

    );
  }



// Función para mostrar el diálogo de confirmación de eliminación
  void _showDeleteConfirmationDialog(BuildContext context, Pill pill) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('¡Cuidado!'),
          content: const Text(
            'Esta acción eliminaría el medicamento seleccionado de la planificación. ¿Quieres continuar?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Cancelar'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.purple,
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                deletePill(pill);
                listaDePills = getPills(getUserId());
                setState(() {});
                // Cerrar el diálogo después de realizar la acción
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
  }
}

/*
          child: Container(
            width: 250, // Ajusta el ancho del botón
            height: 50, //El largo
            alignment: Alignment.center,
            child: const Text(
              'Añadir medicación',
              textAlign: TextAlign.center, // Centra el texto horizontalmente
              style: TextStyle(fontSize: 20), // Ajusta el tamaño del texto
            ),
          ),
      */

/*
 floatingActionButton: Padding(
          padding: EdgeInsets.only(left: 30.0, top:750.0), // Ajusta este valor según tus necesidades
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    String pillName = '';
                    int numberOfPills = 0;

                    return SimpleDialog(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      children: [
                        const SizedBox(height: 20),
                        const Text('Nombre:'),
                        TextFormField(
                          onChanged: (value) {
                            pillName = value;
                          },
                        ),
                        const SizedBox(height: 15),
                        const Text('Núm. pastillas:'),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            numberOfPills = int.tryParse(value) ?? 0;
                          },
                        ),

                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              insertPills(pillName, numberOfPills, getUserId());
                              listaDePills = getPills(getUserId());
                              setState(() {});
                              Navigator.of(context).pop();
                            },
                            child: Text('Añadir medicación'),
                          ),

                      ],
                    );
                  },
                );
              },
              child: Text('Añadir Medicación'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                textStyle: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ),
   */

/*TODO
-Boton añadir -> No se centra :(
-Pastillas -> Imagen y boton para eliminar pastilla
-Num Pastillas -> Que sea modificable (?????)
 */
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

                return ListTile(
                  title: Text(' ${currentPill.pillName}'),
                  subtitle: Text('Cantidad: ${currentPill.numPills}'),
                );

              },
            );
          }
        },
      ),

      //Boton para añadir pastis

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
                          child: Text('Añadir pastilla'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Añadir Medicación'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                textStyle: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ),


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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pastillero', style: TextStyle(fontSize: 25.0)),
        backgroundColor: ColorsApp.toolBarColor,),
      drawer: const MyDrawer(),

      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: pastillaStream,
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return const Center(child: CircularProgressIndicator());
          }
          final pastillas = snapshot.data!;
          return Container(
            constraints: const BoxConstraints(maxHeight: 650),

            child: ListView.builder(
            shrinkWrap: true,
            itemCount: pastillas.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  const Divider( // Separador entre las pastillas
                    height: 20, // Espacio entre cada pastilla
                    color: ColorsApp.listElementDividerColor, // Color transparente para el Divider
                  ),
                  Container(
                    padding: const EdgeInsets.all(10), // Espacio alrededor de cada pastilla
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorsApp.listElementBorderColor), // Borde alrededor de cada pastilla
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pastillas[index]['pill_name'],
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20, width: 200),
                        Text("Num. Pastillas: ${pastillas[index]['pill_quantity']}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          );
        },
      ),

      //Boton para añadir pastis
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child:ElevatedButton(
          onPressed: (){
            showDialog(context: context,
              builder: (context){
                String pillName = ''; // Variable para almacenar el nombre de la pastilla
                int numberOfPills = 0; // Variable para almacenar el número de pastillas

              return SimpleDialog(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  const SizedBox(height: 20),
                  const Text('Nombre:'),
                  TextFormField(
                    onChanged: (value) {
                      pillName = value; // Actualiza el nombre de la pastilla al escribir en el campo
                    },
                  ),
                  const SizedBox(height: 15), // Agrega un espacio entre los campos
                  const Text('Núm. pastillas:'), // Título para el siguiente campo
                  TextFormField(
                    keyboardType: TextInputType.number, // Teclado para ingresar solo números
                    onChanged: (value) {
                      numberOfPills = int.tryParse(value) ?? 0; // Actualiza el número de pastillas
                    },

                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      // Realiza la acción al presionar el botón
                      insertPills(pillName, numberOfPills, 1); //Ahora es 1 userId pero luego hay que cambiarlo
                      Navigator.of(context).pop(); // Cierra el diálogo después de insertar
                    },
                    child: Text('Añadir pastilla'),
                  ),
                ],
              );
              },
            );
            },

          child: Container(
                width: 250, // Ajusta el ancho del botón
                height: 50, //El largo
                alignment: Alignment.center,
                color: ColorsApp.buttonColor,
                child: const Text(
                  'Añadir medicación',
                  textAlign: TextAlign.center, // Centra el texto horizontalmente
                  style: TextStyle(fontSize: 20), // Ajusta el tamaño del texto
                ),
          ),
        ),
      ),

    );
  }

   */

/*TODO
-Boton añadir -> No se centra :(
-Pastillas -> Imagen y boton para eliminar pastilla
-Num Pastillas -> Que sea modificable (?????)
 */
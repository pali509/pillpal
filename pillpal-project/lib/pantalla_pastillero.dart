import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'navigation_drawer.dart';

class Pastillero extends StatefulWidget {
  Pastillero({super.key});
  @override
  State<Pastillero> createState() => PastilleroState();

}

class PastilleroState extends State<Pastillero>{

  final pastillaStream =
  Supabase.instance.client.from('Pills').stream(primaryKey: ['pill_id']);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pastillero', style: TextStyle(fontSize: 25.0)),
        backgroundColor: Colors.lightGreen,),
      drawer: MyDrawer(),

      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: pastillaStream,
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return const Center(child: CircularProgressIndicator());
          }
          final pastillas = snapshot.data!;
          return Container(
              constraints: BoxConstraints(maxHeight: 650),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: pastillas.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  const Divider( // Separador entre las pastillas
                    height: 20, // Espacio entre cada pastilla
                    color: Colors.transparent, // Color transparente para el Divider
                  ),
                  Container(
                    padding: EdgeInsets.all(10), // Espacio alrededor de cada pastilla
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey), // Borde alrededor de cada pastilla
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pastillas[index]['pill_name'],
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20, width: 200),
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
      floatingActionButton: ElevatedButton(
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
                      await Supabase.instance.client.from('Pills').insert({
                        'pill_name': pillName,
                        'pill_quantity': numberOfPills,
                      });
                      Navigator.of(context).pop(); // Cierra el diálogo después de insertar
                    },
                    child: Text('Añadir pastilla'),
                  ),
                ],
              );
            },
          );
        },
        child: Text('Añadir medicación'),
      ),


    );
  }
}

/*
-Mas bonito lo de añadir -> Boton grande y centrado
-Que las pastillas las ponga centradas y mas grande -> Casi! 
-Que muestre num pastillas
-La key va siempre ascendente aunque borre la nueva fila???
-Que se actualice automaticamente
 */
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pillpal/pantallas/pantalla_perfil.dart';
import 'package:pillpal/utils/db_connections.dart';
import 'package:pillpal/utils/user.dart';
import 'package:pillpal/pantallas/add_calendario_desdePastillero.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pillpal/constants/colors.dart';

import '../utils/pills.dart';
import 'navigation_drawer.dart';

class Pastillero extends StatefulWidget {
  Pastillero({super.key});
  @override
  State<Pastillero> createState() => PastilleroState();

}

class PastilleroState extends State<Pastillero>{

  //final pastillaStream = Supabase.instance.client.from('Pills').stream(primaryKey: ['pill_id']);
  int rol = getRoleId();
  List<String>tipo = ["Pastillas", "Sobres", "Gotas", "Jarabe", "Otro:"];
  String? valorSeleccionadoTipo;
  String type = "";
  String? _opcionSeleccionada;

  Future<List<Pill>>? listaDePills = getPills(getUserAsociadoId());

  List<Pill> pills = [];

  void _actualizar(){
    setState(() {});
  }
  void _mostrarPopEdicionPastilla(BuildContext context, Pill pasti) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(

          // Utilizar StatefulBuilder para gestionar el estado
          builder: (context, setState) {
            final _NameController = TextEditingController(text: pasti.pillName);
            final _NumPillController = TextEditingController(text: pasti.numPills.toString());
            final _TypeController = TextEditingController(text: pasti.type);

            return AlertDialog(
              title: const Text('Editar Medicamento'),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _NameController,
                      decoration: const InputDecoration(
                          labelText: 'Nombre'),
                    ),
                    TextField(
                      controller: _NumPillController,
                      decoration: const InputDecoration(
                          labelText: 'Cantidad disponible'),
                    ),
                    ListTile(
                      title: const Text("Tipo"),
                      trailing: DropdownButton<String>(
                        value: _opcionSeleccionada,
                        items: const [
                          DropdownMenuItem<String>(
                            value: "Pastillas",
                            child: Text('Pastillas'),
                          ),
                          DropdownMenuItem<String>(
                            value: "Sobres",
                            child: Text('Sobres'),
                          ),
                          DropdownMenuItem<String>(
                            value: "Gotas",
                            child: Text("Gotas"),
                          ),
                          DropdownMenuItem<String>(
                            value: "Jarabe",
                            child: Text('Jarabe'),
                          ),
                          DropdownMenuItem<String>(
                            value: "Otro:",
                            child: Text('Otro:'),
                          ),
                        ],
                        onChanged: (String? nuevoValor) {
                          setState(() {
                            _opcionSeleccionada = nuevoValor!;
                          });
                        },
                      ),
                    ),
                    Visibility(
                        visible: (_opcionSeleccionada == "Otro:"),
                        child: SizedBox(
                            height: 130.0,
                            child: Scaffold(
                              body: Center(
                                // Adjust the value as needed
                                child: TextField(
                                  controller: _TypeController,
                                  decoration: const InputDecoration(),
                                ),
                              ),
                            )
                        )

                    ),

                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Guardar'),
                  onPressed: () async {
                    if(_opcionSeleccionada != null) {
                      if (_opcionSeleccionada == "Otro:")
                        pasti.type = _TypeController.text;
                      else
                        pasti.type = _opcionSeleccionada;
                    }
                    pasti.pillName = _NameController.text;
                    pasti.numPills = int.parse(_NumPillController.text);
                    await updatePills(pasti.pillName!, pasti.numPills!, pasti.userId!, pasti.type!, pasti.pillId!);
                    listaDePills = getPills(getUserAsociadoId());
                    setState(() {});
                    Navigator.of(context).pop();
                    _actualizar();
                  },
                ),
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar el pop-up de edición
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _popUpPhoto() {

  }

  void _mostrarInformacionPastilla(BuildContext context, Pill pasti) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(pasti.pillName!),
          content: Wrap( // Envuelve el contenido en una columna
            direction: Axis.horizontal, // Limita el tamaño de la columna
            children: <Widget>[
              Text("Cantidad: ${pasti.numPills!}", style: TextStyle(fontSize: 16.0)),
              // Muestra la descripción
              Text('Tipo de medicación: ${pasti.type}', style: TextStyle(fontSize: 16.0)),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  child: Text('Editar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _mostrarPopEdicionPastilla(context, pasti);
                  },
                ),
                Spacer(), // Añadir Spacer para distribuir el espacio
                TextButton(
                  child: Text('Aceptar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Widget imageDialog(text, path, context) {
    return Dialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$text',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close_rounded),
                  color: Colors.redAccent,
                ),
              ],
            ),
          ),
          Container(
            width: 200,
            height: 200,
            child: Image.network(
              '$path',
               fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pastillero', style: TextStyle(fontSize: 25.0)),
        backgroundColor: ColorsApp.toolBarColor,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () =>  {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PantallaPerfil()),
              ),
            }, // Define button action
          ),
        ],
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
              return const Center(child: Text('Añade un medicamento para comenzar a usar la aplicación.'
              ,textAlign: TextAlign.center,style: TextStyle(fontSize: 16)));
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
                        _mostrarInformacionPastilla(context, currentPill);
                      },
                      child: ListTile(
                        leading: IconButton(
                          icon: Image.network(currentPill.url!),
                          //Image.network(currentPill.url!),
                          //Icon(Icons.add_a_photo_rounded),
                          onPressed: () async {
                            await showDialog(
                                context: context,
                                builder: (_) => imageDialog(currentPill.pillName, currentPill.url, context)
                            );
                            //Ver la imagen/subir nueva imagen en pop up
                          },
                        ),
                        title: Text(' ${currentPill.pillName}'),
                        subtitle: Text('Cantidad: ${currentPill.numPills} ud.'),
                        trailing:
                          Visibility(
                            visible: (getRoleId() != 2),
                            child:IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.redAccent,
                            onPressed: () {
                              _showDeleteConfirmationDialog(context, currentPill);
                            },
                          ),
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
                      const Text('Núm. dosis:'),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          numberOfPills = int.tryParse(value) ?? 0;
                        },
                      ),
                      const Text('Tipo de medicación:', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 16, height: 50),
                      Row(
                        children: [
                          DropdownButton<String>(
                            value: valorSeleccionadoTipo,
                            items: tipo.map((opcion) => DropdownMenuItem(
                              value: opcion,
                              child: Text(opcion),
                            )).toList(),
                            onChanged: (valor) {
                              setState((){
                                valorSeleccionadoTipo = valor;
                              });
                            },
                          ),
                        ],
                      ),
                      Visibility(
                        visible: (valorSeleccionadoTipo == "Otro:"),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            TextFormField(
                              onChanged: (value) {
                                type = value;
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              if(pillName == '') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Por favor, rellena el campo de nombre'),
                                  ),
                                );
                              }
                              else if(valorSeleccionadoTipo == null){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Por favor, rellena el campo de tipo de medicación'),
                                  ),
                                );
                              }
                              else if(valorSeleccionadoTipo == 'Otro:' && type == ''){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Por favor, si el tipo es otro, introduzca el nombre'),
                                  ),
                                );
                              }
                              else {
                                if (valorSeleccionadoTipo != "Otro:")
                                  type = valorSeleccionadoTipo!;
                                insertPills(pillName, numberOfPills,
                                    getUserAsociadoId(), type);
                                //insertPills(pillName, numberOfPills,
                                //  getUserAsociadoId(), type);
                                listaDePills = getPills(getUserAsociadoId());
                                setState(() {});
                                Navigator.of(context).pop();
                              }
                            },
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
                            child: const Text('Añadir'),
                          ),
                          const SizedBox(width: 10.0), // Setting width to 0 effectively removes spacing
                          // Second button
                          ElevatedButton(
                            onPressed: () async {
                              if (pillName == '') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Por favor, rellena el campo de nombre'),
                                  ),
                                );
                              }
                              else if (valorSeleccionadoTipo == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Por favor, rellena el campo de tipo de medicación'),
                                  ),
                                );
                              }
                              else if (valorSeleccionadoTipo == 'Otro:' &&
                                  type == '') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Por favor, si el tipo es otro, introduzca el nombre'),
                                  ),
                                );
                              }
                              else {
                                if (valorSeleccionadoTipo != "Otro:")
                                  type = valorSeleccionadoTipo!;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        AddCalendarioDesdePastillero(
                                            nombreMed: pillName,
                                            numPastillas: numberOfPills,
                                            type: type))
                                );
                              }
                            },
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
                            child: const Text('Añadir y programar'),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
              child: Text('Añadir medicación'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
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
              onPressed: () async {
                await deletePill(pill);
                listaDePills = getPills(getUserAsociadoId());
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

/*TODO
-Boton añadir -> No se centra :(
-Pastillas -> Imagen y boton para eliminar pastilla
-Num Pastillas -> Que sea modificable (?????)
 */
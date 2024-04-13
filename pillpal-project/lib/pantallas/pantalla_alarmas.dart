import 'package:flutter/material.dart';
import 'package:pillpal/pantallas/pantalla_perfil.dart';
import 'package:pillpal/utils/alarma_type.dart';
import 'package:pillpal/utils/user.dart';

import '../constants/colors.dart';
import '../utils/alarms.dart';
import '../utils/db_connections.dart';
import '../utils/pills.dart';
import 'add_calendario.dart';
import 'navigation_drawer.dart';

class AlarmaScreen extends StatefulWidget {
  @override
  _AlarmaScreenState createState() => _AlarmaScreenState();
}

class _AlarmaScreenState extends State<AlarmaScreen> {
  Future<List<Alarma_type>> _alarmasFuturo = Future.value([]);

  @override
  void initState() {
    super.initState();
    _cargarAlarmas();
  }

  Future<void> _cargarAlarmas() async {
    setState(() {
      _alarmasFuturo = getAlarmas(getUserAsociadoId()); // Tu función para obtener datos
    });
  }

  void _showDeleteConfirmationDialog(BuildContext context, Alarma_type alarm) {
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
                deleteAlarm(alarm.getAlarmId()!);
                deleteAlarmBd(alarm.getId()!);
                _alarmasFuturo = getAlarmas(getUserAsociadoId());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alarmas'),
        backgroundColor: ColorsApp.toolBarColor,
      ),
      drawer: MyDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: FutureBuilder<List<Alarma_type>>(
              future: _alarmasFuturo,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final alarma = snapshot.data![index];
                      return ListTile(
                        leading: Icon(Icons.medication), // Icono a la izquierda
                        title: Text(alarma.getPillName()!), // Texto principal
                        trailing: IconButton(
                          icon: Icon(Icons.delete), // Icono a la derecha
                          onPressed: () {
                            _showDeleteConfirmationDialog(context, alarma);
                          },
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error al cargar alarmas: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCalendario()),
              );
            },
            child: Text('Añadir'),
          ),
        ],
      ),
    );
  }
}
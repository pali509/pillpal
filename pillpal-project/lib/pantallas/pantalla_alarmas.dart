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
                alarms_class().deleteAlarm(alarm.getAlarmId()!);
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

  String timeOfDayInfo(int time_of_day) {
    if(time_of_day == 0) {
      return "No pertenece a ninguna franja horaria";
    }
    else if(time_of_day == 1) {
     return "Franja de: Desayuno";
    }
    else if(time_of_day == 2) {
      return "Franja de: Comida";
    }
    else if(time_of_day == 3) {
      return "Franja de: Cena";
    }
    else{
      return "Franja de: Dormir";
    }
  }

  String getPeriodoInfo(int period) {
      if(period == 0) {
        return "diaria";
      }
      else if(period == 1) {
        return "personalizada";
      }
      else {
        return "una vez";
      }
  }

  void _mostrarPopEdicionAlarma(BuildContext context, Alarma_type alarma) {
    List<String>? alarm = alarma.getDay()?.split(" ");
    int? _opcionSeleccionada = alarma.timeOfDay;
    int? _periodo = alarma.period;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          // Utilizar StatefulBuilder para gestionar el estado
          builder: (context, setState) {
            final _NumPillController = TextEditingController(text: alarma.numPills.toString());
            final _DayController = TextEditingController(text: alarm?[0]);
            final _hourController = TextEditingController(text: alarma.getHour());

            return AlertDialog(
              title: const Text('Editar Recordatorio'),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _NumPillController,
                      decoration: const InputDecoration(
                          labelText: 'Dosis'),
                    ),
                    TextField(
                      controller: _DayController,
                      decoration: const InputDecoration(
                          labelText: 'Fecha (año-mes-dia'),
                          //keyboardType: TextInputType.datetime,
                    ),
                    TextField(
                      controller: _hourController,
                      decoration: const InputDecoration(labelText: 'Hora'),
                    ),
                    ListTile(
                      title: const Text("Franja horaria"),
                      trailing: DropdownButton<int>(
                        value: _opcionSeleccionada,
                        items: const [
                          DropdownMenuItem<int>(
                            value: 1,
                            child: Text('Desayuno'),
                          ),
                          DropdownMenuItem<int>(
                            value: 2,
                            child: Text('Comida'),
                          ),
                          DropdownMenuItem<int>(
                            value: 3,
                            child: Text('Cena'),
                          ),
                          DropdownMenuItem<int>(
                            value: 4,
                            child: Text('Dormir'),
                          ),
                          DropdownMenuItem<int>(
                            value: 0,
                            child: Text('Ninguno'),
                          ),
                        ],
                        onChanged: (int? nuevoValor) {
                          setState(() {
                            _opcionSeleccionada = nuevoValor!;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text("Periodo"),
                      trailing: DropdownButton<int>(
                        value: _periodo,
                        items: const [
                          DropdownMenuItem<int>(
                            value: 0,
                            child: Text('Diaria'),
                          ),
                          DropdownMenuItem<int>(
                            value: 1,
                            child: Text('Personalizada'),
                          ),
                          DropdownMenuItem<int>(
                            value: 2,
                            child: Text('Una vez'),
                          ),
                        ],
                        onChanged: (int? nuevoValor) {
                          setState(() {
                            _periodo = nuevoValor!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Guardar'),
                  onPressed: () {
                    // Guardar los cambios en la alarma
                    //TODO: comprobar si va ok y subirlo a la BD
                    setState(() {
                      alarma.numPills = int.parse(_NumPillController.text);
                      String newDay = _DayController.text;
                      List<String> newDaySplit = newDay.split('-');
                      alarma.day = DateTime(int.parse(newDaySplit[0]), int.parse(newDaySplit[1]), int.parse(newDaySplit[2]));
                      alarma.hour = _hourController.text;
                      alarma.timeOfDay = _opcionSeleccionada;
                      alarma.period = _periodo;
                    });
                    actualizar_alarmas(getUserAsociadoId(), alarma.getAlarmId()!,  alarma.getNumPills()!,
                        alarma.day!, alarma.getHour()!,alarma.getTimeOfDay()!,
                        alarma.getPeriod()!);
                    Navigator.of(context).pop(); // Cerrar el pop-up de edición
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

  void _mostrarInformacionAlarma(BuildContext context, Alarma_type alarma) {
    List<String>? alarm = alarma.getDay()?.split(" ");
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(alarma.pillName!),
          content: Wrap( // Envuelve el contenido en una columna
            direction: Axis.horizontal, // Limita el tamaño de la columna
            children: <Widget>[
              Text("Dosis a tomar: ${alarma.numPills}", style: TextStyle(fontSize: 16.0)),
              // Muestra la descripción
              Text('Se toma el ${alarm?[0]} a las ${alarma.getHour()}', style: TextStyle(fontSize: 16.0)),
              Text(timeOfDayInfo(alarma.timeOfDay!), style: TextStyle(fontSize: 16.0)),
              Text("Este recordatorio salta ${getPeriodoInfo(alarma.period!)}", style: TextStyle(fontSize: 16.0)),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
            Visibility(
            visible: getRoleId() != 2,
            child:
                TextButton(
                  child: Text('Editar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _mostrarPopEdicionAlarma(context, alarma);
                  },
                ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recordatorios', style: TextStyle(fontSize: 25.0)),
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
                      return Card(
                          clipBehavior: Clip.hardEdge,
                          child:ListTile(
                          leading: Icon(Icons.medication), // Icono a la izquierda
                            title: Text(alarma.getPillName()!), // Texto principal
                            subtitle: Text('Cantidad a tomar: ${alarma.getNumPills()} ud.'),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.redAccent,// Icono a la derecha
                              onPressed: () {
                                _showDeleteConfirmationDialog(context, alarma);
                              },
                            ),
                            onTap: () {
                              debugPrint('tapped.');
                              _mostrarInformacionAlarma(context, alarma);
                            },
                          ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error al cargar recordatorios: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
          Visibility(
            visible: getRoleId() != 2,
            child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCalendario()),
              );
            },
            child: Text('Añadir recordatorio'),
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
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../database/db_connections.dart';
import '../database/pills.dart';
import '../database/user.dart';
import 'navigation_drawer.dart';
import 'dart:io';


class AddCalendario extends StatefulWidget {
  const AddCalendario({Key? key}) : super(key: key);

  @override
  State<AddCalendario> createState() => _AddCalendarioState();
}

class _AddCalendarioState extends State<AddCalendario> {
  // Lista de opciones para el Dropdown Menu
  List<String> opciones = [];

  // Función para obtener las opciones del Dropdown Menu
  Future<void> obtenerOpciones() async {
    opciones = await getAll();
    setState(() {});
  }

  // Variable para el valor seleccionado del Dropdown Menu
  String? valorSeleccionadoNombre;

  List<String>frecuencia = ["Diaria", "Una vez"];
  String? valorSeleccionadoFrec;

  List<String>periodo = ["Desayuno", "Comida", "Cena", "Otros"];
  String? valorSeleccionadoPeriod;

  int? cantidadPastillas;

  @override
  void initState() {
    super.initState();
    obtenerOpciones();
  }

  @override
  Future<List<String>> getAll() async {
    List<String> _listProducts = [];
    Future<List<Pill>>? lista = getPills(getUserAsociadoId());
    List<Pill> pills = await lista!; // Espera a que se complete la llamada a getPills

    for (var item in pills) {
      debugPrint(item.pillName!);
      _listProducts.add(item.pillName!);
    }

    debugPrint(_listProducts.toString());
    return _listProducts;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Programar pastilla'),
        backgroundColor: ColorsApp.toolBarColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Fila con el texto "Nombre:" y el Dropdown Menu
            Row(
              children: [
                const Text('Nombre:', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: valorSeleccionadoNombre,
                  items: opciones.map((opcion) => DropdownMenuItem(
                    value: opcion,
                    child: Text(opcion),
                  )).toList(),
                  onChanged: (valor) {
                    setState(() {
                      valorSeleccionadoNombre = valor;
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Text('Frecuencia:', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: valorSeleccionadoFrec,
                  items: frecuencia.map((opcion) => DropdownMenuItem(
                    value: opcion,
                    child: Text(opcion),
                  )).toList(),
                  onChanged: (valor) {
                    setState(() {
                      valorSeleccionadoFrec = valor;
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Text('Periodo:', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: valorSeleccionadoPeriod,
                  items: periodo.map((opcion) => DropdownMenuItem(
                    value: opcion,
                    child: Text(opcion),
                  )).toList(),
                  onChanged: (valor) {
                    setState(() {
                      valorSeleccionadoPeriod = valor;
                    });
                  },
                ),
              ],
            ),
             Row(
              children: [
                Text('Cantidad:  ', style: TextStyle(fontSize: 16)),
                SizedBox(
                  height: 50, // constrain height
                  width: 100,
                  child: TextField(
                    onChanged: (texto) {
                      cantidadPastillas = int.tryParse(texto);
                    },
                  ),
                )
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // Validar el nombre y la edad
                /*setState(() {
                  _validacionNombreEdad = valorSeleccionado != null && numeroIngresado != null;
                });*/
                if (valorSeleccionadoNombre == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, rellena el campo de nombre'),
                    ),
                  );
                  // Implementar la acción del botón
                } else if(valorSeleccionadoFrec == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Por favor, rellena el campo de frecuencia'),
                    ),
                  );
                }
                else if(valorSeleccionadoPeriod == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, rellena el campo de periodo'),
                    ),
                  );
                }
                else if(cantidadPastillas == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, rellena el campo de cantidad'),
                    ),
                  );
                }
                else {
                  insertSchedule(valorSeleccionadoNombre!, getUserId(),
                      valorSeleccionadoPeriod!, "null", "null", cantidadPastillas!);
                }
              },
              child: const Text('Añadir'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsApp.buttonColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}






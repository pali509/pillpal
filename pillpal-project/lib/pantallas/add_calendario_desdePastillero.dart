import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../database/db_connections.dart';
import '../database/pills.dart';
import '../database/user.dart';
import 'navigation_drawer.dart';
import 'dart:io';


class AddCalendarioDesdePastillero extends StatefulWidget {
  final String nombreMed;
  final int numPastillas;
  const AddCalendarioDesdePastillero({Key? key, required this.nombreMed, required this.numPastillas}) : super(key: key);

  @override
  _AddCalendarioPasState createState() {
    return _AddCalendarioPasState(this.nombreMed, this.numPastillas);
  }
}

class _AddCalendarioPasState extends State<AddCalendarioDesdePastillero> {
  // Lista de opciones para el Dropdown Menu
  List<String> opciones = [];

  String nombreMed;

  int numPastillas;

  _AddCalendarioPasState(this.nombreMed, this.numPastillas);


  List<String>frecuencia = ["Diaria", "Una vez", "Personalizado"];
  String? valorSeleccionadoFrec;

  List<String>periodo = ["Desayuno", "Comida", "Cena", "Otro"];
  String? valorSeleccionadoPeriod;

  final List<String> diasSemana = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
  final List<bool> _selectedDays = List.filled(7, false);
  DateTime? fechaSeleccionada;

  String hour = "09:00:00";

  int? cantidadPastillas;

  TextEditingController controllerFecha = TextEditingController();

  @override
  void initState() {
    super.initState();
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
                 Text('Medicamento: ${this.nombreMed}', style: TextStyle(fontSize: 16)),
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
            Visibility(
                visible: (valorSeleccionadoFrec == "Una vez" || valorSeleccionadoFrec == "Diaria"),
                child: SizedBox(
                    height: 130.0,
                    child: Scaffold(
                      body: Center(
                        // Adjust the value as needed
                        child: TextField(
                          controller: controllerFecha,
                          decoration: InputDecoration(
                            labelText: valorSeleccionadoFrec == "Una vez" ? 'Elegir fecha' : 'Elegir fecha inicio',
                            filled: true,
                            prefixIcon: Icon(Icons.calendar_today),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: ColorsApp.buttonColor)
                            ),
                          ),
                          readOnly: true,
                          onTap:(){
                            selectFecha();
                          },
                        ),
                      ),
                    )
                )

            ),

            Visibility(
              visible: (valorSeleccionadoFrec == "Personalizado"),
              child: Column(
                children: [
                  // Display each day and its checkbox
                  for (int i = 0; i < diasSemana.length; i++)
                    CheckboxListTile(
                      title: Text(diasSemana[i]),
                      value: _selectedDays[i],
                      onChanged: (value) {
                        setState(() {
                          _selectedDays[i] = value!;
                        });
                      },
                    ),
                  // Display selected days (optional)
                  if (_selectedDays.any((bool selected) => selected)) // Check if any day is selected
                    Text('Dias seleccionados: ${_selectedDays.asMap().entries.where((entry) => entry.value).map((entry) => diasSemana[entry.key]).join(', ')}'), // Format selected days
                ],
              ),
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
                  // Implementar la acción del botón
                if(valorSeleccionadoFrec == null) {
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
                else if(fechaSeleccionada == null && valorSeleccionadoFrec != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, rellena el campo de la fecha'),
                    ),
                  );
                }
                else {
                  int frecuenciaInt = 2;
                  String daysOfWeek = "0000000"; //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1
                  if(valorSeleccionadoFrec == "Diaria")
                    frecuenciaInt = 0;
                  else if(valorSeleccionadoFrec == "Personalizado")//Parsear days of week
                    frecuenciaInt = 1;

                  insertPills(this.nombreMed, this.numPastillas, getUserAsociadoId());
                  insertSchedule(this.nombreMed, getUserId(),
                      valorSeleccionadoPeriod!, fechaSeleccionada, hour, cantidadPastillas!, frecuenciaInt, daysOfWeek);
                  Navigator.pushReplacementNamed(context, '/pastis');
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

  Future<void> selectFecha() async{
    fechaSeleccionada = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2024),
        lastDate: DateTime(2030)
    );
    if(fechaSeleccionada != null){
      setState(() {
        controllerFecha.text = fechaSeleccionada.toString().split(" ")[0];
      });
    }
  }
}






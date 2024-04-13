import 'dart:math';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../constants/colors.dart';
import '../utils/alarms.dart';
import '../utils/db_connections.dart';
import '../utils/pills.dart';
import '../utils/user.dart';
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

  List<String>frecuencia = ["Diaria", "Una vez", "Personalizado"];
  String? valorSeleccionadoFrec;

  List<String>periodo = ["Desayuno", "Comida", "Cena", "Dormir", "Otro"];
  String? valorSeleccionadoTOD;

  final List<String> diasSemana = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
  final List<bool> _selectedDays = List.filled(7, false);
  DateTime? fechaSeleccionada;

  int? cantidadPastillas;

  String hora_String = "09:00:00"; //CAMBIAR CUANDO IMPLEMENTE LO DE "OTRO"
  TimeOfDay _horaSeleccionada = TimeOfDay.now();
  
  TextEditingController controllerFecha = TextEditingController();

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
      body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Fila con el texto "Nombre:" y el Dropdown Menu
            Row(
              children: [
                const Text('Nombre:', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 16, height: 50),
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
                const SizedBox(width: 16, height: 50),
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
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none
                        ),
                        focusedBorder: const OutlineInputBorder(
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
                   TextField(
                    controller: controllerFecha,
                    decoration: const InputDecoration(
                      labelText: 'Elegir fecha inicio',
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
                const SizedBox(
                    width: 16,
                    height: 50,
                ),
                DropdownButton<String>(
                  value: valorSeleccionadoTOD,
                  items: periodo.map((opcion) => DropdownMenuItem(
                    value: opcion,
                    child: Text(opcion),
                  )).toList(),
                  onChanged: (valor) {
                    setState(() {
                      valorSeleccionadoTOD = valor;
                    });
                  },
                ),
              ],
            ),
            Visibility(
              visible: (valorSeleccionadoTOD == "Otro"),
              child: Row(
                children: [
                  const Text('Hora:', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(_horaSeleccionada.format(context)),
                  ),
                  IconButton(
                    onPressed: () async {
                      TimeOfDay? hora = await showTimePicker(

                        context: context,
                        initialTime: _horaSeleccionada,
                        hourLabelText : "Seleccione hora",
                        minuteLabelText: "Seleccione minuto",
                        cancelText: "Cancelar",
                        helpText: "Seleccionar hora",
                      );
                      if (hora != null) {
                        setState(() {
                          _horaSeleccionada = hora;
                        });
                      }
                    },
                    icon: const Icon(Icons.access_time),
                  ),
                ],
              ),
            ),
             Row(
              children: [
                const Text('Cantidad:  ', style: TextStyle(fontSize: 16)),
                SizedBox(
                  height: 50, // constrain height
                  width: 100,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    onChanged: (texto) {
                      cantidadPastillas = int.tryParse(texto);
                    },
                  ),
                )
              ],
            ),
        SizedBox(height: 50.0,),
        SizedBox(
          width: 200.0, // Adjust width and height as needed
          height: 50.0,
            child: ElevatedButton(
              onPressed: () async {
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
                else if(valorSeleccionadoTOD == null) {
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
                else  if (!_selectedDays.any((bool selected) => selected) && valorSeleccionadoFrec == "Personalizado")  {// Check if any day is selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, seleccione algun dia'),
                    ),
                  );
                }
                else {
                  int frecuenciaInt = 2;
                  String daysOfWeek = "0000000";
                  if(valorSeleccionadoFrec == "Diaria")
                    frecuenciaInt = 0;
                  else if(valorSeleccionadoFrec == "Personalizado") { //Parsear days of week
                    frecuenciaInt = 1;
                    daysOfWeek = "";
                    for(int i = 0; i < _selectedDays.length; i++){
                      if(_selectedDays[i])
                        daysOfWeek = daysOfWeek + "1";
                      else
                        daysOfWeek = daysOfWeek + "0";
                    }
                  }
                  hora_String = _horaSeleccionada.format(context);
                  Random random = Random();
                  int randomNumber = random.nextInt(10000);
                  debugPrint(randomNumber.toString());
                  await una_vez(randomNumber, fechaSeleccionada!, hora_String!, valorSeleccionadoNombre!, cantidadPastillas!);
                  await insertSchedule(valorSeleccionadoNombre!, getUserAsociadoId(),
                      valorSeleccionadoTOD!, fechaSeleccionada, hora_String, cantidadPastillas!, frecuenciaInt, daysOfWeek, randomNumber);
                  //diarias(fechaSeleccionada!, hora!, valorSeleccionadoNombre!, cantidadPastillas!);
                  Navigator.of(context).pushReplacementNamed('/calendario');
                }
              },
              child: Text('Añadir'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsApp.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,

                ),
              ),
              
            ),

            ),
          ],
        ),
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






import '../utils.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pillpal/constants/colors.dart';
import 'package:pillpal/utils/horario.dart';
import 'package:pillpal/utils/user.dart';
import 'package:table_calendar/table_calendar.dart';


import '../utils/db_connections.dart';
import 'add_calendario.dart';
import 'navigation_drawer.dart';


class PantallaCalendario extends StatefulWidget {
  const PantallaCalendario({super.key});

  @override
  _PantallaCalendarioState createState() => _PantallaCalendarioState();
}
class _PantallaCalendarioState extends State<PantallaCalendario> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff;

  Future<List<Horario>>? _selectedEvents = null;
  List<Horario> cosas = [];
  bool visibleDesayuno = false;
  bool visibleComida = false;
  bool visibleCena = false;


  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;

    _selectedEvents = _getEventsForDay(_selectedDay!);

  }
  Future<List<Horario>> _getEventsForDay(DateTime day)  {
   Future<List<Horario>> events =  getDayPills(day, getUserId());
    return events;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calendario',
          style: TextStyle(fontSize: 25.0),
        ),
        backgroundColor: ColorsApp.toolBarColor,
      ),
      drawer: MyDrawer(),

      body: Column(
        children: [
          TableCalendar(
            locale: 'es_Es',
            firstDay: DateTime.utc(2023, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            startingDayOfWeek: StartingDayOfWeek.monday,

            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) { //Cambiar dia seleccionado
              if (!isSameDay(_selectedDay, selectedDay)) {
                // Call `setState()` when updating the selected day
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _selectedEvents = _getEventsForDay(selectedDay);
                });
              }
            },
            onFormatChanged: (format) { //Cambiar formato
              if (_calendarFormat != format) {
                // Call `setState()` when updating calendar format
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              // No need to call `setState()` here
              _focusedDay = focusedDay;
            },
          ),
        const SizedBox(height: 8.0),//para separar calendario y eventos
        Expanded(
          child:ListView(
            scrollDirection: Axis.vertical,
            children: [
                FutureBuilder<List<Horario>>( //El cuadrado de desayuno
                      future: _selectedEvents,
                      builder: (context, snapshot) {
                          cosas = snapshot.data!;
                          cosas = cogerSegunMomento(
                              cosas, 1); //Para coger solo las del desayuno
                          if (cosas.isNotEmpty) {
                            visibleDesayuno =
                            true; //Si hay cosas ponerlo visible
                          }
                          return Visibility(
                            visible: visibleDesayuno,
                            //Bool que decide si aparece o no, segun si hay eventos
                            child: Container(
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.blue, width: 5),
                              ),
                              child: ListView
                                  .builder( //Esto es igual que el de pantalla pastillero
                                itemCount: cosas.length,
                                itemBuilder: (context, index) {
                                  Horario currentCosa = cosas[index];
                                  return Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: ListTile(
                                      onTap: () => print('${cosas[index]}'),
                                      title: Text(
                                          '${currentCosa.getPillName()}'),
                                      subtitle: Text('Cantidad: ${currentCosa
                                          .getNumPills()} ud.'),
                                    ),
                                  );
                                },
                              ),),
                          );

                      },
                    ),

              FutureBuilder<List<Horario>>( //Misma cosa para comida
                future: _selectedEvents,
                builder: (context, snapshot) {
                  cosas = snapshot.data!;
                  cosas = cogerSegunMomento(cosas, 2);
                  if(cosas.isNotEmpty) {
                    visibleComida = true;
                  }
                  else {
                    visibleComida = false;
                  }
                  return Visibility(
                    visible: visibleComida,
                    child:Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 5),
                      ),
                      child: ListView.builder(
                        itemCount: cosas.length,
                        itemBuilder: (context, index) {
                          Horario currentCosa = cosas[index];
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: ListTile(
                              onTap: () => print('${cosas[index]}'),
                              title: Text('${currentCosa.getPillName()}'),
                              subtitle: Text('Cantidad: ${currentCosa.getNumPills()} ud.'),
                            ),
                          );
                        },
                      ),),
                  );
                },
              ),

              FutureBuilder<List<Horario>>( //Misma cosa para cena
                future: _selectedEvents,
                builder: (context, snapshot) {
                  cosas = snapshot.data!;
                  cosas = cogerSegunMomento(cosas, 3);
                  if(cosas.isNotEmpty) {
                    visibleCena = true;
                  }
                  else {
                    visibleCena = false;
                  }
                  return Visibility(
                    visible: visibleCena,
                    child:Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red, width: 5),
                      ),
                      child: ListView.builder(
                        itemCount: cosas.length,
                        itemBuilder: (context, index) {
                          Horario currentCosa = cosas[index];
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: ListTile(
                              onTap: () => print('${cosas[index]}'),
                              title: Text('${currentCosa.getPillName()}'),
                              subtitle: Text('Cantidad: ${currentCosa.getNumPills()} ud.'),
                            ),
                          );
                        },
                      ),),
                  );
                },
              ),
            ],
          ),
        ),
         ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddCalendario()),
            );
          },
          child: Text("Añadir medicación"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,

          ),
        ),
      ),
    ],
    ),
    );
  }

  List<Horario> cogerSegunMomento(List<Horario> cosas, int op) {
    List<Horario> nuevaLista = [];
    for(int i = 0; i < cosas.length; i++){
      if(cosas[i].getTimeOfDay() == op)
        nuevaLista.add(cosas[i]);
    }
    return nuevaLista;
  }

}

/*
          child: FutureBuilder<List<Horario>>(
            future: _selectedEvents,
            builder: (context, snapshot) {
              cosas = snapshot.data!;
              return ListView.builder(
                itemCount: cosas.length,
                itemBuilder: (context, index) {
                  Horario currentCosa = cosas[index];

                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      onTap: () => print('${cosas[index]}'),
                      title: Text('${currentCosa.getPillName()}'),
                      subtitle: Text('Cantidad: ${currentCosa.getNumPills()} ud.'),
                    ),
                  );
                },
              );
            },
          ),
 */


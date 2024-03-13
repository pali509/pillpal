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
  List<Horario> cosas2 = [];
  List<Horario> cosas3 = [];

  bool visibleDesayuno = false;
  bool visibleComida = false;
  bool visibleCena = false;
  bool visibleDormir = false;
  bool visibleBotonDormir = false;
  bool visibleOtros = false;

  bool visibleBotonOtros = false;
  bool visibleBotonDesayuno = false;
  bool visibleBotonComida = false;
  bool visibleBotonCena = false;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;


  }

  Future<List<Horario>> _getEventsForDay(DateTime day) async{
    await Future.delayed(const Duration(milliseconds: 2));
      Future<List<Horario>> events =  getDayPills(day, getUserAsociadoId());
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

                });
              }
              else if (isSameDay(_selectedDay, selectedDay)) {
                // Call `setState()` when updating the selected day
                setState(() {});
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
            child: FutureBuilder<List<Horario>>( //El cuadrado de desayuno
                      future: _getEventsForDay(_selectedDay!),
                      builder: (context, snapshot) {
                       if (snapshot.connectionState == ConnectionState.waiting) {
                       return const Center(child: CircularProgressIndicator());
                       } else {
                         cosas = snapshot.data!;
                         cosas2 = cogerSegunMomento(cosas, 1); //Para coger solo las del desayuno
                         cosas3 = cogerSegunMomento(cosas, 3);

                         if (cosas2.isNotEmpty) {
                           visibleDesayuno = true; //Si hay cosas ponerlo visible
                           if (cosas2.length > 2) {
                             visibleBotonDesayuno = true;
                           }
                           else
                             visibleBotonDesayuno = false;
                         }
                         else
                           visibleDesayuno = false;

                         if (cosas3.isNotEmpty) {
                           visibleCena = true; //Si hay cosas ponerlo visible
                           if (cosas3.length > 2) {
                             visibleBotonCena = true;
                           }
                           else
                             visibleBotonCena = false;
                         }
                         else
                           visibleCena = false;
                         debugPrint('Visiblecena: ${visibleCena}');
                         return ListView(
                             scrollDirection: Axis.vertical,

                          children: [
                          Visibility(
                           visible: visibleDesayuno,
                           //Bool que decide si aparece o no, segun si hay eventos
                           child: Container(
                             height: 200,
                             decoration: BoxDecoration(
                               border: Border.all(
                                   color: Colors.blue, width: 5),
                             ),
                             child:
                             ListView.builder( //Esto es igual que el de pantalla pastillero
                               itemCount: visibleBotonDesayuno ? 2 : cosas2.length,
                               physics: const NeverScrollableScrollPhysics(),

                               itemBuilder: (context, index) {
                                 Horario currentCosa = cosas2[index];
                                 return Container(
                                   decoration: BoxDecoration(
                                     border: Border.all(),
                                     borderRadius: BorderRadius.circular(12.0),
                                   ),
                                   child: ListTile(
                                     onTap: () => print('${cosas2[index]}'),
                                     title: Text(
                                         '${currentCosa.getPillName()}'),
                                     subtitle: Text('Cantidad: ${currentCosa
                                         .getNumPills()} ud.'),
                                   ),
                                 );
                               },

                             ),
                           ),
                         ),
                        Visibility(
                        visible: visibleComida,

                        child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 5),
                        ),
                        child: ListView.builder(
                        itemCount: visibleBotonComida ? 2 : cosas.length,
                        physics: const NeverScrollableScrollPhysics(),
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
                        subtitle: Text(
                        'Cantidad: ${currentCosa.getNumPills()} ud.'),
                        ),
                        );
                        },
                        ),),
                        ),
                        Visibility(
                        visible: visibleCena,
                        child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                        border: Border.all(color: Colors.red, width: 5),
                        ),
                        child: ListView.builder(
                        itemCount: visibleBotonCena ? 2 : cosas3.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                        Horario currentCosa = cosas3[index];
                        return Container(
                        decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                        onTap: () => print('${cosas3[index]}'),
                        title: Text('${currentCosa.getPillName()}'),
                        subtitle: Text(
                        'Cantidad: ${currentCosa.getNumPills()} ud.'),
                        ),
                        );
                        },
                        ),
                        ),
                        ),
                        Visibility(
                        visible: visibleDormir,
                        child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                        border: Border.all(color: Colors.cyanAccent, width: 5),
                        ),
                        child: ListView.builder(
                        itemCount: visibleBotonDormir ? 2 : cosas.length,
                        physics: const NeverScrollableScrollPhysics(),
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
                        subtitle: Text(
                        'Cantidad: ${currentCosa.getNumPills()} ud.'),
                        ),
                        );
                        },
                        ),
                        ),
                        ),
                          ],
                         );
                       }
                      },
                ),

        ),
       Visibility(
        visible: (getRoleId() != 2),
         child: ElevatedButton(
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
return Visibility(
                           visible: visibleDesayuno,
                           //Bool que decide si aparece o no, segun si hay eventos
                           child: Container(
                             height: 200,
                             decoration: BoxDecoration(
                               border: Border.all(
                                   color: Colors.blue, width: 5),
                             ),
                             child:
                             ListView.builder( //Esto es igual que el de pantalla pastillero
                               itemCount: visibleBotonDesayuno ? 2 : cosas.length,
                               physics: const NeverScrollableScrollPhysics(),

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

                             ),
                           ),
                         );
                       }
                      },
                    ),

              FutureBuilder<List<Horario>>( //Misma cosa para comida
                future: _getEventsForDay(_selectedDay!),
                builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Opacity(opacity: 0.0, child: CircularProgressIndicator()));
                } else {
                  cosas = snapshot.data!;
                  cosas = cogerSegunMomento(cosas, 2);
                  if (cosas.isNotEmpty) {
                    visibleComida = true;
                    if (cosas.length > 2) {
                      visibleBotonComida = true;
                    }
                    else
                      visibleBotonComida = false;
                  }
                  else {
                    visibleComida = false;
                  }
                  return Visibility(
                    visible: visibleComida,

                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 5),
                      ),
                      child: ListView.builder(
                        itemCount: visibleBotonComida ? 2 : cosas.length,
                        physics: const NeverScrollableScrollPhysics(),
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
                              subtitle: Text(
                                  'Cantidad: ${currentCosa.getNumPills()} ud.'),
                            ),
                          );
                        },
                      ),),
                  );
                }
                },
              ),

              FutureBuilder<List<Horario>>( //Misma cosa para cena
                future: _getEventsForDay(_selectedDay!),
                builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Opacity(opacity: 0.0, child: CircularProgressIndicator()));
                } else {
                  cosas = snapshot.data!;
                  cosas = cogerSegunMomento(cosas, 3);
                  if (cosas.isNotEmpty) {
                    visibleCena = true;
                    if (cosas.length > 2) {
                      visibleBotonCena = true;
                    }
                    else
                      visibleBotonCena = false;
                  }
                  else {
                    visibleCena = false;
                  }
                  return Visibility(
                    visible: visibleCena,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red, width: 5),
                      ),
                      child: ListView.builder(
                        itemCount: visibleBotonCena ? 2 : cosas.length,
                        physics: const NeverScrollableScrollPhysics(),
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
                              subtitle: Text(
                                  'Cantidad: ${currentCosa.getNumPills()} ud.'),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
                },
              ),
              FutureBuilder<List<Horario>>( //Misma cosa para dormir
                future: _getEventsForDay(_selectedDay!),
                builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Opacity(opacity: 0.0, child: CircularProgressIndicator()));
                } else {
                  cosas = snapshot.data!;
                  cosas = cogerSegunMomento(cosas, 4);
                  if (cosas.isNotEmpty) {
                    visibleDormir = true;
                    if (cosas.length > 2) {
                      visibleBotonDormir = true;
                    }
                    else
                      visibleBotonDormir = false;
                  }
                  else {
                    visibleDormir = false;
                  }
                  return Visibility(
                    visible: visibleDormir,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.cyanAccent, width: 5),
                      ),
                      child: ListView.builder(
                        itemCount: visibleBotonDormir ? 2 : cosas.length,
                        physics: const NeverScrollableScrollPhysics(),
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
                              subtitle: Text(
                                  'Cantidad: ${currentCosa.getNumPills()} ud.'),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
                },
              ),
 */




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


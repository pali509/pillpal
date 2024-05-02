import 'package:pillpal/pantallas/pantalla_perfil.dart';

import 'dart:core';
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

enum Selection { Semana, Mes }
List<String> months= ["enero", "febrero", "marzo", "abril", "mayo", "junio",
  "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre"];
List<String> weekdays = ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"];

class PantallaEstadisticas extends StatefulWidget {
  const PantallaEstadisticas({super.key});

  @override
  _PantallaEstadisticasState createState() => _PantallaEstadisticasState();
}
class _PantallaEstadisticasState extends State<PantallaEstadisticas> {
  CalendarFormat _calendarFormat = CalendarFormat.week;


  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  Selection selected = Selection.Semana;
  String diaSeleccionado = weekdays[DateTime.now().weekday - 1];
  DateTime dia = DateTime.now();
  int semanaprevia = 0;
  //DateTime diaFinal = DateTime.now();

  int previous = -1;

  void _handleButtonPress(Selection selection) {
    setState(() {
      selected = selection;
    });
  }
  DateTime primerDiaSemana(DateTime hoy){
    int dia = hoy.weekday;
    DateTime primerDia = hoy;
    switch (dia) {
      case 1:
        primerDia = hoy;
        break;
      case 2:
        primerDia = hoy.subtract(Duration(days: 1));
        break;
      case 3:
        primerDia = hoy.subtract(Duration(days: 2));
        break;
      case 4:
        primerDia = hoy.subtract(Duration(days: 3));
        break;
      case 5:
        primerDia = hoy.subtract(Duration(days: 4));
        break;
      case 6:
        primerDia = hoy.subtract(Duration(days: 5));
        break;
      case 7:
        primerDia = hoy.subtract(Duration(days: 6));
        break;
    }
    return primerDia;
  }
  DateTime UltimoDiaSemana(DateTime hoy){
    DateTime ultimoDia = hoy;
    int dia = hoy.weekday;

    switch (dia) {
      case 1:
        ultimoDia = hoy.add(Duration(days: 6));
        break;
      case 2:
        ultimoDia = hoy.add(Duration(days: 5));
        break;
      case 3:
        ultimoDia = hoy.add(Duration(days: 4));
        break;
      case 4:
        ultimoDia = hoy.add(Duration(days: 3));
        break;
      case 5:
        ultimoDia = hoy.add(Duration(days: 2));
        break;
      case 6:
        ultimoDia = hoy.add(Duration(days: 1));
        break;
      case 7:
        ultimoDia = hoy;
        break;
    }
    return ultimoDia;
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          title: const Text(
            'Estadísticas de toma',
            style: TextStyle(fontSize: 25.0),
          ),
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
          children: [
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _handleButtonPress(Selection.Semana),
                  child: Text('Semana'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selected == Selection.Semana ? Colors.purple : Colors.grey,
                    minimumSize: Size(150, 50),
                    textStyle: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 40.0),
                ElevatedButton(
                  onPressed: () => _handleButtonPress(Selection.Mes),
                  child: Text('Mes'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selected == Selection.Mes ? Colors.purple : Colors.grey,
                    minimumSize: Size(150, 50),
                    textStyle: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: selected == Selection.Semana,
              child: Expanded(
                  child: Column(
                      children:[
                        const SizedBox(height: 30.0),
                        Text('${primerDiaSemana(dia).day} ${months[primerDiaSemana(dia).month - 1]} '
                            '- ${UltimoDiaSemana(dia).day} ${months[UltimoDiaSemana(dia).month - 1]}'
                            , style: TextStyle(fontSize: 20)),

                        const SizedBox(height: 20.0),
                        Text('Estadística semanal: ', style: TextStyle(fontSize: 20)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20.0),
                            Text('Medicación tomada:         10 (50%)', style: TextStyle(fontSize: 20)),
                            const SizedBox(height: 20.0),
                            Text('Total medicación a tomar:    20', style: TextStyle(fontSize: 20)),
                            const SizedBox(height: 10.0),
                          ],
                        ),

                        TableCalendar(
                          locale: 'es_Es',
                          //headerVisible : false,
                          headerStyle: const HeaderStyle(
                            titleCentered: true,
                            formatButtonVisible : false,

                          ),
                          firstDay: DateTime.utc(2023, 10, 16),
                          lastDay: DateTime.utc(2030, 3, 14),
                          focusedDay: _focusedDay,
                          calendarFormat: _calendarFormat,
                          startingDayOfWeek: StartingDayOfWeek.monday,
                          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                          onDaySelected: (selectedDay, focusedDay) { //Cambiar dia seleccionado
                            if (!isSameDay(_selectedDay, selectedDay)) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                                diaSeleccionado = weekdays[selectedDay.weekday-1];
                              });
                            }
                          },
                          onPageChanged: (focusedDay) {

                            setState(() {
                              _focusedDay = focusedDay;

                              final difference = focusedDay.difference(_selectedDay!).inDays;
                              if (semanaprevia < difference ) {
                                dia = dia.add(const Duration(days: 7));
                                previous = 1;
                                semanaprevia = difference;

                              } else if ( semanaprevia > difference) {
                                dia = dia.subtract(const Duration(days: 7));
                                previous = 0;
                                semanaprevia = difference;
                              }
                              else{
                                if(previous == 0){
                                  dia = dia.add(const Duration(days: 7));
                                }
                                else if(previous == 1){
                                  dia = dia.subtract(const Duration(days: 7));
                                }
                              }
                            });
                          },
                        ),
                        Expanded(
                          child: ListView(
                            children: [
                              Column(
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                const SizedBox(height: 20.0),
                                Text('Estadística diaria: $diaSeleccionado', style: TextStyle(fontSize: 20)),
                                const SizedBox(height: 20.0),
                                Text('Medicación tomada:         5 (50%)', style: TextStyle(fontSize: 20)),
                                const SizedBox(height: 20.0),
                                Text('Total medicación a tomar:    10', style: TextStyle(fontSize: 20)),
                                const SizedBox(height: 20.0),
                          ],
                        ),


                              Container(
                                child: ListView(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children:[
                                    const Text(
                                      ' Medicación tomada',
                                      style: TextStyle(color: Colors.black, fontSize: 25),
                                    ),

                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.green, width: 5),
                                      ),
                                      child: ListView.builder( //Esto es igual que el de pantalla pastillero
                                        shrinkWrap: true,
                                        itemCount: 1,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return const Padding(
                                            padding:  EdgeInsets.only(top: 25.0, bottom: 15.0),
                                            child: Center(
                                              child: Text("No hay medicación tomada ese día"),
                                            ),
                                          );

                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 30.0),
                              Container(
                                child: ListView(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children:[
                                    const Text(
                                      ' Medicación no tomada:',
                                      style: TextStyle(color: Colors.black, fontSize: 25),
                                    ),

                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.red, width: 5),
                                      ),
                                      child: ListView.builder( //Esto es igual que el de pantalla pastillero
                                          shrinkWrap: true,
                                          itemCount: 1,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {

                                            return const Padding(
                                              padding:  EdgeInsets.only(top: 25.0, bottom: 15.0),
                                              child: Center(
                                                child: Text("No hay medicación programada para este dia"),
                                              ),
                                            );
                                          }
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        /*
      Expanded(
        child: FutureBuilder<List<Horario>>(
          future: getDayPills(diaSeleccionado, getUserAsociadoId()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              cosas = snapshot.data!;
              cosas1 = cogerSegunMomento(cosas, 1); //Para coger solo las del desayuno
              cosas2 = cogerSegunMomento(cosas, 2); //Solo comida
              cosas3 = cogerSegunMomento(cosas, 3); //Solo cena
              cosas0 = cogerSegunMomento(cosas, 0);
              //FALTA DORMIR!

              if (cosas0.isNotEmpty)
                visibleOtros = true; //Si hay cosas ponerlo visible
              else
                visibleOtros = false;


              return ListView(
                scrollDirection: Axis.vertical,

                children: [
                  Container(

                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children:[
                        const Text(
                          ' Desayuno',
                          style: TextStyle(color: Colors.black, fontSize: 25),
                        ),

                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.blue, width: 5),
                          ),
                          child: ListView.builder( //Esto es igual que el de pantalla pastillero
                            shrinkWrap: true,
                            itemCount:cosas1.length > 0 ? cosas1.length : 1,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              if(cosas1.isNotEmpty) {
                                Horario currentCosa = cosas1[index];
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius
                                        .circular(12.0),
                                  ),
                                  child: ListTile(
                                    onTap: () =>
                                        print('${cosas1[index]}'),
                                    title: Text('${currentCosa
                                        .getPillName()}'),
                                    subtitle: Text(
                                        'Cantidad: ${currentCosa
                                            .getNumPills()} ud.'),
                                  ),
                                );
                              }
                              else {
                                return const Padding(
                                  padding:  EdgeInsets.only(top: 25.0, bottom: 15.0),
                                  child: Center(
                                    child: Text("No hay medicación programada para el desayuno este dia"),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),


                  Container(

                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children:[
                        const Text(
                          ' Comida',
                          style: TextStyle(color: Colors.black, fontSize: 25),
                        ),

                        Container(

                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.green, width: 5),
                          ),
                          child: ListView.builder( //Esto es igual que el de pantalla pastillero
                            shrinkWrap: true,
                            itemCount: cosas2.length > 0 ? cosas2.length : 1,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              if(cosas2.isNotEmpty) {
                                Horario currentCosa = cosas2[index];
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius
                                        .circular(12.0),
                                  ),
                                  child: ListTile(
                                    onTap: () =>
                                        print('${cosas2[index]}'),
                                    title: Text('${currentCosa
                                        .getPillName()}'),
                                    subtitle: Text(
                                        'Cantidad: ${currentCosa
                                            .getNumPills()} ud.'),
                                  ),
                                );
                              }
                              else {
                                return const Padding(
                                  padding:  EdgeInsets.only(top: 25.0, bottom: 15.0),
                                  child: Center(
                                    child: Text("No hay medicación programada para la comida este dia"),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },


        ),
      ),

       */

                      ]
                  )
              ),
            ),
            Visibility(
              visible: selected == Selection.Mes,
              child: Expanded(
                  child: Column(
                      children:[
                  Expanded(
                  child: ListView(
                  children: [
                    Column(
                      children:[
                        const SizedBox(height: 20.0),
                        Text('Estadística mensual: ', style: TextStyle(fontSize: 20)),

                            const SizedBox(height: 20.0),
                            Text('Medicación tomada:         10 (50%)', style: TextStyle(fontSize: 20)),
                            const SizedBox(height: 20.0),
                            Text('Total medicación a tomar:    20', style: TextStyle(fontSize: 20)),
                            const SizedBox(height: 10.0),
                          ],
                        ),

                        TableCalendar(
                          locale: 'es_Es',
                          //headerVisible : false,
                          headerStyle: const HeaderStyle(
                            titleCentered: true,
                            formatButtonVisible : false,

                          ),
                          firstDay: DateTime.utc(2023, 10, 16),
                          lastDay: DateTime.utc(2030, 3, 14),
                          focusedDay: _focusedDay,
                          calendarFormat: CalendarFormat.month,
                          startingDayOfWeek: StartingDayOfWeek.monday,
                          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                          onDaySelected: (selectedDay, focusedDay) { //Cambiar dia seleccionado
                            if (!isSameDay(_selectedDay, selectedDay)) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                                diaSeleccionado = weekdays[selectedDay.weekday-1];
                              });
                            }
                          },
                          onPageChanged: (focusedDay) {
                            setState(() {
                              _focusedDay = focusedDay;
                            });
                          },
                        ),
                        Expanded(
                          child:
                              Column(
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20.0),
                                  Text('Estadística diaria: $diaSeleccionado', style: TextStyle(fontSize: 20)),
                                  const SizedBox(height: 20.0),
                                  Text('Medicación tomada:         5 (50%)', style: TextStyle(fontSize: 20)),
                                  const SizedBox(height: 20.0),
                                  Text('Total medicación a tomar:    10', style: TextStyle(fontSize: 20)),
                                  const SizedBox(height: 20.0),

                              Container(
                                child: ListView(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children:[
                                    const Text(
                                      ' Medicación tomada',
                                      style: TextStyle(color: Colors.black, fontSize: 25),
                                    ),

                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.green, width: 5),
                                      ),
                                      child: ListView.builder( //Esto es igual que el de pantalla pastillero
                                        shrinkWrap: true,
                                        itemCount: 1,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return const Padding(
                                            padding:  EdgeInsets.only(top: 25.0, bottom: 15.0),
                                            child: Center(
                                              child: Text("No hay medicación tomada ese día"),
                                            ),
                                          );

                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 30.0),
                              Container(
                                child: ListView(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children:[
                                    const Text(
                                      ' Medicación no tomada:',
                                      style: TextStyle(color: Colors.black, fontSize: 25),
                                    ),

                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.red, width: 5),
                                      ),
                                      child: ListView.builder( //Esto es igual que el de pantalla pastillero
                                          shrinkWrap: true,
                                          itemCount: 1,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {

                                            return const Padding(
                                              padding:  EdgeInsets.only(top: 25.0, bottom: 15.0),
                                              child: Center(
                                                child: Text("No hay medicación programada para este dia"),
                                              ),
                                            );
                                          }
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                                ],
                              ),
                        ),
                        /*
      Expanded(
        child: FutureBuilder<List<Horario>>(
          future: getDayPills(diaSeleccionado, getUserAsociadoId()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              cosas = snapshot.data!;
              cosas1 = cogerSegunMomento(cosas, 1); //Para coger solo las del desayuno
              cosas2 = cogerSegunMomento(cosas, 2); //Solo comida
              cosas3 = cogerSegunMomento(cosas, 3); //Solo cena
              cosas0 = cogerSegunMomento(cosas, 0);
              //FALTA DORMIR!

              if (cosas0.isNotEmpty)
                visibleOtros = true; //Si hay cosas ponerlo visible
              else
                visibleOtros = false;


              return ListView(
                scrollDirection: Axis.vertical,

                children: [
                  Container(

                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children:[
                        const Text(
                          ' Desayuno',
                          style: TextStyle(color: Colors.black, fontSize: 25),
                        ),

                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.blue, width: 5),
                          ),
                          child: ListView.builder( //Esto es igual que el de pantalla pastillero
                            shrinkWrap: true,
                            itemCount:cosas1.length > 0 ? cosas1.length : 1,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              if(cosas1.isNotEmpty) {
                                Horario currentCosa = cosas1[index];
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius
                                        .circular(12.0),
                                  ),
                                  child: ListTile(
                                    onTap: () =>
                                        print('${cosas1[index]}'),
                                    title: Text('${currentCosa
                                        .getPillName()}'),
                                    subtitle: Text(
                                        'Cantidad: ${currentCosa
                                            .getNumPills()} ud.'),
                                  ),
                                );
                              }
                              else {
                                return const Padding(
                                  padding:  EdgeInsets.only(top: 25.0, bottom: 15.0),
                                  child: Center(
                                    child: Text("No hay medicación programada para el desayuno este dia"),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),


                  Container(

                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children:[
                        const Text(
                          ' Comida',
                          style: TextStyle(color: Colors.black, fontSize: 25),
                        ),

                        Container(

                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.green, width: 5),
                          ),
                          child: ListView.builder( //Esto es igual que el de pantalla pastillero
                            shrinkWrap: true,
                            itemCount: cosas2.length > 0 ? cosas2.length : 1,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              if(cosas2.isNotEmpty) {
                                Horario currentCosa = cosas2[index];
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius
                                        .circular(12.0),
                                  ),
                                  child: ListTile(
                                    onTap: () =>
                                        print('${cosas2[index]}'),
                                    title: Text('${currentCosa
                                        .getPillName()}'),
                                    subtitle: Text(
                                        'Cantidad: ${currentCosa
                                            .getNumPills()} ud.'),
                                  ),
                                );
                              }
                              else {
                                return const Padding(
                                  padding:  EdgeInsets.only(top: 25.0, bottom: 15.0),
                                  child: Center(
                                    child: Text("No hay medicación programada para la comida este dia"),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },


        ),
      ),

       */
              ]
              )
                  )
                      ]
                  )
              ),
            ),
          ],

        ),
      );

  }


}

/*
Falta:
  -El contenido de los containers ( de momento no se puede )
  -El mes podria ser mas grande en el header?
  MENSUAL:
  ======== Exception caught by widgets library =======================================================
The following assertion was thrown while applying parent data.:
Incorrect use of ParentDataWidget.

The ParentDataWidget Expanded(flex: 1) wants to apply ParentData of type FlexParentData to a RenderObject, which has been set up to accept ParentData of incompatible type ParentData.

Usually, this means that the Expanded widget has the wrong ancestor RenderObjectWidget. Typically, Expanded widgets are placed directly inside Flex widgets.
The offending Expanded is currently placed inside a RepaintBoundary widget.

 */
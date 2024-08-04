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
import '../utils/statistic_type.dart';
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

  Future<Statistic_type> estadisticas = getSta(DateTime.now(),DateTime.now(), getUserAsociadoId());

  int porcentajeSemanal = 0;
  int porcentajeDiario = 0;
  int porcentajeMensual = 0;

  int previous = -1;
  int previousMes = -1;
  int mesPrevio = 0;
  DateTime diaparaMes = DateTime.now();

  bool iniciado = false;

  List<Horario> cosas = [];
  int programadas = 0;

  void _actualizar(){
    setState(() {});
  }
  bool esHoy(DateTime seleccionado){
    Duration difference = _selectedDay!.difference(DateTime.now());
    debugPrint("diferencia${difference.inHours}");
    if(difference.inHours.abs() < 24)
      return true;
    else
      return false;

  }
  bool esLaMisma(List<int> takenQ, List<String> takenName, String nombre, int cant){
    for(int i = 0; i < takenQ.length; i++){
      if(takenQ[i] == cant && takenName[i] == nombre)
        return true;
    }
    return false;
  }
  int calcularItemCount(List<Horario> programadas, Statistic_type data){
    List<String> total = [];
    debugPrint("length taken ${data.takenName.length}");
    for(int i = 0; i < programadas.length; i++){
      if(!esLaMisma(data.takenQ, data.takenName, programadas[i].pillName!, programadas[i].numPills!)){
        total.add(programadas[i].pillName!);
      }
    }
    debugPrint("length ${total.length}");
    return total.length;
  }
  List<Horario> getSinTomar(List<Horario> programadas, Statistic_type data){
    List<Horario> aux = [];
    for(int i = 0; i < programadas.length; i++){
      if(!data.takenName.contains(programadas[i].pillName)){
        aux.add(programadas[i]);
      }
      else if(data.takenName.contains(programadas[i].pillName) && !data.takenQ.contains(programadas[i].numPills)) {
        aux.add(programadas[i]);
      }
      else if(data.takenName.contains(programadas[i].pillName) && data.takenQ.contains(programadas[i].numPills)
          && !esLaMisma(data.takenQ, data.takenName, programadas[i].pillName!, programadas[i].numPills!)){
        aux.add(programadas[i]);
      }
    }
    return aux;
  }
  void _handleButtonPress(Selection selection) {
    setState(() {
      selected = selection;
      _focusedDay = _selectedDay!;
      dia = _focusedDay;
      diaparaMes = _focusedDay;
      estadisticas = getSta(_selectedDay!, _selectedDay!, getUserAsociadoId());
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
    //estadisticas = getSta(primerDia, getUserAsociadoId());

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
  int calcularProg(List<Horario> cosas){
    int suma = 0;
    for(int i = 0; i < cosas.length; i++){
      suma += cosas[i].getNumPills()!;
    }
    return suma;
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
        body: FutureBuilder(
            future: Future.wait([
              getDayPills(_selectedDay!, getUserAsociadoId()),
              estadisticas,
            ]),
            builder:(context, AsyncSnapshot<List<dynamic>> snapshot) {
              debugPrint('${getUserAsociadoId()}');
              if (snapshot.connectionState == ConnectionState.waiting && !iniciado) {
                iniciado = true;
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
               /*else if (!snapshot.hasData ) {
                return const Center(child: Text('Añade un medicamento para comenzar a usar la aplicación.'
                    ,textAlign: TextAlign.center,style: TextStyle(fontSize: 16)));
              }
                */
               else {
                 cosas =  snapshot.data?[0];
                 programadas = calcularProg(cosas);
                 Statistic_type data = snapshot.data?[1];
                 porcentajeSemanal = data.weekProg != 0? ((data.weekTaken / data.weekProg) * 100).round() : 100;
                 porcentajeDiario = data.taken != 0? ((data.taken / data.programmed) * 100).round() : 100;
                 porcentajeMensual = data.monthTaken != 0? ((data.monthTaken / data.monthProg) * 100).round() : 100;
                return Column(
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
                                    Text('Medicación tomada:   ${data.weekTaken} ($porcentajeSemanal%)', style: TextStyle(fontSize: 20)),
                                    const SizedBox(height: 20.0),
                                    Text('Total medicación a tomar:    ${data.weekProg}', style: TextStyle(fontSize: 20)),
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
                                  //currentDay: DateTime.now(),
                                  focusedDay: _focusedDay,
                                  calendarFormat: _calendarFormat,
                                  startingDayOfWeek: StartingDayOfWeek.monday,
                                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                                  onDaySelected: (selectedDay, focusedDay) { //Cambiar dia seleccionado
                                    if (!isSameDay(_selectedDay, selectedDay)) {
                                      setState(() {
                                        _selectedDay = selectedDay;
                                        _focusedDay = focusedDay;
                                        previous = -1;
                                        semanaprevia = 0;
                                        diaSeleccionado = weekdays[selectedDay.weekday-1];
                                        estadisticas = getSta(_selectedDay!, _selectedDay!, getUserAsociadoId());
                                        //TODO Posible necesidad de metodo actualizar con setState vacio
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
                                      estadisticas = getSta(_selectedDay!, dia, getUserAsociadoId());
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
                                          Text('Medicación tomada:   ${data.taken} ($porcentajeDiario%)', style: TextStyle(fontSize: 20)),
                                          const SizedBox(height: 20.0),
                                          Text(_selectedDay!.isBefore(DateTime.now())?
                                          'Total medicación a tomar:    ${data.programmed}':'Total medicación a tomar:    ${programadas}',
                                              style: TextStyle(fontSize: 20)),
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
                                                itemCount:data.taken > 0 ? data.getTakenQ().length : 1,
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  if(data.taken > 0) {
                                                    String takenName = data.getTakenName()[index];
                                                    int takenQ = data.getTakenQ()[index];

                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(),
                                                        borderRadius: BorderRadius
                                                            .circular(12.0),
                                                      ),
                                                      child: ListTile(
                                                        //onTap: () => , TODO meter aqui informacion medicamento?
                                                        title: Text('${takenName}'),
                                                        subtitle: Text(
                                                            'Cantidad: ${takenQ} ud.'),
                                                      ),
                                                    );
                                                  }
                                                  else {
                                                    return const Padding(
                                                      padding:  EdgeInsets.only(top: 25.0, bottom: 15.0),
                                                      child: Center(
                                                        child: Text("No hay medicación tomada este día"),
                                                      ),
                                                    );
                                                  }
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
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount:
                                                (_selectedDay!.isBefore(DateTime.now()) && esHoy(_selectedDay!))?
                                                calcularItemCount(cosas, data):
                                                (_selectedDay!.isBefore(DateTime.now())&&!esHoy(_selectedDay!))?
                                                (data.getNotTakenId().isNotEmpty ? data.getNotTakenId().length : 1) :
                                                cosas.isNotEmpty? cosas.length : 1,
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  //PASADO
                                                  if(_selectedDay!.isBefore(DateTime.now())&&!esHoy(_selectedDay!)) {
                                                    if (data.getNotTakenId().isNotEmpty) {
                                                      String nottakenName = data
                                                          .getNotTakenName()[index];

                                                      int nottakenQ = data
                                                          .getNotTakenQ()[index];

                                                      return Container(
                                                        decoration: BoxDecoration(
                                                          border: Border.all(),
                                                          borderRadius: BorderRadius
                                                              .circular(12.0),
                                                        ),
                                                        child: ListTile(
                                                          //onTap: () => , TODO meter aqui informacion medicamento?
                                                          title: Text(
                                                              '${nottakenName}'),
                                                          subtitle: Text(
                                                              'Cantidad: ${nottakenQ} ud.'),
                                                        ),
                                                      );
                                                    }
                                                    else {
                                                      return const Padding(
                                                        padding:  EdgeInsets.only(top: 25.0, bottom: 15.0),
                                                        child: Center(
                                                          child: Text("No hay medicación no tomada este día"),
                                                        ),
                                                      );
                                                    }
                                                  }
                                                  //HOY!
                                                  else if(_selectedDay!.isBefore(DateTime.now())&& esHoy(_selectedDay!)) {
                                                    List<Horario> sinTomar = getSinTomar(cosas, data);
                                                    if (sinTomar.isNotEmpty) {
                                                       String nottakenName = sinTomar[index]
                                                            .getPillName()!;
                                                       int nottakenQ = sinTomar[index]
                                                            .getNumPills()!;
                                                      return Container(
                                                        decoration: BoxDecoration(
                                                          border: Border.all(),
                                                          borderRadius: BorderRadius
                                                              .circular(12.0),
                                                        ),
                                                        child: ListTile(
                                                          //onTap: () => , TODO meter aqui informacion medicamento?
                                                          title: Text(
                                                              '${nottakenName}'),
                                                          subtitle: Text(
                                                              'Cantidad: ${nottakenQ} ud.'),
                                                        ),
                                                      );
                                                    }
                                                    else {
                                                      return const Padding(
                                                        padding:  EdgeInsets.only(top: 25.0, bottom: 15.0),
                                                        child: Center(
                                                          child: Text("No hay medicación no tomada este día"),
                                                        ),
                                                      );
                                                    }
                                                  }
                                                  //FUTURO
                                                  else{
                                                    if (cosas.isNotEmpty) {
                                                      String nottakenName = cosas[index].getPillName()!;
                                                      int nottakenQ = cosas[index].getNumPills()!;
                                                      return Container(
                                                        decoration: BoxDecoration(
                                                          border: Border.all(),
                                                          borderRadius: BorderRadius
                                                              .circular(12.0),
                                                        ),
                                                        child: ListTile(
                                                          //onTap: () => , TODO meter aqui informacion medicamento?
                                                          title: Text(
                                                              '${nottakenName}'),
                                                          subtitle: Text(
                                                              'Cantidad: ${nottakenQ} ud.'),
                                                        ),
                                                      );
                                                    }
                                                    else {
                                                      return const Padding(
                                                        padding:  EdgeInsets.only(top: 25.0, bottom: 15.0),
                                                        child: Center(
                                                          child: Text("No hay medicación no tomada este día"),
                                                        ),
                                                      );
                                                    }
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
                                              Text('Medicación tomada:   ${data.monthTaken} ($porcentajeMensual%)', style: TextStyle(fontSize: 20)),
                                              const SizedBox(height: 20.0),
                                              Text('Total medicación a tomar:    ${data.monthProg}', style: TextStyle(fontSize: 20)),
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
                                                  previousMes = -1;
                                                  mesPrevio = 0;
                                                  diaSeleccionado = weekdays[selectedDay.weekday-1];
                                                  estadisticas = getSta(_selectedDay!, _selectedDay!, getUserAsociadoId());
                                                });
                                              }
                                            },
                                            onPageChanged: (focusedDay) {
                                              setState(() {
                                                _focusedDay = focusedDay;

                                                final difference2 = focusedDay.difference(_selectedDay!).inDays;
                                                if (mesPrevio < difference2 ) {
                                                  diaparaMes = diaparaMes.add(const Duration(days: 30));
                                                  previousMes = 1;
                                                  mesPrevio = difference2;

                                                } else if ( mesPrevio > difference2) {
                                                  diaparaMes = diaparaMes.subtract(const Duration(days: 30));
                                                  previousMes = 0;
                                                  mesPrevio = difference2;
                                                }
                                                else{
                                                  if(previousMes == 0){
                                                    diaparaMes = diaparaMes.add(const Duration(days: 30));
                                                  }
                                                  else if(previousMes == 1){
                                                    diaparaMes = diaparaMes.subtract(const Duration(days: 30));
                                                  }
                                                }
                                                estadisticas = getSta(_selectedDay!, diaparaMes, getUserAsociadoId());
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
                                                Text('Medicación tomada:   ${data.taken} ($porcentajeDiario%)', style: TextStyle(fontSize: 20)),
                                                const SizedBox(height: 20.0),
                                                Text(_selectedDay!.isBefore(DateTime.now())?
                                                'Total medicación a tomar:    ${data.programmed}':'Total medicación a tomar:    ${programadas}',
                                                    style: TextStyle(fontSize: 20)),
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
                                                          itemCount:data.taken > 0 ? data.getTakenQ().length : 1,
                                                          physics: const NeverScrollableScrollPhysics(),
                                                          itemBuilder: (context, index) {
                                                            if(data.taken > 0) {
                                                              String takenName = data.getTakenName()[index];
                                                              int takenQ = data.getTakenQ()[index];

                                                              return Container(
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(),
                                                                  borderRadius: BorderRadius
                                                                      .circular(12.0),
                                                                ),
                                                                child: ListTile(
                                                                  //onTap: () => , TODO meter aqui informacion medicamento?
                                                                  title: Text('${takenName}'),
                                                                  subtitle: Text(
                                                                      'Cantidad: ${takenQ} ud.'),
                                                                ),
                                                              );
                                                            }
                                                            else {
                                                              return const Padding(
                                                                padding:  EdgeInsets.only(top: 25.0, bottom: 15.0),
                                                                child: Center(
                                                                  child: Text("No hay medicación tomada este día"),
                                                                ),
                                                              );
                                                            }
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
                                                          itemCount:
                                                          (_selectedDay!.isBefore(DateTime.now()) && esHoy(_selectedDay!))?
                                                          calcularItemCount(cosas, data):
                                                          (_selectedDay!.isBefore(DateTime.now())&&!esHoy(_selectedDay!))?
                                                          (data.getNotTakenId().isNotEmpty ? data.getNotTakenId().length : 1) :
                                                          cosas.isNotEmpty? cosas.length : 1,
                                                          physics: const NeverScrollableScrollPhysics(),
                                                          itemBuilder: (context, index) {
                                                            //PASADO
                                                            if(_selectedDay!.isBefore(DateTime.now())&&!esHoy(_selectedDay!)) {
                                                              if (data.getNotTakenId().isNotEmpty) {
                                                                String nottakenName = data
                                                                    .getNotTakenName()[index];

                                                                int nottakenQ = data
                                                                    .getNotTakenQ()[index];

                                                                return Container(
                                                                  decoration: BoxDecoration(
                                                                    border: Border.all(),
                                                                    borderRadius: BorderRadius
                                                                        .circular(12.0),
                                                                  ),
                                                                  child: ListTile(
                                                                    //onTap: () => , TODO meter aqui informacion medicamento?
                                                                    title: Text(
                                                                        '${nottakenName}'),
                                                                    subtitle: Text(
                                                                        'Cantidad: ${nottakenQ} ud.'),
                                                                  ),
                                                                );
                                                              }
                                                              else {
                                                                return const Padding(
                                                                  padding:  EdgeInsets.only(top: 25.0, bottom: 15.0),
                                                                  child: Center(
                                                                    child: Text("No hay medicación no tomada este día"),
                                                                  ),
                                                                );
                                                              }
                                                            }
                                                            //HOY!
                                                            else if(_selectedDay!.isBefore(DateTime.now())&& esHoy(_selectedDay!)) {
                                                              List<Horario> sinTomar = getSinTomar(cosas, data);
                                                              if (sinTomar.isNotEmpty) {
                                                                String nottakenName = sinTomar[index]
                                                                    .getPillName()!;
                                                                int nottakenQ = sinTomar[index]
                                                                    .getNumPills()!;
                                                                return Container(
                                                                  decoration: BoxDecoration(
                                                                    border: Border.all(),
                                                                    borderRadius: BorderRadius
                                                                        .circular(12.0),
                                                                  ),
                                                                  child: ListTile(
                                                                    //onTap: () => , TODO meter aqui informacion medicamento?
                                                                    title: Text(
                                                                        '${nottakenName}'),
                                                                    subtitle: Text(
                                                                        'Cantidad: ${nottakenQ} ud.'),
                                                                  ),
                                                                );
                                                              }
                                                              else {
                                                                return const Padding(
                                                                  padding:  EdgeInsets.only(top: 25.0, bottom: 15.0),
                                                                  child: Center(
                                                                    child: Text("No hay medicación no tomada este día"),
                                                                  ),
                                                                );
                                                              }
                                                            }
                                                            //FUTURO
                                                            else{
                                                              if (cosas.isNotEmpty) {
                                                                String nottakenName = cosas[index].getPillName()!;
                                                                int nottakenQ = cosas[index].getNumPills()!;
                                                                return Container(
                                                                  decoration: BoxDecoration(
                                                                    border: Border.all(),
                                                                    borderRadius: BorderRadius
                                                                        .circular(12.0),
                                                                  ),
                                                                  child: ListTile(
                                                                    //onTap: () => , TODO meter aqui informacion medicamento?
                                                                    title: Text(
                                                                        '${nottakenName}'),
                                                                    subtitle: Text(
                                                                        'Cantidad: ${nottakenQ} ud.'),
                                                                  ),
                                                                );
                                                              }
                                                              else {
                                                                return const Padding(
                                                                  padding:  EdgeInsets.only(top: 25.0, bottom: 15.0),
                                                                  child: Center(
                                                                    child: Text("No hay medicación no tomada este día"),
                                                                  ),
                                                                );
                                                              }
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]
                                    )
                                )
                              ]
                          )
                      ),
                    ),
                  ],

                );
              }
            }
        ),
      );

  }


}

/*

Falta:

 A veces para cambios hechos muy rapido se raya con las fechas (yo ya paso)

  MENSUAL:
  ======== Exception caught by widgets library =======================================================
The following assertion was thrown while applying parent data.:
Incorrect use of ParentDataWidget.

The ParentDataWidget Expanded(flex: 1) wants to apply ParentData of type FlexParentData to a RenderObject, which has been set up to accept
ParentData of incompatible type ParentData.

Usually, this means that the Expanded widget has the wrong ancestor RenderObjectWidget. Typically, Expanded widgets are placed directly inside Flex widgets.
The offending Expanded is currently placed inside a RepaintBoundary widget.

 */
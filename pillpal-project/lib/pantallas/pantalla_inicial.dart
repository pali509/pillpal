
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pillpal/constants/colors.dart';
import 'package:pillpal/pantallas/pantalla_perfil.dart';
import '../utils/db_connections.dart';
import '../utils/horario.dart';
import '../utils/statistic_type.dart';
import '../utils/user.dart';
import 'navigation_drawer.dart';

class PantallaInicial extends StatefulWidget {
  const PantallaInicial({super.key});

  @override
  _PantallaInicialState createState() => _PantallaInicialState();
}
  class _PantallaInicialState extends State<PantallaInicial> {
    List<Horario> cosas = [];
    List<Horario> cosas0 = [];
    List<Horario> cosas1 = [];
    List<Horario> cosas2 = [];
    List<Horario> cosas3 = [];
    List<Horario> cosas4 = [];

    List<String> weekdays = ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"];
    List<String> months= ["enero", "febrero", "marzo", "abril", "mayo", "junio", "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre",];
    DateTime diaSeleccionado = DateTime.now();


    bool visibleOtros = false;

    late Statistic_type stats;
    List<String> nombres = [];

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Medicación de hoy',
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
              const SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, //No centra las cosas bien :/
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, size: 30.0), // Left arrow icon
                    onPressed: () {
                      setState(() {
                        if(diaSeleccionado.weekday != 0)
                        diaSeleccionado = diaSeleccionado.subtract(Duration(days: 1));
                      });
                    },
                  ),
                  Text("${weekdays[diaSeleccionado.weekday - 1]}, ${diaSeleccionado.day} ${months[diaSeleccionado.month - 1]}",style: TextStyle(fontSize: 26.0)),

                  IconButton(
                    icon: Icon(Icons.arrow_forward, size: 30.0), // Left arrow icon
                    onPressed: () {
                      setState(() {
                        diaSeleccionado = diaSeleccionado.add(Duration(days: 1));
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30.0),
              Expanded(
                child: FutureBuilder(
                  future: Future.wait([
                    getDayPills(diaSeleccionado, getUserAsociadoId()),
                    getStaDia(diaSeleccionado, getUserAsociadoId()),
                  ]),
                  builder:(context, AsyncSnapshot<List<dynamic>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      stats = snapshot.data?[1];
                      nombres = stats.getTakenName();
                      cosas = snapshot.data?[0];
                      cosas1 = cogerSegunMomento(cosas, 1); //Para coger solo las del desayuno
                      cosas2 = cogerSegunMomento(cosas, 2); //Solo comida
                      cosas3 = cogerSegunMomento(cosas, 3); //Solo cena
                      cosas4 = cogerSegunMomento(cosas, 4); //Solo dormir
                      cosas0 = cogerSegunMomento(cosas, 0);

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

                          Container(

                              child: ListView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children:[
                                  const Text(
                                    ' Cena',
                                    style: TextStyle(color: Colors.black, fontSize: 25),
                                  ),

                                  Container(

                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.red, width: 5),
                                    ),
                                    child: ListView.builder( //Esto es igual que el de pantalla pastillero
                                      shrinkWrap: true,
                                      itemCount: cosas3.length > 0 ? cosas3.length : 1,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        if(cosas3.isNotEmpty) {
                                          Horario currentCosa = cosas3[index];
                                          return Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(),
                                              borderRadius: BorderRadius
                                                  .circular(12.0),
                                            ),
                                            child: ListTile(
                                              onTap: () =>
                                                  print('${cosas3[index]}'),
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
                                              child: Text("No hay medicación programada para la cena este dia"),
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
                                    ' Dormir',
                                    style: TextStyle(color: Colors.black, fontSize: 25),
                                  ),

                                  Container(

                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.cyanAccent, width: 5),
                                    ),
                                    child: ListView.builder( //Esto es igual que el de pantalla pastillero
                                      shrinkWrap: true,
                                      itemCount: cosas4.length > 0 ? cosas4.length : 1, //cambiar por cosas 4 !!!!!!!!!!!!!!!!!!
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        if(cosas4.isNotEmpty) {
                                          Horario currentCosa = cosas4[index];
                                          return Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(),
                                              borderRadius: BorderRadius
                                                  .circular(12.0),
                                            ),
                                            child: ListTile(
                                              onTap: () =>
                                                  print('${cosas4[index]}'),
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
                                              child: Text("No hay medicación programada para dormir este dia"),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          Visibility(
                            visible: visibleOtros,
                            child: Container(

                              child: ListView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children:[
                                  const Text(
                                    ' Otros',
                                    style: TextStyle(color: Colors.black, fontSize: 25),
                                  ),

                                  Container(

                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.blueGrey, width: 5),
                                    ),
                                    child: ListView.builder( //Esto es igual que el de pantalla pastillero
                                      shrinkWrap: true,
                                      itemCount: cosas0.length,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        Horario currentCosa = cosas0[index];
                                        bool tomado = false;
                                        if(nombres.contains(currentCosa.getPillName())){
                                          tomado = true;
                                          nombres.remove(currentCosa.getPillName());
                                        }
                                        /*
                                        debugPrint('${stats.taken}');
                                        debugPrint('${stats.getTakenName()}');
                                        debugPrint('${currentCosa.getPillName()}');
                                        debugPrint('${stats.getTakenName().contains(currentCosa.getPillName())}');
                                         */
                                          return Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(),
                                              borderRadius: BorderRadius.circular(12.0),
                                            ),
                                            child: ListTile(
                                              onTap: () => print('${cosas0[index]}'),
                                              title: Text(
                                                  '${currentCosa.getPillName()}',
                                              style: TextStyle(
                                                decoration:
                                                tomado?
                                                TextDecoration.lineThrough : TextDecoration.none,
                                              ),
                                              ),
                                              subtitle: Text('Cantidad: ${currentCosa
                                                  .getNumPills()} ud.     Tomar a las: ${currentCosa
                                                  .getHour()}'),
                                            ),
                                          );

                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
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

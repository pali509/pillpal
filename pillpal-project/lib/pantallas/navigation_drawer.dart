import 'package:flutter/material.dart';
import 'package:pillpal/pantallas/pantalla_inicial.dart';
import 'package:pillpal/pantallas/pantalla_pastillero.dart';
import 'package:pillpal/constants/colors.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key});
  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 80, // Altura personalizada del DrawerHeader
              decoration: const BoxDecoration(
                color: ColorsApp.toolBarColor,
              ),
          ),
          Container(
            height: 100,
            child: ListTile(
              title: const Text(
                  'Medicación de hoy',
                   style: TextStyle(fontSize: 30.0),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),//Para que este centrado el texto
              onTap: () {
                Navigator.pop(context);
                if (ModalRoute.of(context)!.settings.name != '/home') {
                  Navigator.pushReplacementNamed(context, '/home');
                }
              },
            ),
          ),
          Container(
            height: 100,
            child: ListTile(
              title: const Text(
                'Medicamentos',
                style: TextStyle(fontSize: 30.0),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              onTap: () {
                Navigator.pop(context);
                if (ModalRoute.of(context)!.settings.name != '/pastis') {
                  Navigator.pushReplacementNamed(context, '/pastis');
                }
              },
            ),
          ),
          Container(
            height: 100,
            child: ListTile(
              title: const Text(
                'Calendario',
                style: TextStyle(fontSize: 30.0),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              onTap: () {
                Navigator.pop(context);
                if (ModalRoute.of(context)!.settings.name != '/calendario') {
                  Navigator.pushReplacementNamed(context, '/calendario');
                }
              },
            ),
          ),
          Container(
            height: 100,
            child: ListTile(
              title: const Text(
                'Recordatorios',
                style: TextStyle(fontSize: 30.0),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              onTap: () {
                Navigator.pop(context);
                if (ModalRoute.of(context)!.settings.name != '/alarmas') {
                  Navigator.pushReplacementNamed(context, '/alarmas');
                }
              },
            ),
          ),
          Container(
            height: 100,
            child: ListTile(
              title: const Text(
                'Estadísticas',
                style: TextStyle(fontSize: 30.0),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              onTap: () {
                Navigator.pop(context);
                if (ModalRoute.of(context)!.settings.name != '/estadisticas') {
                  Navigator.pushReplacementNamed(context, '/estadisticas');
                }
              },
            ),
          ),
        ],
      ),

    );
  }
}
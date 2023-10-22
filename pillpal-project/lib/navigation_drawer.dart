import 'package:flutter/material.dart';
import 'package:pillpal/pantalla_inicial.dart';
import 'package:pillpal/pantalla_pastillero.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Menú de Navegación'),
          ),
          ListTile(
            title: const Text('Medicación de hoy'),
            onTap: () {
              Navigator.pop(context); // Cierra el Drawer.

              // Verifica si ya estás en HomePage y no realices una nueva navegación.
              if (ModalRoute.of(context)!.settings.name != '/home') {
                Navigator.pushReplacementNamed(context, '/home');
              }
            },
          ),
          ListTile(
            title: const Text('Pastillero'),
            onTap: () {
              Navigator.pop(context); // Cierra el Drawer.

              // Verifica si ya estás en HomePage y no realices una nueva navegación.
              if (ModalRoute.of(context)!.settings.name != '/pastis') {
                Navigator.pushReplacementNamed(context, '/pastis');
              }
            },
          ),
        ],
      ),
    );
  }
}
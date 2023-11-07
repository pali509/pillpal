
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'navigation_drawer.dart';
class PantallaInicial extends StatelessWidget {
  const PantallaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Medicación de hoy',
          style: TextStyle(fontSize: 25.0),
        ),
        backgroundColor: Colors.blue,
      ),
      drawer: MyDrawer(),
      body: Center(
        child: Text('Esta es la página de inicio'),
      ),
    );
  }
}
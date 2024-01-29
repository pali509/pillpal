
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pillpal/constants/colors.dart';

import 'navigation_drawer.dart';
class PantallaCalendario extends StatelessWidget {
  const PantallaCalendario({super.key});

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
      body: Center(
        child: Text('Esta es la página de inicio'),
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../utils/db_connections.dart';
import 'navigation_drawer.dart';


class InfoMed extends StatefulWidget {
  InfoMed({super.key});
  @override
  State<InfoMed> createState() => InfoMedState();

}

class InfoMedState extends State<InfoMed>{
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pushReplacementNamed('/pastis');
          return true;
        },

    child: Scaffold(
      appBar: AppBar(
        title: const Text(
          'Información',
          style: TextStyle(fontSize: 25.0),
        ),
        backgroundColor: ColorsApp.toolBarColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Aquí puedes ejecutar tu lógica al presionar la flecha de retroceso
            Navigator.of(context).pushReplacementNamed('/pastis');
          },
        ),
      ),
      body: Center(
        child: Text('Esta es la página de inicio'),
      ),
    ),
    );

  }


}
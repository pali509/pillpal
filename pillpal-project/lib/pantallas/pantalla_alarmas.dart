import 'package:flutter/material.dart';
import 'package:pillpal/utils/alarma_type.dart';
import 'package:pillpal/utils/user.dart';

import '../utils/db_connections.dart';

class AlarmaScreen extends StatefulWidget {
  @override
  _AlarmaScreenState createState() => _AlarmaScreenState();
}

class _AlarmaScreenState extends State<AlarmaScreen> {
  Future<List<Alarma_type>> _alarmasFuturo = Future.value([]);

  @override
  void initState() {
    super.initState();
    _cargarAlarmas();
  }

  Future<void> _cargarAlarmas() async {
    setState(() {
      _alarmasFuturo = getAlarmas(getUserAsociadoId()); // Tu función para obtener datos
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alarmas'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: FutureBuilder<List<Alarma_type>>(
              future: _alarmasFuturo,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final alarma = snapshot.data![index];
                      return Text(alarma.getPillName()!);
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error al cargar alarmas: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
          ElevatedButton(
            onPressed: null, // El botón no hace nada al pulsarlo
            child: Text('Ayuda'),
          ),
        ],
      ),
    );
  }
}
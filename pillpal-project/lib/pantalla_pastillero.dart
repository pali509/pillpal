import 'package:flutter/material.dart';

import 'navigation_drawer.dart';

class Pastillero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Pastillero',
        style: TextStyle(fontSize: 25.0),
      ),
          backgroundColor: Colors.lightGreen,
      ),
      drawer: MyDrawer(),
      body: const Center(
        child: Text('Esta es otra página'),
      ),
    );
  }
}
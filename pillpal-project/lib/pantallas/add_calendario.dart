import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../database/db_connections.dart';
import '../database/pills.dart';
import '../database/user.dart';
import 'navigation_drawer.dart';


class DropdownMenuApp extends StatelessWidget {
  const DropdownMenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(title: const Text('DropdownMenu Sample')),
        body: const Center(
          child: DropdownMenuExample(),
        ),
      ),
    );
  }
}

class DropdownMenuExample extends StatefulWidget {
  const DropdownMenuExample({super.key});

  @override
  State<DropdownMenuExample> createState() => _DropdownMenuExampleState();
}

class _DropdownMenuExampleState extends State<DropdownMenuExample> {
  List<String>? dropdown_lista;

  @override
  void initState() {
    super.initState();
    dropdown_lista = obtenerNombres() as List<String>?;
  }

  @override
  Future<List<String>?> obtenerNombres() async {
    List<Pill>? listaPills = await getPills(getUserAsociadoId()); // Esperamos a que la lista esté disponible
    if (listaPills != null) {
      List<String> nombres = listaPills.map((pill) => pill.pillName ?? "").toList();
      return nombres;
    } else {
      return null; // Si la lista es nula, devolvemos null
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: dropdown_lista?.first,
      onSelected: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdown_lista?.first = value!;
        });
      },
      dropdownMenuEntries: dropdown_lista!.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../database/db_connections.dart';
import '../database/pills.dart';
import '../database/user.dart';
import 'navigation_drawer.dart';
import 'dart:io';


class AddCalendario extends StatefulWidget {
  const AddCalendario({Key? key}) : super(key: key);

  @override
  _AddState createState() => _AddState();
}



class _AddState extends State<AddCalendario> {
  String? name;

  @override
  List<String> getAll() {
    List<String> _listProducts = [];
    Future<List<Pill>>? lista = getPills(getUserAsociadoId());
    //sleep(Duration(seconds:60));
    lista?.then((value) {
      if (value != null) {
        for (var item in value) {
            debugPrint(item.pillName!);
           _listProducts.add(item.pillName!);
            //debugPrint(_listProducts.toString());
        }
      }
    });

    debugPrint(_listProducts.toString());
    return _listProducts;
  }

  @override
  Widget build(BuildContext context) {
    //dropdown_lista = obtenerNombres() as List<String>?;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Añadir pastilla al calendario',
            style: TextStyle(fontSize: 25.0),
          ),
          backgroundColor: ColorsApp.toolBarColor,
        ),
        drawer: MyDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 15, right: 200, top: 15.0, bottom: 0),
                child:DropdownMenu<String>(
                  onSelected: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      name = value!;
                    });
                  },
                  dropdownMenuEntries: getAll().map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(value: value, label: value);
                  }).toList(),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: Container(
                  height: 50,
                  width: 250,

                  child: ElevatedButton(
                    onPressed: () async {
                      // Guarda el texto de los campos en las variables email y password
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple, // Ajusta el color del fondo aquí
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Añadir',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),




        /*DropdownMenu<String>(
          child:
          Column(
                children: <Widget>[
            Padding(
            padding:EdgeInsets.only(left: 15, right:15, top:40),
            child: TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nombre',
                hintText: 'Tu nombre de usuario',
              ),
            ),
          ),
            initialSelection: dropdown_lista?.first,
            onSelected: (String? value) {
              // This is called when the user selects an item.
              /*setState(() {
                dropdown_lista?.first = value!;
              });*/
            },
            dropdownMenuEntries: dropdown_lista!.map<DropdownMenuEntry<String>>((
                String value) {
              return DropdownMenuEntry<String>(value: value, label: value);
            }).toList(),
          )*/
    );
  }
}
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../utils/db_connections.dart';

import 'package:pillpal/constants/colors.dart';

import '../../email.dart';
import '../../utils/user.dart';

class ConfigurarHorario extends StatefulWidget {
  const ConfigurarHorario({Key? key}) : super(key: key);

  @override
  _ConfigurarHorarioState createState() => _ConfigurarHorarioState();
}

class _ConfigurarHorarioState extends State<ConfigurarHorario> {
  TimeOfDay _horaDesayuno = TimeOfDay.now();
  TimeOfDay _horaComer = TimeOfDay.now();
  TimeOfDay _horaCenar = TimeOfDay.now();
  TimeOfDay _horaDormir = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsApp.backgroundColor,
      appBar: AppBar(
        title: const Text("Configurar horario de toma"),
        backgroundColor: ColorsApp.toolBarColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "¡Bienvenido a Pill-Pal!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Para poder empezar a usar la aplicación, por favor selecciona los momentos del día en los que quieres que Pill-Pal te recuerde tomar tu medicación.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 32),
              // Aquí empieza la Column original
              Row(
                children: [
                  const Text('Hora del desayuno:', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 45),
                  Expanded(
                    child: Text(_horaDesayuno.format(context), style: const TextStyle(fontSize: 18))
                  ),
                  IconButton(
                    onPressed: () async {
                      TimeOfDay? hora = await showTimePicker(
                        context: context,
                        initialTime: _horaDesayuno,
                        hourLabelText: "Seleccione hora",
                        minuteLabelText: "Seleccione minuto",
                        cancelText: "Cancelar",
                        helpText: "Seleccionar hora",
                      );
                      if (hora != null) {
                        setState(() {
                          _horaDesayuno = hora;
                        });
                      }
                    },
                    icon: const Icon(Icons.access_time),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('Hora de comer:', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 75),
                  Expanded(
                    child: Text(_horaComer.format(context), style: const TextStyle(fontSize: 18))
                  ),
                  IconButton(
                    onPressed: () async {
                      TimeOfDay? hora = await showTimePicker(
                        context: context,
                        initialTime: _horaComer,
                        hourLabelText: "Seleccione hora",
                        minuteLabelText: "Seleccione minuto",
                        cancelText: "Cancelar",
                        helpText: "Seleccionar hora",
                      );
                      if (hora != null) {
                        setState(() {
                          _horaComer = hora;
                        });
                      }
                    },
                    icon: const Icon(Icons.access_time),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('Hora de cenar:', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 80),
                  Expanded(
                    child: Text(_horaCenar.format(context), style: const TextStyle(fontSize: 18))
                  ),
                  IconButton(
                    onPressed: () async {
                      TimeOfDay? hora = await showTimePicker(
                        context: context,
                        initialTime: _horaCenar,
                        hourLabelText: "Seleccione hora",
                        minuteLabelText: "Seleccione minuto",
                        cancelText: "Cancelar",
                        helpText: "Seleccionar hora",
                      );
                      if (hora != null) {
                        setState(() {
                          _horaCenar = hora;
                        });
                      }
                    },
                    icon: const Icon(Icons.access_time),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('Hora de dormir:', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 70),
                  Expanded(
                    child: Text(_horaDormir.format(context), style: const TextStyle(fontSize: 18))
                  ),
                  IconButton(
                    onPressed: () async {
                      TimeOfDay? hora = await showTimePicker(
                        context: context,
                        initialTime: _horaDormir,
                        hourLabelText: "Seleccione hora",
                        minuteLabelText: "Seleccione minuto",
                        cancelText: "Cancelar",
                        helpText: "Seleccionar hora",
                      );
                      if (hora != null) {
                        setState(() {
                          _horaDormir = hora;
                        });
                      }
                    },
                    icon: const Icon(Icons.access_time),
                  ),
                ],
              ),

              Padding(
                padding: EdgeInsets.only(top: 40.0),
                child: Container(
                  height: 50,
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () async {
                      if(getRoleId() != 1) {
                        updateUser(
                            getUserId(),
                            null,
                            null,
                            null,
                            _horaDesayuno.format(context),
                            _horaComer.format(context),
                            _horaCenar.format(context),
                            _horaDormir.format(context));

                      }
                      else {
                        updateUser(
                            getUserAsociadoId(),
                            null,
                            null,
                            null,
                            _horaDesayuno.format(context),
                            _horaComer.format(context),
                            _horaCenar.format(context),
                            _horaDormir.format(context));
                      }
                        Navigator.of(context).pushReplacementNamed('/home');
                      },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple, // Ajusta el color del fondo aquí
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Confirmar',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text('Estos datos y más se podrán modificar pulsando el icono del perfil una vez dentro de la aplicación.'
                  ,textAlign: TextAlign.center,style: TextStyle(fontSize: 16)),
            ],
          ),
        ),

      ),
    );
  }
}

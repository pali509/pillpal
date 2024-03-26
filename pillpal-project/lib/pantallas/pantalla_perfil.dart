


import 'package:flutter/cupertino.dart';
import 'package:pillpal/utils/user.dart';

class PantallaPerfil extends StatefulWidget {
  const PantallaPerfil({super.key});

  @override
  _PantallaPerfilState createState() => _PantallaPerfilState();
}
class _PantallaPerfilState extends State<PantallaPerfil> {
  @override
  Widget build(BuildContext context) {
    return const Column(
       crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        SizedBox(height: 20.0),
          Text(
            'Tu perfil',
            style: TextStyle(fontSize: 35.0),
          ),
          SizedBox(height: 30.0),
          Text(
            'Información de usuario:',
            style: TextStyle(fontSize: 30.0),
          ),
          SizedBox(height: 30.0),
          Text(
            '     Nombre usuario:',
            style: TextStyle(fontSize: 30.0),
          ),
          /*
          Cosas que queremos que aparezcan:
          Informacion usuario:
            Nombre usuario
            Correo
            Botón editar informacion usuario
          Informacion dependientes:
            Sus nombres y sus correos
            Boton editar informacion
          Informar de que dependiente se esta mirando ahora
          Boton cambiar dependiente
          Horario establecido
          Boton para cambiarlo
          Boton cerrar sesion
          Boton eliminar cuenta
           */
      ],
    );

  }

}

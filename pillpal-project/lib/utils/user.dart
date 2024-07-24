
import 'package:flutter/cupertino.dart';

    int? user_id;
    String? user_email;
    String? user_name;
    int? role_id, user_asociado;
    String? hora_desayuno, hora_comida, hora_cena, hora_dormir;

    void setUser(int? id, String? email, String? name, int? role, int? asociado,
        String ?desayuno, String ?comida, String ?cena, String ?dormir){
        user_id = id;
        user_email = email;
        user_name = name;
        role_id = role;
        user_asociado = asociado;
        hora_desayuno = desayuno;
        hora_comida = comida;
        hora_cena = cena;
        hora_dormir = dormir;
        debugPrint("'$user_email', '$user_id', '$user_name', $role, $user_asociado, $hora_desayuno");
    }

    int getUserId(){
        return user_id!;
    }

    int getUserAsociadoId(){
        return user_asociado!;
    }

    String getUserEmail(){
        return user_email!;
    }

    String getUserName(){
        return user_name!;
    }

    int getRoleId(){
        return role_id!;
    }

    String getHoraDesayuno(){
        return hora_desayuno!;
    }

    String getHoraComida(){
        return hora_comida!;
    }

    String getHoraCena(){
        return hora_cena!;
    }

    String getHoraDormir(){
        return hora_dormir!;
    }
void setUserEmail(String nuevoC){
    user_email = nuevoC;
}

void setUserName(String nuevoN){
     user_name = nuevoN;
}
void setHorarioAutosuficiente(String desayuno, String comida, String cena, String dormir){
    hora_desayuno = desayuno;
    hora_comida = comida;
    hora_cena = cena;
    hora_dormir = dormir;
}
void setUserAsociadoSoloId(int userN){
        user_asociado = userN;
}
void setUserAsociado(int userAs, String desayuno, String comida, String cena, String dormir){
    user_asociado = userAs;
    hora_desayuno = desayuno;
    hora_comida = comida;
    hora_cena = cena;
    hora_dormir = dormir;
}



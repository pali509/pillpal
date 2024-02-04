
import 'package:flutter/cupertino.dart';

int? user_id;
String? user_email;
String? user_name;
int? role_id, user_asociado; 

void setUser(int? id, String? email, String? name, int? role, int? asociado){
    user_id = id;
    user_email = email;
    user_name = name;
    role_id = role;
    user_asociado = asociado;
    debugPrint("'$user_email', '$user_id', '$user_name', $role, $user_asociado");
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
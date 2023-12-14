
import 'package:flutter/cupertino.dart';

int? user_id;
String? user_email;
String? user_name;
int? role_id;

void setUser(int? id, String? email, String? name, int? role){
    user_id = id;
    user_email = email;
    user_name = name;
    role_id = role;
    debugPrint("'$user_email', '$user_id', '$user_name', $role");
}

int getUserId(){
    return user_id!;
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
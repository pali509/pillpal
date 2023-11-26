
import 'package:flutter/cupertino.dart';

int? user_id;
String? user_email;
String? user_name;

void setUser(int? id, String? email, String? name){
    user_id = id;
    user_email = email;
    user_name = name;
    debugPrint("'$user_email', '$user_id', '$user_name'");
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
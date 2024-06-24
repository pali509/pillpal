import 'package:flutter/material.dart';

class Statistic_type{
  int taken = 0;
  int programmed = 0;
  List<String> takenName = [];
  List<int> takenQ = [];
  List<String> notTakenName = [];
  List<int> notTakenQ = [];

  // Constructor
  Statistic_type(int taken, int notTaken, String pills){
    this.taken = taken;
    this.programmed = notTaken;
    List<String> splitPills = pills.split(";");
    for(int i = 0; i < splitPills.length; i = i+3){
      if(splitPills[i+2] == "Si"){
        takenName.add(splitPills[i+1]);
        takenQ.add(int.parse(splitPills[i]));
      }
      else{
        notTakenName.add(splitPills[i+1]);
        notTakenQ.add(int.parse(splitPills[i]));
      }
    }
  }

  int getTaken(){
    return taken;
  }

  List<String> getTakenName(){
    return takenName;
  }

  List<int> getTakenQ(){
    return takenQ;
  }

  int getProgrammed(){
    return programmed;
  }

  List<String> getNotTakenName(){
    return notTakenName;
  }

  List<int> getNotTakenQ(){
    return notTakenQ;
  }
}
import 'package:flutter/material.dart';

class Statistic_type{
  int taken = 0;
  int programmed = 0;
  List<String> takenName = [];
  List<int> takenQ = [];
  List<int> takenId = [];
  List<String> notTakenName = [];
  List<int> notTakenQ = [];
  List<int> notTakenId = [];

  // Constructor
  Statistic_type(int taken, int notTaken, String pills){
    this.taken = taken;
    this.programmed = notTaken;
    List<String> splitPills = pills.split(";");
    for(int i = 0; i < splitPills.length; i = i+4){
      if(splitPills[i+3] == "Si"){
        takenName.add(splitPills[i+1]);
        takenQ.add(int.parse(splitPills[i]));
        takenId.add(int.parse(splitPills[i+2]));
      }
      else{
        notTakenName.add(splitPills[i+1]);
        notTakenQ.add(int.parse(splitPills[i]));
        notTakenId.add(int.parse(splitPills[i+2]));
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

  List<int> getTakenId(){
    return takenId;
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

  List<int> getNotTakenId(){
    return notTakenId;
  }
}
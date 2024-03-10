import 'package:flutter/material.dart';

class Horario{
    String? hour;
    int ?numPills;
    String? pillName;
    int ?timeOfDay;

    // Constructor
    Horario(this.hour, this.numPills, this.pillName, this.timeOfDay);

    String? getHour(){
        return hour;
    }

    int? getNumPills() {
        return numPills;
    }

    String? getPillName(){
      return pillName;
    }

    int? getTimeOfDay() {
      return timeOfDay;
    }
}
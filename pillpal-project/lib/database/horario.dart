import 'package:flutter/material.dart';

class Horario{
    String? hour;
    int ?numPills;
    String? pillName;
    int ?period;

    // Constructor
    Horario(this.hour, this.numPills, this.pillName, this.period);

    String? getHour(){
        return hour;
    }

    int? getNumPills() {
        return numPills;
    }

    String? getPillName(){
      return pillName;
    }

    int? getPeriod() {
      return period;
    }
}
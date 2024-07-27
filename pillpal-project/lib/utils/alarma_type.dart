import 'dart:core';

import 'package:flutter/material.dart';

class Alarma_type{
  String? hour;
  int? numPills;
  String? pillName;
  int? timeOfDay;
  int? id;
  int? alarm_id;
  DateTime? day;
  int? period;
  String? days;
  int? pill_id;

  // Constructor
  Alarma_type(this.hour, this.numPills, this.pillName, this.timeOfDay,
      this.id, this.alarm_id, this.period,
      this.day, this.days, this.pill_id);

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

  int? getId() {
    return id;
  }

  int? getAlarmId() {
    return alarm_id;
  }

  int? getPeriod() {
    return period;
  }

  String? getDays(){
    return days;
  }

  String? getDay() {
    return day.toString();
  }

  int? getPillId(){
    return pill_id;
  }
}
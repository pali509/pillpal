import 'package:flutter/material.dart';

class Pill{
    int? pillId;
    int ?numPills;
    String? pillName;
    int ?userId;

    // Constructor
    Pill(this.pillId, this.numPills, this.pillName, this.userId);
    
    int? getPillId(){
        return pillId;
    }
}
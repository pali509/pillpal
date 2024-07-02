import 'package:flutter/material.dart';

class Pill{
    int? pillId;
    int ?numPills;
    String? pillName;
    int ?userId;
    String? type;

    // Constructor
    Pill(this.pillId, this.numPills, this.pillName, this.userId, this.type);
    
    int? getPillId(){
        return pillId;
    }

    int? getUserId() {
        return userId;
    }

    String? getType(){
        return type;
    }
}
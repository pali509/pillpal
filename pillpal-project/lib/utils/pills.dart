import 'package:flutter/material.dart';

class Pill{
    int? pillId;
    int ?numPills;
    String? pillName;
    int ?userId;
    String? type;
    String? url;

    // Constructor
    Pill(this.pillId, this.numPills, this.pillName, this.userId, this.type, this.url);
    
    int? getPillId(){
        return pillId;
    }

    int? getUserId() {
        return userId;
    }

    String? getType(){
        return type;
    }
    String? getUrl() {
        return url;
    }
}
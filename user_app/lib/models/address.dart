import "package:flutter/material.dart";

class Address {
  String? id;
  String? roomNo;
  String? hostel;

  Address({this.id, this.roomNo, this.hostel});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    roomNo = json['RoomNo'];
    hostel = json['Hostel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['RoomNo'] = this.roomNo;
    data['Hostel'] = this.hostel;
    return data;
  }
}

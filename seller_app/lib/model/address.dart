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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['RoomNo'] = roomNo;
    data['Hostel'] = hostel;
    return data;
  }
}

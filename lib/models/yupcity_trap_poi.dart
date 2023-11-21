import 'package:flutter/foundation.dart';

class YupcityTrapPoi {
  String? sId;
  String? center;
  String? centerDescription;
  String? customer;
  String? type;
  String? lock1;
  String? lockMac1;
  String? lockData1;
  int? lockState1;
  String? lock2;
  String? lockMac2;
  String? lockData2;
  int? lockState2;
  String? lock3;
  String? lockMac3;
  String? lockData3;
  int? lockState3;
  String? lock4;
  String? lockMac4;
  String? lockData4;
  int? lockState4;
  double? lat;
  double? lon;
  int? iV;
  int? logs;
  String? createdAt;
  late int numberOfUses;

  YupcityTrapPoi(
      {this.sId,
        this.center,
        this.centerDescription,
        this.customer,
        this.type,
        this.lat,
        this.lon,
        this.lock1,
        this.lockMac1,
        this.lockData1,
        this.lockState1,

        this.lock2,
        this.lockMac2,
        this.lockData2,
        this.lockState2,

        this.lock3,
        this.lockMac3,
        this.lockData3,
        this.lockState3,

        this.lock4,
        this.lockMac4,
        this.lockData4,
        this.lockState4,

        this.iV,
        this.logs,
        this.createdAt,
        this.numberOfUses = 00,
      });

  YupcityTrapPoi.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    center = json['center'];
    centerDescription = json['center_description'];
    if (json['lat'] == 0) {
      lat = 0.0;
    }
    else {
      lat = json['lat'];
    }
    if (json['lon'] == 0) {
      lon = 0.0;
    }
    else {
      lon = json['lon'];
    }
    type = json['type'];
    customer = json['customer'];
    lock1 = json['lock1'];
    lock2 = json['lock2'];
    lock3 = json['lock3'];
    lock4 = json['lock4'];
    lockMac1 = json['lockMac1'];
    lockMac2 = json['lockMac2'];
    lockMac3 = json['lockMac3'];
    lockMac4 = json['lockMac4'];
    lockData1 = json['lockData1'];
    lockData2 = json['lockData2'];
    lockData3 = json['lockData3'];
    lockData4 = json['lockData4'];
    lockState1 = json['lockState1'];
    lockState2 = json['lockState2'];
    lockState3 = json['lockState3'];
    lockState4 = json['lockState4'];
    iV = json['__v'];
    logs = json['logs'];
    createdAt = json['createdAt'];
    numberOfUses = 00;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['center'] = this.center;
    data['center_description'] = this.centerDescription;
    data['customer'] = this.customer;
    data['type'] = this.type;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['__v'] = this.iV;
    data['lock1'] = this.lock1;
    data['lockMac1'] = this.lockMac1;
    data['lockData1'] = this.lockData1;
    data['lockState1'] = this.lockState1;
    data['lock2'] = this.lock2;
    data['lockMac2'] = this.lockMac2;
    data['lockData2'] = this.lockData2;
    data['lockState2'] = this.lockState2;
    data['lock3'] = this.lock3;
    data['lockMac3'] = this.lockMac3;
    data['lockData3'] = this.lockData3;
    data['lockState3'] = this.lockState3;
    data['lock4'] = this.lock4;
    data['lockMac4'] = this.lockMac4;
    data['lockData4'] = this.lockData4;
    data['lockState4'] = this.lockState4;
    data['logs'] = this.logs;
    data['createdAt'] = this.createdAt;
    data['number_of_uses'] = this.numberOfUses;
    debugPrint(data.toString());
    return data;
  }
}
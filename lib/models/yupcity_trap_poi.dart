class YupcityTrapPoi {
  String? sId;
  String? center;
  String? centerDescription;
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
        this.lat,
        this.lon,
        this.iV,
        this.logs,
        this.createdAt,
        this.numberOfUses = 00,
      });

  YupcityTrapPoi.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    center = json['center'];
    centerDescription = json['center_description'];
    lat = json['lat'];
    lon = json['lon'];
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
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['__v'] = this.iV;
    data['logs'] = this.logs;
    data ['createdAt'] = this.createdAt;
    data ['number_of_uses'] = this.numberOfUses;
    return data;
  }
}
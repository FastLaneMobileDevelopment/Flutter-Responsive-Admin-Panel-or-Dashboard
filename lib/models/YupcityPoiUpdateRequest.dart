class YupcityPoiUpdateRequest {
  String? center;
  String? centerDescription;
  double? lat;
  double? lon;
  String? type;
  String? customer;

  YupcityPoiUpdateRequest(
      {this.center, this.centerDescription, this.lat, this.lon, this.type, this.customer});

  YupcityPoiUpdateRequest.fromJson(Map<String, dynamic> json) {
    center = json['center'];
    centerDescription = json['center_description'];
    lat = json['lat'];
    lon = json['lon'];
    type = json['type'];
    customer = json['customer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['center'] = this.center;
    data['center_description'] = this.centerDescription;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['type'] = this.type;
    data['customer'] = this.customer;
    return data;
  }
}
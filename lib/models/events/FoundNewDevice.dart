
class FoundNewDevice {

   String name = "";

   String mac = "";

   String lockData = "";

  @override
  int get hashCode => this.mac.hashCode;

  @override
  bool operator ==(Object other) {
    if (!(other is FoundNewDevice)) return false;
    return this.mac == other.mac;
  }



  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['mac'] = this.mac;
    data['lockData'] = this.lockData;
    return data;
  }

  FoundNewDevice(
      {
         this.name = "",
         this.mac = "",
         this.lockData = ""
      });

  FoundNewDevice.fromJson(Map<String, dynamic> json) {
    this.name =  json['name'];
    this.mac =  json['mac'];
    this.lockData =  json['lockData'];
  }
}


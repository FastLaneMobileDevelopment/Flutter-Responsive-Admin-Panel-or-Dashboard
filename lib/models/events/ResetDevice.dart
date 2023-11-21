
class ResetDevice {

   String trapId = "";

   String lockId = "";

   String lockData = "";

  @override
  int get hashCode => this.lockData.hashCode;

  @override
  bool operator ==(Object other) {
    if (!(other is ResetDevice)) return false;
    return this.lockData == other.lockData;
  }



  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trapId'] = this.trapId;
    data['lockId'] = this.lockId;
    data['lockData'] = this.lockData;
    return data;
  }

  ResetDevice(
      {
         this.trapId = "",
         this.lockId = "",
         this.lockData = ""
      });

  ResetDevice.fromJson(Map<String, dynamic> json) {
    this.trapId = json['trapId'];
    this.lockId = json['lockId'];
    this.lockData =  json['lockData'];
  }
}


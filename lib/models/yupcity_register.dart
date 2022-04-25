class YupcityRegister {
  String? sId;
  String? trap_id;
  String? exoId;
  String? userId;
  String? code;
  String? sessionId;
  String? action;
  String? minFromToClose;
  String? createdAt;
  String? updatedAt;
  int? iV;




  YupcityRegister(
      {this.sId,
        this.trap_id,
        this.exoId,
        this.sessionId,
        this.minFromToClose,
        this.userId,
        this.code,
        this.action,
        this.createdAt,
        this.updatedAt,
        this.iV});

  YupcityRegister.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    trap_id = json['key_id'];
    exoId = json['exo_id'];
    sessionId = json['sessionId'];
    action = json['action'];
    minFromToClose = json['minFromToClose'];
    userId = json['user_id'];
    code = json['code'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['key_id'] = this.trap_id;
    data['exo_id'] = this.exoId;
    data['minFromToClose'] = this.minFromToClose;
    data['user_id'] = this.userId;
    data['code'] = this.code;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
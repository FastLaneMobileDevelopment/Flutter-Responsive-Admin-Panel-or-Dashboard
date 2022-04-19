class YupcityRegister {
  String? sId;
  String? keyId;
  String? exoId;
  String? userId;
  String? code;
  String? createdAt;
  String? updatedAt;
  int? iV;

  YupcityRegister(
      {this.sId,
        this.keyId,
        this.exoId,
        this.userId,
        this.code,
        this.createdAt,
        this.updatedAt,
        this.iV});

  YupcityRegister.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    keyId = json['key_id'];
    exoId = json['exo_id'];
    userId = json['user_id'];
    code = json['code'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['key_id'] = this.keyId;
    data['exo_id'] = this.exoId;
    data['user_id'] = this.userId;
    data['code'] = this.code;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
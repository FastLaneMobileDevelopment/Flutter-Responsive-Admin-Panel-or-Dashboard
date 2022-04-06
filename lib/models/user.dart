class YupcityUser {
  String? sId;
  String? username;
  String? email;
  String? telephone;
  String? password;
  int? iV;
  late int numberOfUses;

  YupcityUser(
      {this.sId,
        this.username,
        this.email,
        this.telephone,
        this.password,
        this.iV,
        this.numberOfUses = 00,
      });

  YupcityUser.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    email = json['email'];
    telephone = json['telephone'];
    password = json['password'];
    iV = json['__v'];
    numberOfUses = 00;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['username'] = this.username;
    data['email'] = this.email;
    data['telephone'] = this.telephone;
    data['password'] = this.password;
    data['__v'] = this.iV;
    data["numberOfUses"] = this.numberOfUses;
    return data;
  }
}
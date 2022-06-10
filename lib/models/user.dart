class YupcityUser {
  String? sId;
  String? username;
  String? email;
  String? telephone;
  String? password;
  int? iV;
  late int numberOfUses;
  DateTime? createdAt;

  YupcityUser(
      {this.sId,
        this.username,
        this.email,
        this.telephone,
        this.password,
        this.iV,
        this.numberOfUses = 00,
        this.createdAt
      });

  YupcityUser.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    email = json['email'];
    telephone = json['telephone'];
    password = json['password'];
    iV = json['__v'];
    numberOfUses = 00;
    createdAt = DateTime.parse(json['createdAt'] ?? DateTime.parse("2022-04-26T09:33:56.962Z").toString());
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
    data["createdAt"] = this.createdAt;
    return data;
  }
}
class RequestRegister {
  String? customerId;
  String? uid;
  String? name;
  String? email;
  String? telephone;
  String? password;
  String? roles;

  RequestRegister({this.uid, this.name,this.email,this.telephone,this.password, this.customerId, this.roles});

  RequestRegister.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    uid = json['uid'];
    email = json['email'];
    name = json['username'];
    telephone = json['telephone'];
    password = json['password'];
    roles = json['roles'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerId'] = customerId;
    data['uid'] = uid;
    data['email'] = email;
    data['username'] = name;
    data['telephone'] = telephone;
    data['password'] = password;
    data["roles"] = roles;
    return data;
  }
}
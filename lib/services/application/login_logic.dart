import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:yupcity_admin/bloc/auth/login_bloc/datsmi/response_yupcharge.dart';
import 'package:yupcity_admin/bloc/auth/login_bloc/login_request.dart';
import 'package:yupcity_admin/models/user.dart';
import 'package:yupcity_admin/services/http_client.dart';
import 'package:yupcity_admin/services/local_storage_service.dart';
import 'package:get_it/get_it.dart';

import '../Environments.dart';

abstract class LoginLogic {
  Future<String> login(String email, String password);
  Future<dynamic> logout();
}

class LoginException implements Exception {}

class FirebaseLoginLogic extends LoginLogic {
  @override
  Future<String> login(String email, String password) async {
    var auth = FirebaseAuth.instance;

      var authCredentials = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      var localStorage = GetIt.I.get<LocalStorageService>();
      localStorage.setCurrentPassword(password);
      localStorage.setCurrentEmail(email);
      var token = await authCredentials.user?.getIdToken();
      var map = JwtDecoder.decode(token ?? "");
      map["email_verified"] != null ? localStorage.setEmail(map["email_verified"].toString() == "true") : localStorage.setEmail(false);
      map["customer"] != null ?  localStorage.setCustomer(map["customer"].toString()) : localStorage.setCustomer("001");
      map["tenant"] != null ? localStorage.setTenant(map["tenant"].toString()) : localStorage.setTenant("yupcity");
      map["roles"] != null ? localStorage.setTenant(map["roles"].toString()) : localStorage.setRoles("customer");
      localStorage.setToken(token ?? "");
     // token = await YupchargeLoginLogic().login(email, password);
      return Future.value(token);

  }

  @override
  Future logout() async {
    var auth = FirebaseAuth.instance;
    await auth.signOut();
  }

}


class YupchargeLoginLogic extends LoginLogic {
  @override
  Future<String> login(String email, String password) async {
    String baseUrl = Environments().getHost("Production","application");
    var finalUrl = baseUrl + "/users/login";
    var request =  RequestLogin(email: email, password: password);

    try {
      var response = await GetIt.I
          .get<HttpClient>()
          .dio
          .post(finalUrl, data: request.toJson()
      );

      var loginResponse = ResponseAuthYupcity.fromJson(response.data);
      var localStorage = GetIt.I.get<LocalStorageService>();
      localStorage.setCurrentPassword(password);
      localStorage.setCurrentEmail(email);
      localStorage.setToken(loginResponse.token ?? "");
      return Future.value(loginResponse.token ?? "");
    }catch(e)
    {
      return Future.value(null);
    }
  }

  @override
  Future<String> logout() async {
    var localStorage = GetIt.I.get<LocalStorageService>();
    localStorage.setToken("");
    localStorage.setCurrentEmail("");
    localStorage.setCurrentPassword("");
    localStorage.setUser(YupcityUser());
    return Future.value("Saliste");
  }
}

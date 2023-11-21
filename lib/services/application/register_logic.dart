import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yupcity_admin/bloc/auth/recoverPass_bloc/register_request.dart';
import 'package:yupcity_admin/services/http_client.dart';
import 'package:get_it/get_it.dart';

import '../Environments.dart';
import '../local_storage_service.dart';

abstract class RegisterLogic {
  Future<String> register(String uid, String customer, String name, String email, String telephone, String password, String role);
}

class RegisterException implements Exception {
  final String message;

  RegisterException(this.message);
}
class FirebaseRegisterLogic extends RegisterLogic {
  final auth = FirebaseAuth.instance;

  @override
  Future<String> register(String uuid, String customer,
      String name,  String email, String telephone, String password, String roles) async {

    bool saveFirebase = false;

    LocalStorageService localStorage = GetIt.I.get<LocalStorageService>();
    GetIt.I.get<FirebaseAnalytics>().logEvent(
      name: "register",
      parameters: {
        "email": email,
        "telephone" : telephone
      },
    );
    try {
      var user = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await user.user?.updateDisplayName(name);
      await user.user?.sendEmailVerification();


      saveFirebase = true;
      await YupchargeRegisterLogic().register(user.user?.uid ?? "", customer,   name, email, telephone, password, roles);
      return Future.value(user.user?.uid ?? "");
    } catch (e) {
      if (saveFirebase) {
        print("Delete current user");
        await auth.currentUser?.delete();
      }
      print(e.toString());
      throw RegisterException("Error al registrar el usuario.");
    }
  }

}




class YupchargeRegisterLogic extends RegisterLogic {
  @override
  Future<String> register(String uuid, String customer,
      String name,  String email, String telephone, String password, String roles) async {

    String baseUrl = Environments().getHost("Production", "application");
    var finalUrl = baseUrl + "/users/create";
    var request = RequestRegister(uid: uuid, customerId: customer,  name: name, email: email, telephone: telephone, password: password, roles: roles);
    var dio = GetIt.I
        .get<HttpClient>()
        .dio;

   /* dio.options.headers.putIfAbsent("X-EOS-Tenant", () => "Yupcity");
    dio.options.headers.putIfAbsent("X-Yupcity-Customer", () => customer);*/
    await dio.post(finalUrl,data: request.toJson());

    var localStorage = GetIt.I.get<LocalStorageService>();
    localStorage.setCurrentPassword(password);
    localStorage.setCurrentEmail(email);
    localStorage.setToken("");
    return Future.value("");
  }
}

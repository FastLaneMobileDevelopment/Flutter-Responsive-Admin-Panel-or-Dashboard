
import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:yupcity_admin/services/local_storage_service.dart';
import 'package:get_it/get_it.dart';



class LoginService {

  static Future<bool> RemoveLogin() async {
    var storageService = GetIt.I.get<LocalStorageService>();
    storageService.setRememberMe(false);
    storageService.setCurrentEmail("");
    storageService.setCurrentPassword("");
    storageService.setToken("");
    return Future.value(true);
  }

  static Future<bool> CheckLogin() async {
    var storageService = GetIt.I.get<LocalStorageService>();
    String token = storageService.getToken();
    debugPrint(token);
    if (token.isEmpty) return Future.value(false);
    if (JwtDecoder.isExpired(token)) {
        await RemoveLogin();
        return Future.value(false);
    }
    return Future.value(JwtDecoder.isExpired(token));
  }

}
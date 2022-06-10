
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
    return Future.value(storageService.getToken().isEmpty);
  }

}
import 'package:yupcity_admin/models/user.dart';


import '../Environments.dart';

abstract class UpdateTrapLogic {
 // Future<List<YupcityTrapPoi>> getTraps();
  Future<YupcityUser> getTrapById(String id);
}

class LoginException implements Exception {}

class YupchargeUpdateTrapLogic extends UpdateTrapLogic {



 /* @override
  Future<List<YupcityTrapPoi>> getTraps() async {
    String baseUrl = Environments().getHost("Production","application");
    var finalUrlGet= baseUrl + "/userById/";
    var responseGet = await GetIt.I.get<HttpClient>().dio.get(finalUrlGet);
    var yupcityUser = YupcityUser.fromJson(responseGet.data);
    return Future.value(yupcityUser);
  }*/

  @override
  Future<YupcityUser> getTrapById(String id) async {
    String baseUrl = Environments().getHost("Production","application");
    /*
    try {
      var cleanUserName = userName.trim();
      var finalUrlGet = baseUrl + "/userByUsername/" + cleanUserName;
      var responseGet = await GetIt.I
          .get<HttpClient>()
          .dio
          .get(finalUrlGet);
      var yupcityUser = YupcityUser.fromJson(responseGet.data);
      return Future.value(yupcityUser);
    }catch(e)
    {

       debugPrint(e.toString());
       return YupcityUser();
    }*/
    return YupcityUser();
    //then remove
  }

}
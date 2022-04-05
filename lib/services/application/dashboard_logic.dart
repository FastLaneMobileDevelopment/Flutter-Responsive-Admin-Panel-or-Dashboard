import 'package:flutter/material.dart';
import 'package:yupcity_admin/models/user.dart';
import 'package:yupcity_admin/models/yupcity_register.dart';
import 'package:yupcity_admin/models/yupcity_trap_poi.dart';
import 'package:yupcity_admin/services/http_client.dart';
import 'package:get_it/get_it.dart';
import '../Environments.dart';

abstract class DashboardLogic {
  Future<List<YupcityTrapPoi>> getPois();
  Future<List<YupcityUser>> getUsers();
  Future<List<YupcityRegister>> getRegistries();
  Future<bool> setPoi(YupcityTrapPoi yupcityTrapPoi);
  Future<YupcityUser> getUser(String id);
  Future<YupcityUser> getUserByUsername(String id);
}


class YupcityDashboardLogic extends DashboardLogic {

  @override
  Future<List<YupcityTrapPoi>> getPois() async {
    String baseUrl = Environments().getHost("Production","application");
    var finalUrlGet= baseUrl + "/traps/all";
    var responseGet = await GetIt.I.get<HttpClient>().dio.get(finalUrlGet);
    List<YupcityTrapPoi> list = [];
    responseGet.data.forEach((v) {
        list.add(YupcityTrapPoi.fromJson(v));
    });

    return Future.value(list);
  }

  @override
  Future<List<YupcityUser>> getUsers() async {
    String baseUrl = Environments().getHost("Production","application");
    var finalUrlGet= baseUrl + "/users/all";
    var responseGet = await GetIt.I.get<HttpClient>().dio.get(finalUrlGet);
    List<YupcityUser> list = [];
    responseGet.data.forEach((v) {
      list.add(YupcityUser.fromJson(v));
    });
    list = _cleanedUserList(list);
    return Future.value(list);
  }

  List<YupcityUser> _cleanedUserList(List<YupcityUser> allUsers){
    List<YupcityUser> clenedList = [];

    for(var user in allUsers){
      if(user.email != null){
        clenedList.add(user);
      }
    }
    return clenedList;
  }

  @override
  Future<List<YupcityRegister>> getRegistries() async {
    String baseUrl = Environments().getHost("Production","application");
    var finalUrlGet= baseUrl + "/locksOperation/all";
    var responseGet = await GetIt.I.get<HttpClient>().dio.get(finalUrlGet);
    List<YupcityRegister> list = [];
    responseGet.data.forEach((v) {
      list.add(YupcityRegister.fromJson(v));
    });
    return Future.value(list);
  }

  @override
  Future<bool> setPoi(YupcityTrapPoi poi) async {
    String baseUrl = Environments().getHost("Production","application");
    var finalUrlGet= baseUrl + "/traps/create";
    var responseGet = await GetIt.I.get<HttpClient>().dio.post(finalUrlGet, data: poi.toJson());
    return Future.value(true);
  }

  @override
  Future<YupcityUser> getUser(String id) async {
    String baseUrl = Environments().getHost("Production","application");
    var finalUrlGet= baseUrl + "/userById/" + id;
    var responseGet = await GetIt.I.get<HttpClient>().dio.get(finalUrlGet);
    var yupcityUser = YupcityUser.fromJson(responseGet.data);
    return Future.value(yupcityUser);
  }

  @override
  Future<YupcityUser> getUserByUsername(String userName) async {
    String baseUrl = Environments().getHost("Production","application");
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
    }
  }

}
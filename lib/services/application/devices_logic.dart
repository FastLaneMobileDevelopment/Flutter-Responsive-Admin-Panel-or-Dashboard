
import 'package:get_it/get_it.dart';
import 'package:yupcity_admin/models/yupcity_register.dart';
import 'package:yupcity_admin/models/yupcity_trap_poi.dart';

import '../Environments.dart';
import '../http_client.dart';


abstract class DevicesLogic {
  List<YupcityTrapPoi> getTrapswithRegistries(List<YupcityTrapPoi> allTraps,  List<YupcityRegister> allRegistries );
  Future<bool> deleteTrap(String id);
}


class YupcityDevicesLogic extends DevicesLogic {

  @override

  List<YupcityTrapPoi> getTrapswithRegistries(List<YupcityTrapPoi> trapsList,List<YupcityRegister> registerList){

    for(var registry in registerList){
      for(var trap in trapsList){
        if(registry.trap_id == trap.sId){
          trap.numberOfUses++;
        }
      }
    }
    return trapsList;
  }

  @override
  Future<bool> deleteTrap(String id) async{
    String baseUrl = Environments().getHost("Production","application");
    var finalUrl = baseUrl + "/traps/delete/" + id;
    var dio = GetIt.I
        .get<HttpClient>()
        .dio;

    /* dio.options.headers.putIfAbsent("X-EOS-Tenant", () => "Yupcity");
    dio.options.headers.putIfAbsent("X-Yupcity-Customer", () => customer);*/
    await dio.delete(finalUrl);

    return Future.value(true);

  }
}

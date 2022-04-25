import 'package:flutter/material.dart';
import 'package:yupcity_admin/models/user.dart';
import 'package:yupcity_admin/models/yupcity_register.dart';
import 'package:yupcity_admin/models/yupcity_trap_poi.dart';


abstract class DevicesLogic {
  List<YupcityTrapPoi> getTrapswithRegistries(List<YupcityTrapPoi> allTraps,  List<YupcityRegister> allRegistries );

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
}

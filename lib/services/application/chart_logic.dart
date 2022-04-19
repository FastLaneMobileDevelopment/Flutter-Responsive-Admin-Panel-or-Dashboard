import 'package:yupcity_admin/models/user.dart';
import 'package:yupcity_admin/models/yupcity_register.dart';
import 'package:yupcity_admin/models/yupcity_trap_poi.dart';


abstract class ChartLogic {
  List<YupcityUser> getUsersLast7Days(List<YupcityUser> allUser);
  List<YupcityTrapPoi> getTrapsLast7Days(List<YupcityTrapPoi> allTraps);
  List<YupcityRegister> getRegistriesLast7Days(List<YupcityRegister> allRegistries);

}


class YupcityChartLogic extends ChartLogic {

  @override
  List<YupcityUser> getUsersLast7Days(List<YupcityUser> allUsers)  {

    var today = DateTime.now();
    List<YupcityUser>  usersFiltered = [];

    for(var user in allUsers){
      if(user.createdAt != null){
        var createdAt = DateTime.parse(user.createdAt!);
        var difference = today.difference(createdAt).inDays;
        if(difference <= 7){
          usersFiltered.add(user);
        }

      }
    }

    return usersFiltered;
  }

  @override
  List<YupcityTrapPoi> getTrapsLast7Days(List<YupcityTrapPoi> allTraps)  {

    var today = DateTime.now();
    List<YupcityTrapPoi>  trapsFiltered = [];

    for(var trap in allTraps){
      if(trap.createdAt != null){
        var createdAt = DateTime.parse(trap.createdAt!);
        var difference = today.difference(today).inDays;

        if(difference <= 7){
          trapsFiltered.add(trap);
        }

      }
    }

    return trapsFiltered;
  }

  @override
  List<YupcityRegister> getRegistriesLast7Days(List<YupcityRegister> allRegistries)  {

    var today = DateTime.now();
    List<YupcityRegister>  resgistriesFiltered = [];

    for(var register in allRegistries){
      if(register.createdAt != null){
        var createdAt = DateTime.parse(register.createdAt!);
        var difference = today.difference(createdAt).inDays;

        if(difference <= 7){
          resgistriesFiltered.add(register);
        }

      }
    }

    return resgistriesFiltered;
  }
}
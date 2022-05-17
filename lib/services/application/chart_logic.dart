import 'package:yupcity_admin/models/UserGrowthWeekly.dart';
import 'package:yupcity_admin/models/user.dart';
import 'package:yupcity_admin/models/yupcity_register.dart';
import 'package:yupcity_admin/models/yupcity_trap_poi.dart';


abstract class ChartLogic {
  List<YupcityUser> getUsersLast7Days(List<YupcityUser> allUser);
  List<YupcityTrapPoi> getTrapsLast7Days(List<YupcityTrapPoi> allTraps);
  List<YupcityRegister> getRegistriesLast7Days(List<YupcityRegister> allRegistries);
  UserGrowthWeekly getUsersLast7DaysForChart(List<YupcityUser> allUser);

}


class YupcityChartLogic extends ChartLogic {

  @override
  List<YupcityUser> getUsersLast7Days(List<YupcityUser> allUsers)  {

    var today = DateTime.now();
    List<YupcityUser>  usersFiltered = [];

    for(var user in allUsers){
      if(user.createdAt != null){
        var createdAt = user.createdAt;
        var difference = today.difference(createdAt!).inDays;
        if(difference <= 7){
          usersFiltered.add(user);
        }

      }
    }
    usersFiltered.sort((a,b) => a.createdAt!.compareTo(b.createdAt!));
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

  @override
  UserGrowthWeekly getUsersLast7DaysForChart(List<YupcityUser> usersLast7days)  {


    List<UserGrowthDay> userGrowthMonday = [];
    List<UserGrowthDay> userGrowthTuesday = [];
    List<UserGrowthDay> userGrowthWendsday = [];
    List<UserGrowthDay> userGrowthThursday = [];
    List<UserGrowthDay> userGrowthFriday = [];
    List<UserGrowthDay> userGrowthSaturday = [];
    List<UserGrowthDay> userGrowthSunday = [];

    for(var user in usersLast7days){
      switch (user.createdAt!.weekday) {
        case DateTime.monday:
          userGrowthMonday.add(
              UserGrowthDay(
                  day: 1,
                  user: user
              ));
          break;
        case DateTime.tuesday:
          userGrowthTuesday.add(
              UserGrowthDay(
                  day: 2,
                  user: user
              ));
          break;
        case DateTime.wednesday:
          userGrowthWendsday.add(
              UserGrowthDay(
                  day: 3,
                  user: user
              ));
          break;
        case DateTime.thursday:
          userGrowthThursday.add(
              UserGrowthDay(
                  day: 4,
                  user: user
              ));
          break;
        case DateTime.friday:
          userGrowthFriday.add(
              UserGrowthDay(
                  day: 5,
                  user: user
              ));
          break;
        case DateTime.saturday:
          userGrowthSaturday.add(
              UserGrowthDay(
                  day: 6,
                  user: user
              ));
          break;
        case DateTime.sunday:
          userGrowthSunday.add(
              UserGrowthDay(
                  day: 7,
                  user: user
              ));
          break;
        default:

          break;
      }
    }

    UserGrowthWeekly userGrowthWeekly = UserGrowthWeekly(
      monday: userGrowthMonday,
      tuesday: userGrowthTuesday,
      wednesday: userGrowthWendsday,
      thursday: userGrowthThursday,
      friday: userGrowthFriday,
      saturday: userGrowthSaturday,
      sunday: userGrowthSunday,
    );

    return userGrowthWeekly;

  }

}



import 'package:yupcity_admin/models/user.dart';

class UserGrowthDay {
   int day;
   YupcityUser user;


   UserGrowthDay({
    required this.day,
    required this.user,
  });
}

class UserGrowthWeekly {
  List<UserGrowthDay> monday;
  List<UserGrowthDay> tuesday;
  List<UserGrowthDay> wednesday;
  List<UserGrowthDay> thursday;
  List<UserGrowthDay> friday;
  List<UserGrowthDay> saturday;
  List<UserGrowthDay> sunday;

  UserGrowthWeekly({
    this.monday = const [],
    this.tuesday= const [],
    this.wednesday= const [],
    this.thursday= const [],
    this.friday= const [],
    this.saturday= const [],
    this.sunday = const [],
  });
}



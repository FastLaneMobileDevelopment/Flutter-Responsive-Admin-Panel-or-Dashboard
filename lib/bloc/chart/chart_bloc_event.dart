import 'package:yupcity_admin/models/user.dart';
import 'package:equatable/equatable.dart';
import 'package:yupcity_admin/models/yupcity_register.dart';
import 'package:yupcity_admin/models/yupcity_trap_poi.dart';

abstract class ChartBlocEvent extends Equatable {
  const ChartBlocEvent();
}

class GetDataLast7DaysEvent extends ChartBlocEvent{

  final List<YupcityUser> allUsers;
  final List<YupcityTrapPoi> allTraps;
  final List<YupcityRegister> registries;

  const GetDataLast7DaysEvent(this.allUsers,this.allTraps,this.registries);

  @override
  List<Object> get props => [];

}

class GetUserDataLast7DaysEvent extends ChartBlocEvent{

  final List<YupcityUser> allUsers;

  const GetUserDataLast7DaysEvent(this.allUsers,);

  @override
  List<Object> get props => [];

}








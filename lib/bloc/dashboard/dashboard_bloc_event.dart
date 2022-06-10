import 'package:yupcity_admin/models/user.dart';
import 'package:equatable/equatable.dart';
import 'package:yupcity_admin/models/yupcity_register.dart';
import 'package:yupcity_admin/models/yupcity_trap_poi.dart';

abstract class DashboardBlocEvent extends Equatable {
  const DashboardBlocEvent();
}

class GetAllDataEvent extends DashboardBlocEvent{

  const GetAllDataEvent();
  @override
  List<Object> get props => [];

}

class UpdateAllDataEvent extends DashboardBlocEvent{
  final List<YupcityUser> allUsers;
  final List<YupcityUser> allTraps;
  final List<YupcityRegister> allRegistries;

  const UpdateAllDataEvent(this.allUsers, this.allTraps,this.allRegistries);
  @override
  List<Object> get props => [];

}

class GetUserDataEvent extends DashboardBlocEvent{

  const GetUserDataEvent();
  @override
  List<Object> get props => [];

}

class SetPoiEvent extends DashboardBlocEvent{
  final YupcityTrapPoi newTrap;

  const SetPoiEvent(this.newTrap);

@override
List<Object> get props => [];

}
class RefreshAllDataEvent extends DashboardBlocEvent{

  const RefreshAllDataEvent();
  @override
  List<Object> get props => [];

}





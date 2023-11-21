import 'package:google_maps_flutter/google_maps_flutter.dart';
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

class SetEditPositionEvent extends DashboardBlocEvent{

  final String id;

  final double lat;

  final double lon;

  final String center;

  final String centerDescription;

  final String type;

  final String customerId;

  const SetEditPositionEvent(this.id, this.lat, this.lon, this.center, this.centerDescription, this.type, this.customerId);

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





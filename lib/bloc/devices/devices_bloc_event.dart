import 'package:equatable/equatable.dart';
import 'package:yupcity_admin/models/yupcity_register.dart';
import 'package:yupcity_admin/models/yupcity_trap_poi.dart';

abstract class DevicesBlocEvent extends Equatable {
  const DevicesBlocEvent();
}

class GetTrapsWithRegistriesEvent extends DevicesBlocEvent{


  final List<YupcityTrapPoi> allTraps;
  final List<YupcityRegister> registries;

  const GetTrapsWithRegistriesEvent(this.allTraps,this.registries);

  @override
  List<Object> get props => [];

}


class DeleteTrapEvent extends DevicesBlocEvent{


  final String  trapId;

  const DeleteTrapEvent(this.trapId);

  @override
  List<Object> get props => [];

}








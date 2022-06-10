import 'package:equatable/equatable.dart';
import 'package:yupcity_admin/models/yupcity_trap_poi.dart';

abstract class DevicesBlocState extends Equatable {
  const DevicesBlocState();
}
//Initial state
class InitialTrapsBlocState extends DevicesBlocState {
  @override
  List<Object> get props => [];
}

class LoadingTrapsBlocState extends DevicesBlocState {
  @override
  List<Object> get props => [];
}

class UpdatedDataTrapsBlocState extends DevicesBlocState {


  final List<YupcityTrapPoi> allTraps;


  const UpdatedDataTrapsBlocState(this.allTraps);
  @override
  List<Object> get props => [];
}


class ErrorTrapBlocState extends DevicesBlocState {

  final String error;

  const ErrorTrapBlocState(this.error);
  @override
  List<Object> get props => [];
}

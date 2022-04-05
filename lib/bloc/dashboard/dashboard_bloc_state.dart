import 'package:yupcity_admin/models/yupcity_register.dart';
import 'package:yupcity_admin/models/yupcity_trap_poi.dart';
import 'package:yupcity_admin/models/user.dart';
import 'package:equatable/equatable.dart';

abstract class DashboardBlocState extends Equatable {
  const DashboardBlocState();
}
//Initial state
class InitialBoardBlocState extends DashboardBlocState {
  @override
  List<Object> get props => [];
}

class LoadingBoardBlocState extends DashboardBlocState {
  @override
  List<Object> get props => [];
}

class UpdatedBoardBlocState extends DashboardBlocState {
  final List<YupcityUser> allUsers;
  final List<YupcityTrapPoi> allTraps;
  final List<YupcityRegister> registries;

  const UpdatedBoardBlocState(this.allUsers, this.allTraps, this.registries);
  @override
  List<Object> get props => [];
}

class ErrorBoardBlocState extends DashboardBlocState {

  final String error;

  const ErrorBoardBlocState(this.error);
  @override
  List<Object> get props => [];
}

class SepPoiBoardBlocState extends DashboardBlocState {
  @override
  List<Object> get props => [];
}


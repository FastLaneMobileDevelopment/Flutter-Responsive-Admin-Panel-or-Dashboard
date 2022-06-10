import 'package:equatable/equatable.dart';
import 'package:yupcity_admin/models/UserGrowthWeekly.dart';
import 'package:yupcity_admin/models/user.dart';
import 'package:yupcity_admin/models/yupcity_register.dart';
import 'package:yupcity_admin/models/yupcity_trap_poi.dart';

abstract class ChartBlocState extends Equatable {
  const ChartBlocState();
}
//Initial state
class InitialChartBlocState extends ChartBlocState {
  @override
  List<Object> get props => [];
}

class LoadingChartBlocState extends ChartBlocState {
  @override
  List<Object> get props => [];
}

class UpdatedDataChartBlocState extends ChartBlocState {

  final List<YupcityUser> allUsers;
  final List<YupcityTrapPoi> allTraps;
  final List<YupcityRegister> registries;

  const UpdatedDataChartBlocState(this.allUsers,this.allTraps,this.registries);
  @override
  List<Object> get props => [];
}


class ErrorChartBlocState extends ChartBlocState {

  final String error;

  const ErrorChartBlocState(this.error);
  @override
  List<Object> get props => [];
}


class LoadingUserChartBlocState extends ChartBlocState {
  @override
  List<Object> get props => [];
}

class UpdatedUserDataChartBlocState extends ChartBlocState {

  final UserGrowthWeekly userGrowthWeekly;

  const UpdatedUserDataChartBlocState(this.userGrowthWeekly);
  @override
  List<Object> get props => [];
}

import 'package:yupcity_admin/models/UserGrowthWeekly.dart';
import 'package:yupcity_admin/models/user.dart';
import 'package:yupcity_admin/models/yupcity_register.dart';
import 'package:yupcity_admin/models/yupcity_trap_poi.dart';
import 'package:yupcity_admin/services/application/chart_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chart_bloc_event.dart';
import 'chart_bloc_state.dart';

class ChartBloc extends Bloc<ChartBlocEvent, ChartBlocState> {
  ChartBloc({@required this.logic}) : super(InitialChartBlocState()) {

    on<GetDataLast7DaysEvent>((event, emit) {
       getDataLast7DaysEventHandler(emit, event);
    });

    on<GetUserDataLast7DaysEvent>((event, emit) {
      getUserDataLast7DaysEventHandler(emit, event);
    });

  }

  final ChartLogic? logic;



  void getDataLast7DaysEventHandler(Emitter<ChartBlocState> emit, GetDataLast7DaysEvent event)  {
    emit(LoadingChartBlocState());

    try{

      List<YupcityUser> allUserFiltered = [];
      var responseUsers = logic?.getUsersLast7Days(event.allUsers);
      if(responseUsers != null) {
        allUserFiltered = responseUsers;
      }

      List<YupcityTrapPoi> allTrapsFiltered = [];
      var responseTraps = logic?.getTrapsLast7Days(event.allTraps);
      if(responseTraps != null) {
        allTrapsFiltered = responseTraps;
      }

      List<YupcityRegister> allRegistriesFiltered= [];
      var responseRegistries = logic?.getRegistriesLast7Days(event.registries);
      if(responseTraps != null){
        allRegistriesFiltered = responseRegistries!;
      }

      emit(UpdatedDataChartBlocState(allUserFiltered,allTrapsFiltered, allRegistriesFiltered));
      // UpdatedBoardBlocState
    }on Exception{
      emit(const ErrorChartBlocState("Error updating chart"));
    }
  }

  void getUserDataLast7DaysEventHandler(Emitter<ChartBlocState> emit, GetUserDataLast7DaysEvent event)  {
    emit(LoadingUserChartBlocState());

    try{

      List<YupcityUser> allUserFiltered = [];
      UserGrowthWeekly userGrowthWeekly = UserGrowthWeekly();
      var responseUsers = logic?.getUsersLast7Days(event.allUsers);
      if(responseUsers != null) {
        allUserFiltered = responseUsers;
      }

      var responseChartData = logic?.getUsersLast7DaysForChart(allUserFiltered);
      if(responseChartData != null) {
        userGrowthWeekly = responseChartData;
      }

      emit(UpdatedUserDataChartBlocState(userGrowthWeekly));
      // UpdatedBoardBlocState
    }on Exception{
      emit(const ErrorChartBlocState("Error updating chart"));
    }
  }


}
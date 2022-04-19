
import 'package:yupcity_admin/models/user.dart';
import 'package:yupcity_admin/models/yupcity_register.dart';
import 'package:yupcity_admin/models/yupcity_trap_poi.dart';
import 'package:yupcity_admin/services/application/chart_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yupcity_admin/services/application/devices_logic.dart';
import 'devices_bloc_event.dart';
import 'devices_bloc_state.dart';

class DevicesBloc extends Bloc<DevicesBlocEvent, DevicesBlocState> {
  DevicesBloc({@required this.logic}) : super(InitialTrapsBlocState()) {

    on<GetTrapsWithRegistriesEvent>((event, emit) {
       getTrapsWithRegistriesEventHandler(emit, event);
    });


  }

  final DevicesLogic? logic;



  void getTrapsWithRegistriesEventHandler(Emitter<DevicesBlocState> emit, GetTrapsWithRegistriesEvent event)  {
    emit(LoadingTrapsBlocState());

    try{

      List<YupcityTrapPoi> allTrapsFiltered = [];
      var responseTraps = logic?.getTrapswithRegistries(event.allTraps, event.registries);
      if(responseTraps != null) {
        allTrapsFiltered = responseTraps;
      }

      emit(UpdatedDataTrapsBlocState(allTrapsFiltered));
      // UpdatedBoardBlocState
    }on Exception{
      emit(const ErrorTrapBlocState("Error updating traps"));
    }
  }


}
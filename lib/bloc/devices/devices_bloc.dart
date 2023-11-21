
import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';
import 'package:yupcity_admin/models/events/RefreshEvent.dart';
import 'package:yupcity_admin/models/yupcity_trap_poi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yupcity_admin/services/application/devices_logic.dart';
import 'devices_bloc_event.dart';
import 'devices_bloc_state.dart';

class DevicesBloc extends Bloc<DevicesBlocEvent, DevicesBlocState> {
  DevicesBloc({@required this.logic}) : super(InitialTrapsBlocState()) {

    on<DeleteTrapEvent>((event, emit){
      deleteTrapEventHandler(emit,event);
    });
    on<GetTrapsWithRegistriesEvent>((event, emit) {
       getTrapsWithRegistriesEventHandler(emit, event);
    });


  }

  final DevicesLogic? logic;

  void deleteTrapEventHandler(Emitter<DevicesBlocState> emit, DeleteTrapEvent event) async  {
    emit(LoadingTrapsBlocState());
    try {
      await logic?.deleteTrap(event.trapId);
    }
    catch(e)
    {
      emit(ErrorTrapBlocState(e.toString()));
      return;
    }
    GetIt.I.get<EventBus>().fire(RefreshEvent());
    emit(DeleteTrapsBlocState());
  }



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
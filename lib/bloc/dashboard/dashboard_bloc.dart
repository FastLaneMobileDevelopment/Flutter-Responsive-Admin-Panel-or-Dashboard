
import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';
import 'package:yupcity_admin/models/YupcityPoiUpdateRequest.dart';
import 'package:yupcity_admin/models/events/FoundNewDevice.dart';
import 'package:yupcity_admin/models/events/RefreshEvent.dart';
import 'package:yupcity_admin/services/application/dashboard_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yupcity_admin/services/local_storage_service.dart';
import 'dashboard_bloc_event.dart';
import 'dashboard_bloc_state.dart';

class DashboardBloc extends Bloc<DashboardBlocEvent, DashboardBlocState> {
  DashboardBloc({@required this.logic}) : super(InitialBoardBlocState()) {

    on<GetAllDataEvent>((event, emit) async{
      await getAllDataEventHandler(emit, event);
    });

    on<SetEditPositionEvent>((event, emit) async {
      await setEditPositionPoiEventHandler(emit, event);

    });

    on<SetPoiEvent>((event, emit) async{
      await setPoiEventHandler(emit, event);
    });

    on<RefreshAllDataEvent>((event, emit) async{
      await refreshAllDataEvent(emit, event);
    });
  }

  final DashboardLogic? logic;

  Future<void> setEditPositionPoiEventHandler(Emitter<DashboardBlocState> emit, SetEditPositionEvent event) async {

    try{
      var request = YupcityPoiUpdateRequest(
        center: event.center,
        centerDescription: event.centerDescription,
        lat: event.lat,
        lon:  event.lon,
        type: event.type,
        customer: event.customerId
      );

      var responseSetPoi =  await logic?.updatePoi(event.id,   request);
      GetIt.I.get<EventBus>().fire(RefreshEvent());
      // GetIt.I.get<LocalStorageService>().setLocks(List<FoundNewDevice>.empty(growable: false));
      emit(SepPoiBoardBlocState());
      // UpdatedBoardBlocState
    }on Exception{
      emit(const ErrorBoardBlocState("Error updating new trap"));
    }
  }


  Future<void> setPoiEventHandler(Emitter<DashboardBlocState> emit, SetPoiEvent event) async {

    try{
      var responseSetPoi =  await logic?.setPoi(event.newTrap);
      GetIt.I.get<EventBus>().fire(RefreshEvent());
      GetIt.I.get<LocalStorageService>().setLocks(List<FoundNewDevice>.empty(growable: false));
        emit(SepPoiBoardBlocState());
         // UpdatedBoardBlocState
    }on Exception{
      emit(const ErrorBoardBlocState("Error updating new trap"));
    }
  }

  Future<void> getAllDataEventHandler(Emitter<DashboardBlocState> emit, GetAllDataEvent event) async {
    emit(LoadingBoardBlocState());

    try{
      var responseTraps =  await logic?.getPois();
      var responseUsers = await logic?.getUsers();
      var responseRegistries = await logic?.getRegistries();
      emit(UpdatedBoardBlocState(responseUsers ?? [],responseTraps ?? [], responseRegistries ?? [],));
      // UpdatedBoardBlocState
    }on Exception{
      emit(const ErrorBoardBlocState("Error Get Users and Traps"));
    }
  }

  Future<void> refreshAllDataEvent(Emitter<DashboardBlocState> emit, RefreshAllDataEvent event) async {
    emit(LoadingBoardBlocState());

    try{
      var responseTraps =  await logic?.getPois();
      var responseUsers = await logic?.getUsers();
      var responseRegistries = await logic?.getRegistries();
      emit(RefreshAllDataState(responseUsers ?? [],responseTraps ?? [], responseRegistries ?? [],));
      // UpdatedBoardBlocState
    }on Exception{
      emit(const ErrorBoardBlocState("Error Get Users and Traps"));
    }
  }








  /* Future<void> updatedUserPhotoDataEventHandler(UpdateUserPhotoDataEvent event, Emitter<DashboardBlocState> emit) async {
    var id = GetIt.I.get<LocalStorageService>().getUser()?.sId;
    var file =  await ImagePicker().pickImage(source: event.imageSource, maxWidth: 1024, maxHeight: 1024, imageQuality: 70);
    emit(UpdatingUserBlocState());
    var responseData = await logic?.updateImage(id ?? "",  file?.path ?? "");
    emit(UpdatedUserBlocState(responseData!));
  } */



}
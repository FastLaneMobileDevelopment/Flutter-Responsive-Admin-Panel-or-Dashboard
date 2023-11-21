import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:yupcity_admin/bloc/dashboard/dashboard_bloc.dart';
import 'package:yupcity_admin/bloc/dashboard/dashboard_bloc_event.dart';
import 'package:yupcity_admin/bloc/dashboard/dashboard_bloc_state.dart';
import 'package:yupcity_admin/i18n.dart';
import 'package:yupcity_admin/models/events/NavigationScreen.dart';
import 'package:yupcity_admin/models/yupcity_register.dart';
import 'package:yupcity_admin/models/yupcity_trap_poi.dart';
import 'package:yupcity_admin/responsive.dart';
import 'package:yupcity_admin/screens/traps/add_new_trap.dart';
import 'package:yupcity_admin/screens/traps/devices_table.dart';
import 'package:flutter/material.dart';
import 'package:yupcity_admin/services/application/dashboard_logic.dart';
import '../../../constants.dart';
import 'package:yupcity_admin/screens/dashboard/components/header.dart';

class PinTrapScreen extends StatefulWidget {
  final List<YupcityTrapPoi>? allTraps;
  final YupcityTrapPoi? currenTrap;



  PinTrapScreen(this.allTraps, this.currenTrap);

  @override
  _PinTrapScreenState createState() => _PinTrapScreenState();

}

class _PinTrapScreenState extends State<PinTrapScreen> {

  var _dashboardBloc = DashboardBloc(logic: YupcityDashboardLogic());

  static const platformSearch = MethodChannel('samples.flutter.dev/lock');

  Position? currentPosition;

  Set<Marker> markers = Set();

  Set<Marker> lockedMarker = Set();

  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _determinePosition();
    _startBluetooth();
  }

  void _startBluetooth() async {
    platformSearch.invokeMethod("reset");
    var arguments = {"step": "1"};
    platformSearch.invokeMethod("searchPaired", arguments);
    platformSearch.setMethodCallHandler(_platformCallHandler);
  }

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;


    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    currentPosition = await Geolocator.getCurrentPosition();



    /*_addDataFake();
    _manager = _initClusterManager();*/
    setState(() {});

  }

  String foundExoName = "";

  YupcityTrapPoi? currentTrap;

  Future<dynamic> _platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case 'found_lockData':
        {
          print('call found_lockData : arguments = ${call.arguments}');
          return Future.value("lockData");
        }
      case 'found':
        print('call found : arguments = ${call.arguments}');


          foundExoName = call.arguments[0];
          print("Found exo: " + foundExoName);
          bool found = false;

            for (var element in widget.allTraps ?? List.empty()) {
              if (element.lat != 0 && element.lon != 0) {
                continue;
                // TODO Check distance if more than 10 meters its impossible
              }

              currentTrap = element;

              if (element.lock1?.toUpperCase() == foundExoName.toUpperCase()) {
                currentTrap = element;
                found = true;
              }
              if (element.lock2?.toUpperCase() == foundExoName.toUpperCase()) {
                currentTrap = element;
                found = true;
              }
              if (element.lock3?.toUpperCase() == foundExoName.toUpperCase()) {
                currentTrap = element;
                found = true;
              }
              if (element.lock4?.toUpperCase() == foundExoName.toUpperCase()) {
                currentTrap = element;
                found = true;
              }

              if (found) {
                break;
              }
            }


          if (!found) return Future.value("return nothing");

          var centerData = currentTrap?.center ?? "";
          await Alert(
              context: context,
              type: AlertType.info,
              style: AlertStyle(backgroundColor: Colors.white),
              title: "Encontrado trap: " + centerData + " " + ", Exo:" + foundExoName,
              buttons: [
                DialogButton(
                    child: Text("Actualizar posición"),
                    onPressed: () {

                      _dashboardBloc.add(SetEditPositionEvent(
                        currentTrap?.sId ?? "",
                        currentPosition?.latitude ?? 0.0,
                        currentPosition?.longitude ?? 0.0,
                        currentTrap?.center ?? "",
                        currentTrap?.centerDescription ?? "",
                        currentTrap?.type ?? "",
                        currentTrap?.customer ?? ""

                      ));
                      Navigator.of(context, rootNavigator: true).pop();
                    }),
                DialogButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      if (Navigator.canPop(context)) {
                        Navigator.of(context, rootNavigator: true).pop();
                      }
                    })
              ]).show();

        return Future.value('called from platform!');
    //return Future.error('error message!!');
      default:
        print('Unknowm method ${call.method}');
        throw MissingPluginException();
        break;
    }
  }


  @override
  Widget build(BuildContext context) {

    return  BlocProvider(
      create: (context) => _dashboardBloc,
      child: BlocListener<DashboardBloc, DashboardBlocState>(
        listener: (context, state) async {

          if(state is LoadingBoardBlocState){
            if(mounted){
              setState(() {

              });
            }
          }else if(state is UpdatedBoardBlocState){
            setState(() {

            });
          }else if( state is SepPoiBoardBlocState){
            await Fluttertoast.showToast(
                msg: "Actualizado",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 5
            );

            String route = "dashboard";
            GetIt.I.get<EventBus>().fire(NavigationScreen(routeName: route));



          }else if (state is RefreshAllDataState){

          }
        },
        bloc: _dashboardBloc,
        child: BlocBuilder<DashboardBloc, DashboardBlocState>(
            builder: (context, state) {
         return SafeArea(
            child: Column(
              children: [
                Header(route: "pin_trap", itemList: widget.allTraps ?? List.empty(), ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        String route = "dashboard";
                        GetIt.I.get<EventBus>().fire(NavigationScreen(routeName: route));
                      },
                    ),
                    SizedBox(
                      width: 15,
                    ),

              ],

            ),
                Container(
                  height: 2 *MediaQuery.of(context).size.height / 3,
                  child: currentPosition == null
                      ? Container()
                      : GoogleMap(
                      mapType: MapType.normal,
                      markers: lockedMarker,
                      mapToolbarEnabled: true,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      initialCameraPosition:  CameraPosition(
                        target: LatLng(currentPosition?.latitude ?? 0.0,
                            currentPosition?.longitude ?? 0.0),
                        zoom: 17.4746,
                      ),
                      onLongPress: (LatLng pos){
                        /*Marker point = Marker(markerId: MarkerId("id"), position: pos);
                            setState(() {
                              markers.clear();
                              markers.add(point);

                              currentStepIndex++;
                            });*/
                      },
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);

                      }),
                ),

              ]
            )); },
        ),
      ),
    );
  }
}

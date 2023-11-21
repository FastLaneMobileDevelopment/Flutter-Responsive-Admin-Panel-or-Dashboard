import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:yupcity_admin/bloc/dashboard/dashboard_bloc.dart';
import 'package:yupcity_admin/bloc/dashboard/dashboard_bloc_event.dart';
import 'package:yupcity_admin/bloc/dashboard/dashboard_bloc_state.dart';
import 'package:yupcity_admin/controllers/CurrentMenuController.dart';
import 'package:yupcity_admin/models/events/NavigationScreen.dart';
import 'package:yupcity_admin/models/events/RefreshEvent.dart';
import 'package:yupcity_admin/models/user.dart';
import 'package:yupcity_admin/models/yupcity_register.dart';
import 'package:yupcity_admin/models/yupcity_trap_poi.dart';
import 'package:yupcity_admin/responsive.dart';
import 'package:yupcity_admin/screens/dashboard/dashboard_screen.dart';
import 'package:yupcity_admin/screens/traps/devices_screen.dart';
import 'package:yupcity_admin/screens/traps/pin_trap.dart';
import 'package:yupcity_admin/screens/users/user_screen.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:yupcity_admin/services/application/dashboard_logic.dart';
import 'components/side_menu.dart';

class MainScreen extends StatefulWidget {
  //const MainScreen({ Key? key }) : super(key: key);
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String currentScreen = "dashboard";
  bool isLoading = true;
  bool isFinished = false;
  List<YupcityUser> usersList = [];
  List<YupcityTrapPoi> trapsList = [];
  List<YupcityRegister> registerList = [];

  var _dashboardBloc = DashboardBloc(logic: YupcityDashboardLogic());

  @override
  void initState() {
    super.initState();
    _registerEvents();

    _dashboardBloc.add(GetAllDataEvent());
    checkBluetooth();
  }

  void checkBluetooth() async {
    if(!await Permission.bluetooth.isGranted) {
      await Permission.bluetooth.request();
    }

    if(!await Permission.bluetoothScan.isGranted) {
      await Permission.bluetoothScan.request();
    }

    if(!await Permission.bluetoothConnect.isGranted) {
      await Permission.bluetoothConnect.request();
    }
  }

  void _registerEvents() async {
    GetIt.I.get<EventBus>().on<RefreshEvent>().listen((event) {
      if (mounted) {
        usersList = [];
        trapsList = [];
        registerList = [];
        _dashboardBloc.add(GetAllDataEvent());
      }
    });

    GetIt.I.get<EventBus>().on<NavigationScreen>().listen((event) {
      if (mounted) {
        setState(() {
          currentScreen = event.routeName;
        });
      }
    });
  }

  createScreen(String routeName) {
    if(!isLoading){
      switch (routeName) {
        case "dashboard":
          return DashboardScreen(usersList, trapsList, registerList);
        case "pin_trap":
          return PinTrapScreen(trapsList, null);
        case "users":
          return UserScreen(usersList, trapsList, registerList);
        case "devices":
          return DevicesScreen(registerList, trapsList);
      }
    }else{
      return Center(child: CircularProgressIndicator());
    }
  }


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChangeNotifier>(
          create: (context) => GetIt.I.get<CurrentMenuController>()
        ),
      ],
      child: BlocProvider(
        create: (context) => _dashboardBloc,
        child: BlocListener<DashboardBloc, DashboardBlocState>(
          listener: (context, state) {

            if(state is LoadingBoardBlocState){
              if(mounted){
                setState(() {
                  isLoading = true;
                });
              }
            }else if(state is UpdatedBoardBlocState){
              setState(() {
                isLoading = false;
                usersList = state.allUsers ?? [];
                trapsList = state.allTraps ?? [];
                registerList = state.registries ?? [];
              });
            }else if( state is SepPoiBoardBlocState){
              _dashboardBloc.add(RefreshAllDataEvent());
            }else if (state is RefreshAllDataState){
              setState(() {
                isLoading = false;
                usersList = state.allUsers ?? [];
                trapsList = state.allTraps ?? [];
                registerList = state.registries ?? [];
              });
            }
          },
          bloc: _dashboardBloc,
          child: BlocBuilder<DashboardBloc, DashboardBlocState>(
            builder: (context, state) {
              return Scaffold(
                key:
                    GetIt.I.get<CurrentMenuController>()
                    .scaffoldKey,
                drawer: SideMenu(),
                body: SafeArea(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // We want this side menu only for large screen
                      if (Responsive.isDesktop(context))
                        Expanded(
                          // default flex = 1
                          // and it takes 1/6 part of the screen
                          child: SideMenu(),
                        ),
                      Expanded(
                        // It takes 5/6 part of the screen
                        flex: 5,
                        child: createScreen(currentScreen),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }


}

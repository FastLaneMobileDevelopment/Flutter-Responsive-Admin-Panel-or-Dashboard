import 'package:event_bus/event_bus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:yupcity_admin/bloc/devices/devices_bloc.dart';
import 'package:yupcity_admin/bloc/devices/devices_bloc_event.dart';
import 'package:yupcity_admin/bloc/devices/devices_bloc_state.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:yupcity_admin/i18n.dart';
import 'package:yupcity_admin/models/events/ResetDevice.dart';
import 'package:yupcity_admin/models/events/TrapSearchEvent.dart';
import 'package:yupcity_admin/models/yupcity_register.dart';
import 'package:yupcity_admin/models/yupcity_trap_poi.dart';
import 'package:yupcity_admin/screens/traps/add_new_trap.dart';
import 'package:yupcity_admin/screens/traps/pin_trap.dart';
import 'package:yupcity_admin/screens/traps/trap_details.dart';
import 'package:yupcity_admin/services/application/devices_logic.dart';

import '../../constants.dart';
import 'edit_trap.dart';

class DevicesTable extends StatefulWidget {
  final List<YupcityRegister> allRegistries;
  final List<YupcityTrapPoi> allTraps;

  DevicesTable(this.allRegistries, this.allTraps);

  @override
  State<DevicesTable> createState() => _DevicesTableState();
}

class _DevicesTableState extends State<DevicesTable> {
  var _devicesBloc = DevicesBloc(logic: YupcityDevicesLogic());
  List<YupcityTrapPoi> trapsList = [];
  bool isLoading = true;

  List<String> choices = <String>[
    "Editar posición",
    "Controlar cierres",
    "Eliminar lock",
  ];

  static const platformSearch = MethodChannel('samples.flutter.dev/lock');



  Future<dynamic> _platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case 'reset_done':
        {

          var list = (call.arguments as List<dynamic>).map((e) => e.toString()).toList();

          Alert(
              type: AlertType.warning,
              context: context,
              title: "Inicializado " + list.first,
              buttons: [

                DialogButton(
                  color: Colors.deepOrange,
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
              desc: "")
              .show();
          return Future.value("lockData");
        }
    //return Future.error('error message!!');
      default:
        print('Unknowm method ${call.method}');
        throw MissingPluginException();
    }
  }




  @override
  void initState() {
    super.initState();
    _devicesBloc.add(
        GetTrapsWithRegistriesEvent(widget.allTraps, widget.allRegistries));
    platformSearch.setMethodCallHandler(_platformCallHandler);
    GetIt.I.get<EventBus>().on<TrapSearchEvent>().listen((event) {
      if (mounted) {
        setState(() {
          trapsList = event.traps;
        });
      }
    });


  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _devicesBloc,
      child: BlocListener<DevicesBloc, DevicesBlocState>(
        listener: (context, state) {
          if (state is LoadingTrapsBlocState) {
            if (mounted) {
              setState(() {
                isLoading = true;
              });
            }
          } else if (state is UpdatedDataTrapsBlocState) {
            setState(() {
              isLoading = false;
              trapsList = state.allTraps ?? [];
            });
          } else if (state is ErrorTrapBlocState) {}
        },
        child: BlocBuilder<DevicesBloc, DevicesBlocState>(
          builder: (context, state) {
            return Container(
              padding: EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    I18n.of(context).traps,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: DataTable2(
                      columnSpacing: defaultPadding,
                      minWidth: 1200,
                      columns: [
                        DataColumn2(
                          size: ColumnSize.S,
                          label: Text(""),
                        ),
                        DataColumn2(
                          size: ColumnSize.M,
                          label: Text(I18n.of(context).place_alias),

                        ),
                        DataColumn2(
                          size: ColumnSize.L,
                          label: Text(I18n.of(context).description),
                        ),

                        DataColumn(label:
                                  Text("lock1")
                        ),
                        DataColumn(label:
                        Text("lock2")
                        ),
                        DataColumn(label:
                        Text("lock3")
                        ),
                        DataColumn(label:
                        Text("lock4")
                        ),
                        DataColumn(label:
                        Text("uses")
                        )
                      ],
                      rows: List.generate(
                        trapsList.length,
                        (index) => devicesDataRow(
                            trapsList[index], context, widget.allRegistries),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  DataRow devicesDataRow(
      YupcityTrapPoi trap, BuildContext context, allRegistries) {
    return


      DataRow(
      cells: [
        DataCell(

            Container(
          width: 10,
          child:  PopupMenuButton(
              onSelected: _select,
              padding: EdgeInsets.zero,

              // initialValue: choices[_selection],
              itemBuilder: (BuildContext context) {
                return choices.map((String choice) {
                  return  PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );}
                ).toList();
              }),
        ),
          onTap: () {
              moveToPinTrap(context, null, trap);
          },

        ),
        DataCell(
            Container(
              width: 200,
              child: Row(
                children: [
                  Icon(
                    Icons.lock_outline,
                    color: Colors.lightBlue,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: Text(trap.center!),
                  ),
                ],
              ),
            ),
            onTap: () {
              moveToEdit(context, trap);
            },
            onDoubleTap: () {
        }),
        DataCell(Container(
            width: 250,
            child: Text(trap.centerDescription ?? "")), onTap: () {
            deleteTrap(context, trap.sId ?? "");
        }),
        ((trap.lock1?.isNotEmpty ?? false) && (trap.lockData1?.isNotEmpty ?? false)) ?
        DataCell(Text(trap.lock1 ?? ""),
            onTap: () {
              unLockTrap(context,trap.sId ?? "", trap.lock1 ?? "", trap.lockData1 ?? "");
            },
            ) : DataCell(Container()),
        ((trap.lock2?.isNotEmpty ?? false) && (trap.lockData2?.isNotEmpty ?? false)) ?
        DataCell(Text(trap.lock2 ?? ""),
          onTap: () {
              unLockTrap(context,trap.sId ?? "", trap.lock2 ?? "", trap.lockData2 ?? "");
            },
           ) : DataCell(Container()),
        ((trap.lock3?.isNotEmpty ?? false) && (trap.lockData3?.isNotEmpty ?? false)) ?
        DataCell(Text(trap.lock3 ?? ""),
          onTap: () {
              unLockTrap(context,trap.sId ?? "", trap.lock3 ?? "", trap.lockData3 ?? "");
            },
           ) : DataCell(Container()),
        ((trap.lock4?.isNotEmpty ?? false) && (trap.lockData4?.isNotEmpty ?? false)) ?
        DataCell(Text(trap.lock4 ?? ""),
          onTap: () {
              unLockTrap(context,trap.sId ?? "", trap.lock4 ?? "", trap.lockData4 ?? "");
            },
           ) : DataCell(Container()),
        DataCell(Text(trap.numberOfUses.toString()), onTap: () {
          moveToDetail(context, allRegistries, trap);
        }),

      ],
    );
  }

  void _select(String choice) {
    setState(() {
      _selectedChoices = choice;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  String _selectedChoices = "";

  String getLocksName(YupcityTrapPoi trapPoi) {
    return (trapPoi.lock1 ?? "") + "," + (trapPoi.lock2 ?? "") + ","
        + (trapPoi.lock3 ?? "") + "," + (trapPoi.lock4 ?? "");
  }

  void deleteTrap(BuildContext context,String trapId) async {
    Alert(
        type: AlertType.warning,
        context: context,
        title: "Eliminar trap " + trapId,
        buttons: [
          DialogButton(
            color: Colors.blue,
            child: Text(
              "Accept",
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
            onPressed: () async {
              _devicesBloc.add(DeleteTrapEvent(trapId));
              // Navigator.pop(context);
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          DialogButton(
            color: Colors.deepOrange,
            child: Text(
              "Cancelar",
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          )
        ],
        desc: "")
        .show();



  }


  void unLockTrap(BuildContext context,String trapId, String lockId, String lockData) async {
      Alert(
          type: AlertType.warning,
          context: context,
          title: "Inicializar de fábrica " + lockId,
          buttons: [
            DialogButton(
              color: Colors.blue,
              child: Text(
                "Accept",
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
              onPressed: () async {
                var arguments = { "lockData" : lockData, "lockId" : lockId };
                await platformSearch.invokeMethod("reset_lock", arguments);
                GetIt.I.get<EventBus>().fire(ResetDevice(
                      trapId: trapId,
                      lockId: lockId,
                      lockData: lockData));
                // Navigator.pop(context);
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            DialogButton(
              color: Colors.deepOrange,
              child: Text(
                "Cancelar",
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            )
          ],
          desc: "")
          .show();



  }

  void moveToEdit(BuildContext context, YupcityTrapPoi trap) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  AddNewOrEditTrapScreen(editTrapPoi: trap)),
    );
  }

  void moveToPinTrap(BuildContext context, allRegistries, YupcityTrapPoi trap) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PinTrapScreen(null, trap)),
    );
  }

  void moveToDetail(BuildContext context, allRegistries, YupcityTrapPoi trap) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TrapDetails(allRegistries, trap)),
    );
  }
}

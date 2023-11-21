import 'dart:async';

import 'package:address_search_field/address_search_field.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:yupcity_admin/bloc/dashboard/dashboard_bloc.dart';
import 'package:yupcity_admin/bloc/dashboard/dashboard_bloc_event.dart';
import 'package:yupcity_admin/i18n.dart';
import 'package:yupcity_admin/models/events/FoundNewDevice.dart';
import 'package:yupcity_admin/models/events/ResetDevice.dart';
import 'package:yupcity_admin/models/yupcity_trap_poi.dart';
import 'package:yupcity_admin/services/application/dashboard_logic.dart';
import 'package:yupcity_admin/services/local_storage_service.dart';



class AddNewOrEditTrapScreen extends StatefulWidget {

  final YupcityTrapPoi? editTrapPoi;

  const AddNewOrEditTrapScreen({Key? key, this.editTrapPoi}) : super(key: key);

  @override
  AddNewOrEditTrapScreenState createState() => AddNewOrEditTrapScreenState();
}

enum WorkflowStep { FindInMap, DefineTrap, SelectFirst, SelectSecond, SelectThird, SelectFour, EndTrap }

int currentStepIndex = 0;

class AddNewOrEditTrapScreenState extends State<AddNewOrEditTrapScreen> {

  static const platformSearch = MethodChannel('samples.flutter.dev/lock');


  Completer<GoogleMapController> _controller = Completer();

  TextEditingController textEditingControllerName = TextEditingController();
  TextEditingController textEditingControllerMac = TextEditingController();
  TextEditingController textEditingControllerLockData = TextEditingController();

  TextEditingController textEditingTrapName = TextEditingController();
  TextEditingController textEditingTrapDescription = TextEditingController();
  TextEditingController textEditingTrapCustomer = TextEditingController();




  TextStyle styleText = const TextStyle(color: Colors.white);
  final DateFormat formatter = DateFormat('MMMM, dd, yyyy');

  String type = "Trap";

  final _formKey = GlobalKey<FormBuilderState>();

  final Color _backGroundColor = Color(0xFFF1F5F8);

  bool hasLogData = false;

  String nameTrap = "";

  String descriptionTrap = "";

  String customerTrap = "Aqua";

  late StateSetter currentSetter;

  ScrollController? _scrollController;

  String currentMac = "";

  String currentLockData = "";

  String currentName = "";

  Address? destinationAddress;

  List<FoundNewDevice> currentDevices = List<FoundNewDevice>.empty(growable: true);

  Future<dynamic> _platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case 'found_lockData':
        {
          print('call found_lockData : arguments = ${call.arguments}');
          var list = (call.arguments as List<dynamic>).map((e) => e.toString()).toList();
          GetIt.I.get<EventBus>().fire(FoundNewDevice(name: list[0], mac: list[1], lockData: list[2]));
          return Future.value("lockData");
        }
      case 'found':
        print('call found : arguments = ${call.arguments}');
        if (call.arguments is List<String>) {
            currentSetter(() {
              currentName = call.arguments[0];
              currentMac = call.arguments[1];
              currentLockData = call.arguments[2];
            });
        }
        return Future.value('called from platform!');
    //return Future.error('error message!!');
      default:
        print('Unknowm method ${call.method}');
        throw MissingPluginException();
        break;
    }
  }

  Position? currentPosition;

  WorkflowStep currentStep = WorkflowStep.DefineTrap;

  WorkflowStep previousStep = WorkflowStep.DefineTrap;

   TextEditingController textEditingLocationController = TextEditingController();


  bool isKeypad = false;

  bool isOpened = true;

  String keyValue = "";

  String dockId = "";

  LatLng dockPosition = LatLng(0,0);

  Set<Marker> lockedMarker = Set();

  BitmapDescriptor? pinLocationIcon;

  late String imageUrl;

  LatLng? selectedPosition;

  late YupcityTrapPoi currentYupcityTrapPoi;

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentDevices = GetIt.I.get<LocalStorageService>().getLocks();

    GetIt.I.get<EventBus>().on<ResetDevice>().listen((event) {
        List<FoundNewDevice> newList = List<FoundNewDevice>.empty(growable: true);

        currentDevices.forEach((element) {
          if (element.name != event.lockId) {
            newList.add(element);
          }
        });

        currentDevices.clear();
        currentDevices = newList;
        textEditingControllerName.text = "";
        textEditingControllerMac.text = "";
        textEditingControllerLockData.text = "";
        GetIt.I.get<LocalStorageService>().setLocks(currentDevices);
    });

    GetIt.I.get<EventBus>().on<FoundNewDevice>().listen((event) {
      if (!currentDevices.contains(event)) {
        currentDevices.add(event);
        GetIt.I.get<LocalStorageService>().setLocks(currentDevices);
        setState(() {
        });
      }
    });

    currentYupcityTrapPoi = widget.editTrapPoi ?? YupcityTrapPoi();
    _startBluetooth();
    _determinePosition();
    if (widget.editTrapPoi != null) {
      Marker point = Marker(markerId: MarkerId(currentYupcityTrapPoi.sId ?? ""), position: LatLng(currentYupcityTrapPoi.lat ?? 0.0, currentYupcityTrapPoi.lon ?? 0.0));
      markers.clear();
      lockedMarker.add(point);
    }
  }

  Set<Marker> markers = Set();

  Widget _buildStepForm(WorkflowStep state,  LatLng selectedPosition, BuildContext context) {
    var arguments = { "step" : currentStep.index.toString() };
    platformSearch.invokeMethod("search", arguments);
    debugPrint("Print:" + state.name);
    debugPrint("Print CurrentIndex:" + currentStepIndex.toString());
    int dataIndex = currentStepIndex-2;
    if (currentDevices.length != 0 && currentDevices.length > dataIndex) {
      var device = currentDevices[dataIndex];
      textEditingControllerName.text = device.name;
      textEditingControllerMac.text = device.mac;
      textEditingControllerLockData.text = device.lockData;
    }
    else {
      textEditingControllerName.text = "";
      textEditingControllerMac.text = "";
      textEditingControllerLockData.text = "";
    }

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.black87,
      child: Stack(
        children: [
          Wrap(
              alignment: WrapAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(I18n.of(context).new_trap_associate_lock, style: TextStyle(fontSize: 26),),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child:  Column(
                    children: [
                      FormBuilder(
                        key: _formKey,
                        child:
                        Column(
                          children: [
                            TextField(
                              controller: textEditingControllerName,
                              decoration: InputDecoration(
                                labelText:
                                I18n.of(context).new_trap_lock_name,
                              ),
                              onChanged: (value){
                                currentName = value ?? "";
                              },

                              keyboardType: TextInputType.name,
                            ),
                            TextField(
                              controller: textEditingControllerMac,
                              enabled: false,
                              decoration: InputDecoration(
                                labelText:
                                I18n.of(context).new_trap_lock_mac,
                              ),
                              onChanged: (value){
                                currentMac = value ?? "";
                              },
                              // valueTransformer: (text) => num.tryParse(text),


                              keyboardType: TextInputType.name,
                            ),
                            TextField(
                              controller: textEditingControllerLockData,
                              enabled: false,
                              decoration: InputDecoration(
                                labelText:
                                I18n.of(context).new_trap_lock_data,
                              ),
                              onChanged: (value){
                                currentLockData = value ?? "";
                              },
                              // valueTransformer: (text) => num.tryParse(text),

                              keyboardType: TextInputType.name,
                            )

                          ],
                        ),

                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width-20,
                          child: ElevatedButton(

                            child: Text(I18n.of(context).new_trap_associate_lock),
                            onPressed: ()  {
                              var arguments = { "step" : currentStep.index.toString() };
                              platformSearch.invokeMethod("getLockData", arguments);
                            },
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width-20,
                          child: ElevatedButton(

                            child: Text(I18n.of(context).new_trap_lock_open),
                            onPressed: () async {
                              var arguments = { "lockData" :  textEditingControllerLockData.text };
                              await platformSearch.invokeMethod("open", arguments);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width-20,
                          child: ElevatedButton(

                            child: Text(I18n.of(context).new_trap_lock_close),
                            onPressed: () async {
                              var arguments = { "lockData" :  textEditingControllerLockData.text };
                              await platformSearch.invokeMethod("close", arguments);
                            },
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width-20,
                          child: ElevatedButton(

                            child: Text(I18n.of(context).new_trap_unassociate_lock),
                            onPressed: () async {
                              var arguments = { "lockData" : textEditingControllerLockData.text, "lockId" : textEditingControllerName.text };
                              await platformSearch.invokeMethod("reset_lock", arguments);

                              },
                          ),
                        ),
                      ),


                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width-20,
                          child: ElevatedButton(

                            child: Text(I18n.of(context).new_trap_continue),
                            onPressed: ()  {
                                setState(() {
                                  currentStepIndex++;
                                  if (type.toLowerCase() == "soca") {
                                    if (currentStepIndex == 4 || currentStepIndex == 5) {
                                      currentStepIndex = 6;
                                    }
                                    currentStep = WorkflowStep.values.elementAt(
                                        currentStepIndex);

                                  }
                                  else {
                                    currentStep = WorkflowStep.values.elementAt(
                                        currentStepIndex);
                                  }
                                });


                              /* _formKey.currentState?.save() ;
                                if (_formKey.currentState?.validate() ?? false) {
                                  print(_formKey.currentState?.value);
                                  _onSummited(selectedPosition, nameTrap, descriptionTrap);
                                  Navigator.pop(context);
                                  setState(() {
                                    lockedMarker.clear();
                                  });

                                  final snackBar = SnackBar(
                                    duration: Duration(seconds: 6),
                                    content: Text(I18n.of(context).new_trap_successfully, style: TextStyle(fontSize: 16, color: Colors.white),),
                                    backgroundColor: Color(0xFF212332),
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                } else {
                                  print("validation failed");
                                } */
                              // debugPrint("Name " + _formKey.currentState?.value["name"] + "Description " + _formKey.currentState?.value["description"] + "position " + selectedPosition.toString() );
                              // Either invalidate using Form Key
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width-20,
                          child: ElevatedButton(

                            child: Text(I18n.of(context).new_trap_previous),
                            onPressed: ()  {
                              if (_formKey.currentState?.validate() ?? false) {
                                setState(() {
                                  currentStepIndex--;
                                  if (type.toLowerCase() == "soca") {
                                    if (currentStepIndex == 3 || currentStepIndex == 4) {
                                      currentStepIndex = 2;
                                    }
                                    currentStep = WorkflowStep.values.elementAt(
                                        currentStepIndex);

                                  }
                                  else {
                                    currentStep = WorkflowStep.values.elementAt(
                                        currentStepIndex);
                                  }
                                });
                              }
                              else{
                                final snackBar = SnackBar(
                                  duration: Duration(seconds: 6),
                                  content: Text(I18n.of(context).place_alias, style: TextStyle(fontSize: 16, color: Colors.white),),
                                  backgroundColor: Color(0xFF212332),
                                );

                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }

                              /* _formKey.currentState?.save() ;
                          if (_formKey.currentState?.validate() ?? false) {
                            print(_formKey.currentState?.value);
                            _onSummited(selectedPosition, nameTrap, descriptionTrap);
                            Navigator.pop(context);
                            setState(() {
                              lockedMarker.clear();
                            });

                            final snackBar = SnackBar(
                              duration: Duration(seconds: 6),
                              content: Text(I18n.of(context).new_trap_successfully, style: TextStyle(fontSize: 16, color: Colors.white),),
                              backgroundColor: Color(0xFF212332),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(snackBar);

                          } else {
                            print("validation failed");
                          } */
                              // debugPrint("Name " + _formKey.currentState?.value["name"] + "Description " + _formKey.currentState?.value["description"] + "position " + selectedPosition.toString() );
                              // Either invalidate using Form Key
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 3 - 30,
                      )
                    ],
                  ),

                )
              ]
          )

        ],
      ),
    );
  }

  Widget _buildAddNewEndTrapForm(LatLng selectedPosition, BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: textEditingTrapName,
          decoration: InputDecoration(
            labelText:
            I18n.of(context).new_trap_lock_name,
          ),
          onChanged: (value){
            currentName = value ?? "";
          },

          keyboardType: TextInputType.name,
        ),
        TextField(
          controller: textEditingTrapDescription,
          enabled: false,
          decoration: InputDecoration(
            labelText:
            I18n.of(context).new_trap_lock_mac,
          ),
          onChanged: (value){
            currentMac = value ?? "";
          },
          // valueTransformer: (text) => num.tryParse(text),


          keyboardType: TextInputType.name,
        ),

        TextField(
          controller: textEditingTrapCustomer,
          enabled: false,
          decoration: InputDecoration(
            labelText:
            I18n.of(context).new_trap_lock_mac,
          ),
          onChanged: (value){
            currentMac = value ?? "";
          },
          // valueTransformer: (text) => num.tryParse(text),


          keyboardType: TextInputType.name,
        ),

        Expanded(

          child: ListView.builder(itemBuilder: (context, index){

            return Container(
              width: MediaQuery.of(context).size.width,
              height: 250.0 * currentDevices.length,
              color: Colors.blue,
              child: ListTile(
                title: Text(currentDevices[index].name),
                subtitle: Text(currentDevices[index].mac + "\n" + currentDevices[index].lockData),
                isThreeLine: true,
              ),
            );

          }, itemCount: currentDevices.length,),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            width: MediaQuery.of(context).size.width-40,
            height: 40,
            child: ElevatedButton(
              child: Text(I18n.of(context).save),
              onPressed: ()  {
                  print(_formKey.currentState?.value);
                  _onSummited(selectedPosition, nameTrap, descriptionTrap, customerTrap, currentDevices);
                  Navigator.pop(context);
                  setState(() {
                    lockedMarker.clear();
                  });

                  final snackBar = SnackBar(
                    duration: Duration(seconds: 6),
                    content: Text(I18n.of(context).new_trap_successfully, style: TextStyle(fontSize: 16, color: Colors.white),),
                    backgroundColor: Color(0xFF212332),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                // debugPrint("Name " + _formKey.currentState?.value["name"] + "Description " + _formKey.currentState?.value["description"] + "position " + selectedPosition.toString() );
                // Either invalidate using Form Key
              },
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 3 - 30,
        )
      ],
    );
  }

  Widget _buildAddNewTrapForm(LatLng selectedPosition, BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child:  Column(
              children: [
                FormBuilder(
                  key: _formKey,
                  child:
                  Column(
                    children: [
                      FormBuilderTextField(
                      name: 'name',
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText:
                        I18n.of(context).trap_name,
                      ),
                      onChanged: (value){
                          nameTrap = value ?? "";
                          currentYupcityTrapPoi.center = value ?? "";
                          textEditingTrapName.text = nameTrap;
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required( errorText: I18n.of(context).required_name),
                        FormBuilderValidators.max( 30, errorText: I18n.of(context).max_letters),
                      ]),
                      keyboardType: TextInputType.name,
                ),
                      FormBuilderTextField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        name: 'description',
                        decoration: InputDecoration(
                          labelText:
                          I18n.of(context).description,
                        ),
                        onChanged: (value){
                              descriptionTrap = value ?? "";
                              currentYupcityTrapPoi.centerDescription = value ?? "";
                              textEditingTrapDescription.text = descriptionTrap;
                        },
                        // valueTransformer: (text) => num.tryParse(text),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(errorText: I18n.of(context).required_description),
                          FormBuilderValidators.max(70, errorText: "Max 70 caracteres"),
                        ]),
                        keyboardType: TextInputType.name,
                      ),
                    ],
                  ),

                ),
                Container(
                  width: MediaQuery.of(context).size.width - 50,
                  child: DropdownButton<String>(

                    value: customerTrap,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.white),
                    underline: Container(
                      height: 2,
                      color: Colors.white,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        customerTrap = newValue!;
                      });
                    },
                    items: <String>['Aqua', 'Soca']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),


          Container(
            width: MediaQuery.of(context).size.width - 50,
            child: DropdownButton<String>(

              value: type,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.white),
              underline: Container(
                height: 2,
                color: Colors.white,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  type = newValue!;
                });
              },
              items: <String>['Trap', 'Soca']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),


                SizedBox(
                  height: 20,
                ),

                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width-20,
                    child: ElevatedButton(
                      child: Text(I18n.of(context).new_trap_continue),
                      onPressed: ()  {
                        if (_formKey.currentState?.validate() ?? false) {
                          setState(() {
                            currentStepIndex++;
                            if (type.toLowerCase() == "soca") {
                                if (currentStepIndex == 4 || currentStepIndex == 5) {
                                   currentStepIndex = 6;
                                }
                                currentStep = WorkflowStep.values.elementAt(
                                      currentStepIndex);

                            }
                            else {
                                currentStep = WorkflowStep.values.elementAt(
                                    currentStepIndex);
                            }
                          });
                        }
                        else{
                          final snackBar = SnackBar(
                            duration: Duration(seconds: 6),
                            content: Text(I18n.of(context).place_alias, style: TextStyle(fontSize: 16, color: Colors.white),),
                            backgroundColor: Color(0xFF212332),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }

                       /* _formKey.currentState?.save() ;
                        if (_formKey.currentState?.validate() ?? false) {
                          print(_formKey.currentState?.value);
                          _onSummited(selectedPosition, nameTrap, descriptionTrap);
                          Navigator.pop(context);
                          setState(() {
                            lockedMarker.clear();
                          });

                          final snackBar = SnackBar(
                            duration: Duration(seconds: 6),
                            content: Text(I18n.of(context).new_trap_successfully, style: TextStyle(fontSize: 16, color: Colors.white),),
                            backgroundColor: Color(0xFF212332),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);

                        } else {
                          print("validation failed");
                        } */
                       // debugPrint("Name " + _formKey.currentState?.value["name"] + "Description " + _formKey.currentState?.value["description"] + "position " + selectedPosition.toString() );
                          // Either invalidate using Form Key
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width-20,
                    child: ElevatedButton(
                      child: Text(I18n.of(context).new_trap_previous),
                      onPressed: ()  {
                        if (_formKey.currentState?.validate() ?? false) {
                          setState(() {
                            currentStepIndex--;
                            if (type.toLowerCase() == "soca") {
                              if (currentStepIndex == 4 || currentStepIndex == 5) {
                                currentStepIndex = 3;
                              }
                              currentStep = WorkflowStep.values.elementAt(
                                  currentStepIndex);

                            }
                            else {
                              currentStep = WorkflowStep.values.elementAt(
                                  currentStepIndex);
                            }
                          });
                        }
                        else{
                          final snackBar = SnackBar(
                            duration: Duration(seconds: 6),
                            content: Text(I18n.of(context).place_alias, style: TextStyle(fontSize: 16, color: Colors.white),),
                            backgroundColor: Color(0xFF212332),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }

                        /* _formKey.currentState?.save() ;
                        if (_formKey.currentState?.validate() ?? false) {
                          print(_formKey.currentState?.value);
                          _onSummited(selectedPosition, nameTrap, descriptionTrap);
                          Navigator.pop(context);
                          setState(() {
                            lockedMarker.clear();
                          });

                          final snackBar = SnackBar(
                            duration: Duration(seconds: 6),
                            content: Text(I18n.of(context).new_trap_successfully, style: TextStyle(fontSize: 16, color: Colors.white),),
                            backgroundColor: Color(0xFF212332),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);

                        } else {
                          print("validation failed");
                        } */
                        // debugPrint("Name " + _formKey.currentState?.value["name"] + "Description " + _formKey.currentState?.value["description"] + "position " + selectedPosition.toString() );
                        // Either invalidate using Form Key
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3 - 30,
                )
              ],
            ),

        )

      ],
    );

  }

  void _onSummited(LatLng selectedPosition, String center, String centerDescription, String customerId, List<FoundNewDevice> list){
    var _dashboardBloc = DashboardBloc(logic: YupcityDashboardLogic());
    String lock1 = "";
    String lock2 = "";
    String lock3 = "";
    String lock4 = "";
    String lockMac1 = "";
    String lockMac2 = "";
    String lockMac3 = "";
    String lockMac4 = "";
    String lockData1 = "";
    String lockData2 = "";
    String lockData3 = "";
    String lockData4 = "";


    if (list.length > 3)
    {
        lock4 = list[3].name;
        lockMac4 = list[3].mac;
        lockData4 = list[3].lockData;
    }

    if (list.length > 2)
    {
      lock3 = list[2].name;
      lockMac3 = list[2].mac;
      lockData3 = list[2].lockData;
    }

    if (list.length > 1)
    {
      lock2 = list[1].name;
      lockMac2 = list[1].mac;
      lockData2 = list[1].lockData;
    }

    if (list.length > 0) {
      lock1 = list[0].name;
      lockMac1 = list[0].mac;
      lockData1 = list[0].lockData;
    }

    var newTrap =  YupcityTrapPoi(
      center: center,
      centerDescription: centerDescription,
      lat: selectedPosition.latitude,
      lon: selectedPosition.longitude,
      customer: customerId,
      type: type,
      lock1: lock1,
      lockMac1: lockMac1,
      lockData1: lockData1,
      lockState1: 0,
      lock2: lock2,
      lockMac2: lockMac2,
      lockData2: lockData2,
        lockState2: 0,

        lock3: lock3,
      lockMac3: lockMac3,
      lockData3: lockData3,
        lockState3: 0,

        lock4: lock4,
      lockMac4: lockMac4,
      lockData4: lockData4,
      lockState4: 0,

    );

    _dashboardBloc.add(SetPoiEvent(newTrap));
  }

  void _startBluetooth() async {
    platformSearch.invokeMethod("reset");
    var arguments = { "step" : currentStep.index.toString() };
    platformSearch.invokeMethod("search", arguments);
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

  Widget buildDashboard(BuildContext context, )  {
    currentStepIndex = 0;
    platformSearch.invokeMethod("reset");

    return Stack(
      children: [
        currentPosition == null
            ? Container()
            : GoogleMap(
                mapType: MapType.normal,
                markers: lockedMarker,
                initialCameraPosition: widget.editTrapPoi == null ?  CameraPosition(
                  target: LatLng(currentPosition?.latitude ?? 0.0,
                      currentPosition?.longitude ?? 0.0),
                  zoom: 17.4746,
                ) : CameraPosition(
                  target: LatLng(widget.editTrapPoi?.lat ?? 0.0, widget.editTrapPoi?.lon ?? 0.0),
                  zoom: 17.4746,
                ),
                onLongPress: (LatLng pos){
                  Marker point = Marker(markerId: MarkerId("id"), position: pos);
                setState(() {
                  markers.clear();
                  markers.add(point);
                  selectedPosition = pos;
                  currentStepIndex++;
                  currentStep = WorkflowStep.DefineTrap;
                });
                },
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);

                }),
            widget.editTrapPoi != null ? Positioned(
              bottom: 20,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width-20,
                  child: ElevatedButton(

                    child: Text(I18n.of(context).new_trap_lock_close),
                    onPressed: ()  {
                      currentStepIndex++;
                      currentStep = WorkflowStep.DefineTrap;                    },
                  ),
                ),
              ),

            ) : Container(),
         /* Positioned(
              right: 20,
              top: 90,
              child: Container(
                color: Colors.deepOrangeAccent,
                width: 200,
                height: 50,
                child: TextField(
                  controller: textEditingLocationController,
                  onTap: () {
                    openSearchDialog();
                  },
                  onChanged: (text) {

                  },
                ),
              ))*/

      ],
    );
  }

  String titleFromStep(WorkflowStep step) {
    switch(step)
    {
      case WorkflowStep.FindInMap: return I18n.of(context).how_create_new_trap;
      case WorkflowStep.DefineTrap: return I18n.of(context).new_trap_definetrap;
      case WorkflowStep.SelectFirst: return I18n.of(context).new_trap_selectfirst;
      case WorkflowStep.SelectSecond: return I18n.of(context).new_trap_selectsecond;
      case WorkflowStep.SelectThird: return I18n.of(context).new_trap_selectthird;
      case WorkflowStep.SelectFour: return I18n.of(context).new_trap_selectfour;
      case WorkflowStep.EndTrap: return I18n.of(context).new_trap_endtrap;
      default: return "";
    }
  }

  void backStep(BuildContext context) async
  {
    if (currentStepIndex == 0) {
        await Alert(context: context,
          title: "Atención",
          buttons: [
            DialogButton(child: Text("OK"), onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            }),
            DialogButton(child: Text("Cancel"), onPressed: () {
              Navigator.pop(context);
            })
          ]


        ).show();
        return;
    }

    currentStepIndex--;
    if (type.toLowerCase() == "soca") {
      if (currentStepIndex == 3 || currentStepIndex == 4) {
        currentStepIndex = 2;
      }
      currentStep = WorkflowStep.values.elementAt(
          currentStepIndex);

    }
    else {
      currentStep = WorkflowStep.values.elementAt(
          currentStepIndex);
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(

          actions: [
            // TODO Activar el search de busqueda de direcciones
            /*currentStepIndex == 0 ? IconButton(icon: const Icon(Icons.search), onPressed: () {
              openSearchDialog();

            },) : Container()*/
          ],


          centerTitle: true,
          automaticallyImplyLeading: true,
          titleSpacing: 15,
          title: Container(
              decoration: BoxDecoration(
                color: Color(0xFF212332),
              ),
              child: Text(titleFromStep(currentStep),overflow: TextOverflow.visible, style: TextStyle(color: Colors.white, fontSize: 14),)
          ),

          bottomOpacity: 0.0,
          elevation: 0,
        ),
        // drawer: DrawerWidget(),
        resizeToAvoidBottomInset: true,
        body: selectStep(selectedPosition ?? LatLng(0, 0), context));
  }

  void openSearchDialog() {
     final geoMethods = GeoMethods(
      googleApiKey: 'AIzaSyBL1yZOaZAyLe2CPCsFlYoIVNddjhKm3wM',
      language: 'es',
      countryCode: 'es',
      countryCodes: ['us', 'es', 'co'],
      country: 'Spain',
    );

    /*AddressSearchBuilder.deft(
      geoMethods: geoMethods,
      controller: textEditingLocationController,
      builder: AddressDialogBuilder(),
      onDone: (Address address) =>  {

      },
    );*/
  }

  Widget selectStep(LatLng selectedPosition, ctx)
  {
    if (currentStep == WorkflowStep.DefineTrap) return _buildAddNewTrapForm(selectedPosition, ctx);
    if (currentStep == WorkflowStep.EndTrap) return  _buildAddNewEndTrapForm(selectedPosition, ctx);
    return _buildStepForm(currentStep, selectedPosition, context);

  }

  Widget child(BuildContext context) {
    return Positioned.fill(
        child: Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height / 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
            ),
          ],
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
              bottomLeft: Radius.zero,
              bottomRight: Radius.zero),
          gradient: LinearGradient(
              colors: [Colors.red, Colors.blue],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
      ),
    ));
  }

  void _showError(BuildContext context, String message) {
    //TODO: Error message
    //FlushBarService.getFlushBar(context, "Error", message);
  }

  decoration(String text, IconData icon) {
    return InputDecoration(
      fillColor: Colors.white,
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white30)),
      focusedBorder:
          const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      prefixIcon: Icon(
        icon,
        color: Colors.white,
      ),
      hintText: text,
      hintStyle: styleText,
    );
  }
}

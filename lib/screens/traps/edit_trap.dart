import 'dart:async';

import 'package:address_search_field/address_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:yupcity_admin/bloc/dashboard/dashboard_bloc.dart';
import 'package:yupcity_admin/bloc/dashboard/dashboard_bloc_event.dart';
import 'package:yupcity_admin/i18n.dart';
import 'package:yupcity_admin/models/yupcity_trap_poi.dart';
import 'package:yupcity_admin/services/application/dashboard_logic.dart';



class EditTrapScreen extends StatefulWidget {

  final YupcityTrapPoi? editTrapPoi;

  const EditTrapScreen({Key? key, this.editTrapPoi}) : super(key: key);

  @override
  EditTrapScreenState createState() => EditTrapScreenState();
}

enum WorkflowStep { FindInMap, DefineTrap, EndTrap }

int currentStepIndex = 0;

class EditTrapScreenState extends State<EditTrapScreen> {

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


    currentYupcityTrapPoi = widget.editTrapPoi ?? YupcityTrapPoi();
    if (widget.editTrapPoi != null) {
      Marker point = Marker(markerId: MarkerId(currentYupcityTrapPoi.sId ?? ""), position: LatLng(currentYupcityTrapPoi.lat ?? 0.0, currentYupcityTrapPoi.lon ?? 0.0));
      markers.clear();
      lockedMarker.add(point);
    }
  }

  Set<Marker> markers = Set();


  void _onSummited(LatLng selectedPosition, String center, String centerDescription, String customerId){
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
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {
            backStep(context);


          },),

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
              child: Text("Editar $type")
          ),

          bottomOpacity: 0.0,
          elevation: 0,
        ),
        // drawer: DrawerWidget(),
        resizeToAvoidBottomInset: true,
        body:  _buildEditTrapForm(context));
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


  Widget _buildEditTrapForm(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
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
                        initialValue: currentYupcityTrapPoi.center,
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
                        initialValue: currentYupcityTrapPoi.centerDescription,
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
                          FormBuilderValidators.max( 70, errorText: "Max 70 caracteres"),
                        ]),
                        keyboardType: TextInputType.name,
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
                    ],
                  ),

                ),
            


                SizedBox(
                  height: 20,
                ),

                Container(
                  height: MediaQuery.of(context).size.height/3,
                  child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Colors.teal[100],
                          child:  Column(
                            children: [
                              Text(widget.editTrapPoi?.lock1 ?? ""),
                              Text(widget.editTrapPoi?.lockMac3 ?? ""),
                              Text(widget.editTrapPoi?.lockData3 ?? ""),
                            ],
                          )
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.teal[200],
                        child: const Text('Heed not the rabble'),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.teal[300],
                        child: const Text('Sound of screams but the'),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.teal[400],
                        child: const Text('Who scream'),
                      ),

                    ],
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
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3 - 30,
                )
              ],
            ),

          )

        ],
      ),
    );

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

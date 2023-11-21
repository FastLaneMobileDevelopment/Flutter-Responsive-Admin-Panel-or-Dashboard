import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:yupcity_admin/bloc/auth/login_bloc/login_fields_form_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:yupcity_admin/screens/main/main_screen.dart';
import 'package:yupcity_admin/screens/recovery_password.dart';
import 'package:yupcity_admin/screens/register_page.dart';
import 'package:yupcity_admin/services/local_storage_service.dart';
import 'package:yupcity_admin/services/navigator_service.dart';

import '../i18n.dart';

class LoginScreenPage extends StatefulWidget {
  const LoginScreenPage({Key? key}) : super(key: key);

  @override
  _LoginScreenPageState createState() => _LoginScreenPageState();
}

class _LoginScreenPageState extends State<LoginScreenPage> {
  late TextStyle? _headLineStyle;

  late TextStyle? _textLineStyle;

  late bool? _passwordVisible;

 // late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    _headLineStyle = Theme.of(context).textTheme.headline5;
    _textLineStyle = Theme.of(context).textTheme.bodyText1;
    _textLineStyle?.apply(fontWeightDelta: 12);
    return BlocProvider(
      create: (context) => LoginFieldsFormBloc(),
      child: Builder(builder: (BuildContext context) {
        final formBloc = BlocProvider.of<LoginFieldsFormBloc>(context);
        if (kDebugMode) {
          formBloc.textEmail.updateInitialValue("jordi.buges+929@gmail.com");
          formBloc.textPassword.updateInitialValue("12345678");
        }

        return
           Scaffold(
              backgroundColor: const Color(0xFF212332),
              body: FormBlocListener<LoginFieldsFormBloc, String, String>(
                onSubmitting: (context, state) {
                  var email = formBloc.textEmail.value;
                  var password = formBloc.textPassword.value;
                  // BlocProvider.of<LoginBlocBloc>(context).add(DoLoginEvent(email, password));
                },
                onSuccess: (context, state) async {
                  if (state is FormBlocSuccess<String, String>) {
                    if (GetIt.I.get<LocalStorageService>().getEmail()) {
                      GetIt.I.get<NavigationService>().navigateToWithParams(
                          NavigationService.dashBoardPage,
                          state.successResponse);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainScreen()),
                      );
                    }
                    else {
                      await Alert(context: context,
                          style: AlertStyle(
                            backgroundColor: Colors.white
                          ),

                          type: AlertType.info,
                          desc:  "Debe confirmar su correo electronico, vaya a su inbox y revise si ha llegado la verificación del correo. Compruebe la carpeta spam.",
                          buttons: [
                            DialogButton(child: Text("Reenviar correo"), onPressed: () async {
                              await FirebaseAuth.instance.currentUser?.sendEmailVerification();
                              await FirebaseAuth.instance.signOut();
                              Navigator.of(context, rootNavigator: true).pop();


                            }),
                            DialogButton(child: Text("OK"), onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.of(context, rootNavigator: true).pop();
                            })

                          ]


                      ).show();
                    }

                  }

                  //LoadingDialog.hide(context);
                },
                onFailure: (context, state) {
                 Fluttertoast.showToast(
                      msg: state.failureResponse!,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 5
                  );
                },
                child: Stack(
                  children: [
                    /*Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: VideoPlayer(_controller)),*/
                    SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 40.0),
                          child: Column(
                            children: [
                              Container(
                                width: 300,
                                height: 100,
                                child: Image.asset(
                                  "assets/images/yupcharge_logo.png", color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Container(
                                width: 300,
                                height: 200,
                                child: Image.asset(
                                  "assets/images/trap.png",
                                ),
                              ),
                              /*Text(I18n.of(context).login_title,
                                  style: GoogleFonts.manrope(textStyle: _headLineStyle?.apply(color: Color(0xFF48B3C9),),fontSize: 32, fontWeight: FontWeight.w700)),
                              Text(
                                I18n.of(context).login_message,
                                style: GoogleFonts.manrope(fontWeight: FontWeight.w700, fontSize: 28),
                                textAlign: TextAlign.center,
                              ),*/
                              const SizedBox(
                                height: 40,
                              ),
                              TextFieldBlocBuilder(
                                textFieldBloc: formBloc.textEmail,
                                decoration: InputDecoration(
                                  focusColor: Color(0xFF2A2D3E),
                                  hoverColor: Color(0xFF2A2D3E),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  filled: true,
                                  contentPadding: const EdgeInsets.all(16),
                                  labelText: "Email",

                                  fillColor: Color(0xFF2A2D3E),
                                ),
                              ),
                              TextFieldBlocBuilder(
                                textFieldBloc: formBloc.textPassword,
                                suffixButton: SuffixButton.obscureText,
                                autofillHints: const [AutofillHints.password],
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.all(16),
                                  labelText: "Password",
                                  fillColor: Color(0xFF2A2D3E),
                                  filled: true,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      // Based on passwordVisible state choose the icon
                                      _passwordVisible ?? false
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      // Update the state i.e. toogle the state of passwordVisible variable
                                      setState(() {
                                        _passwordVisible ?? false
                                            ? _passwordVisible = false
                                            : _passwordVisible = true;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              RawMaterialButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>  RecoverLoginPage()),
                                    );

                                  },
                                  child: Text(I18n.of(context).recover_title)),
                              ElevatedButton(
                                onPressed: () {
                                  // GetIt.I.get<NavigationService>().navigateTo("datsmi_dashboarPage");
                                  formBloc.submit();
                                },
                                style: ButtonStyle(
                                    padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(vertical: 15, horizontal: 60)),
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                    shape: MaterialStateProperty.all(const StadiumBorder())),
                                child: Text(I18n.of(context).login_init),
                              ),
                              RawMaterialButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>  RegisterScreenPage()),
                                    );
                                  },
                                  child: Text(
                                    I18n.of(context).login_register,
                                    style:
                                        const TextStyle(fontWeight: FontWeight.bold),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ));
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

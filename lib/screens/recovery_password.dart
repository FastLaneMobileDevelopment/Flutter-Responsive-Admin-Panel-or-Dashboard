import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:yupcity_admin/bloc/auth/register_bloc/recover_fields_form_bloc.dart';
import 'package:yupcity_admin/services/navigator_service.dart';

import '../../i18n.dart';


class RecoverLoginPage extends StatefulWidget {
  const RecoverLoginPage({Key? key}) : super(key: key);

  @override
  _RecoverLoginPage createState() => _RecoverLoginPage();
}

class _RecoverLoginPage extends State<RecoverLoginPage> {

  late  TextStyle? _headLineStyle;

  late  TextStyle? _textLineStyle;

  var validatorEmail = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  late TextEditingController emailController;





  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => RecoverFieldsFormBloc(),
        child: Builder(builder: (BuildContext context) {
          _headLineStyle = Theme.of(context).textTheme.headline5;
          _textLineStyle = Theme.of(context).textTheme.bodyText1;
          _textLineStyle?.apply(fontWeightDelta: 12);
          final formBloc = BlocProvider.of<RecoverFieldsFormBloc>(context);
          if (kDebugMode) {
            formBloc.textEmail.updateInitialValue("jordi.buges+50@gmail.com");
          }

          return
            Scaffold(
                backgroundColor: const Color(0xFFF1F5F8),
                body: FormBlocListener<RecoverFieldsFormBloc, bool, String>(
                  onSubmitting: (context, state) {

                    // BlocProvider.of<LoginBlocBloc>(context).add(DoLoginEvent(email, password));
                  },
                  onSuccess: (context, state) async {
                    if (state is FormBlocSuccess<bool, String>) {

                    }


                    await Fluttertoast.showToast(
                        msg: I18n.of(context).recover_otp_help,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1
                    );

                    GetIt.I.get<NavigationService>().navigateTo(NavigationService.checkOtpPage);

                    //LoadingDialog.hide(context);
                  },
                  onFailure: (context, state) {
                    Fluttertoast.showToast(
                        msg: state.failureResponse!,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1
                    );
                  },
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 40.0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 40,
                            ),
                            Container(
                              width: 300,
                              height: 100,
                              child: Image.asset(
                                "assets/images/yupcharge_logo.png",
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Text("",
                                style: _headLineStyle),

                            const SizedBox(
                              height: 60,
                            ),
                            TextFieldBlocBuilder(
                              textFieldBloc: formBloc.textEmail,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.all(16),
                                labelText: I18n.of(context).textfield_email,
                                fillColor: Colors.white,
                                filled: true
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                //GetIt.I.get<NavigationService>().navigateTo("datsmi_dashboarPage");
                                formBloc.submit();
                              },
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all<EdgeInsets>(
                                      const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 60)),
                                  backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.blue),
                                  shape: MaterialStateProperty.all(
                                      const StadiumBorder())),
                              child: Text(I18n.of(context).recover_go),
                            ),
                            RawMaterialButton(
                                onPressed: onPressedLogin,
                                child: Text(
                                  I18n.of(context).login_login,
                                  style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ));
        })
    );
  }

  void onPressedLogin() {
    GetIt.I.get<NavigationService>().navigateTo(NavigationService.loginPage);
  }

}



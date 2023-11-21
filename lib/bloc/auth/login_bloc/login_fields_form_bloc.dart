import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:yupcity_admin/services/application/login_logic.dart';

class LoginFieldsFormBloc extends FormBloc<String, String> {


  final textEmail = TextFieldBloc();
  final textPassword = TextFieldBloc();


  LoginFieldsFormBloc() {
    addFieldBlocs(fieldBlocs: [
      textEmail,
      textPassword,

    ]);
  }

  void addErrors() {
    textEmail.addFieldError('Introduzca email');
    textPassword.addFieldError('Introduzca contraseña');
  }

  @override
  void onSubmitting() async {
    try {
      var loginLogic = FirebaseLoginLogic();
      var response = await loginLogic.login(textEmail.value, textPassword.value);
      if (!response.toString().contains("firebase")) {
        emitSuccess(successResponse: response, canSubmitAgain: true);
      }
      else {
          emitFailure(failureResponse:response);
      }
    } catch (e) {
      emitFailure(failureResponse:e.toString());
    }
  }
}
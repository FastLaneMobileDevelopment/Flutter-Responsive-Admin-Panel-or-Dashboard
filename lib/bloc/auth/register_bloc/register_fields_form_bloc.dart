import 'package:yupcity_admin/services/application/login_logic.dart';
import 'package:yupcity_admin/services/application/register_logic.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class RegisterFieldsFormBloc extends FormBloc<String, String> {


  final textCustomer = TextFieldBloc();
  final textName = TextFieldBloc();
  final textEmail = TextFieldBloc();
  final textTelephone = TextFieldBloc();
  final textPassword = TextFieldBloc();

  final textPassword2 = TextFieldBloc();


  RegisterFieldsFormBloc() {
    addFieldBlocs(fieldBlocs: [
      textCustomer,
      textName,
      textEmail,
      textTelephone,
      textPassword,
      textPassword2,

    ]);
  }

  void addErrors() {
    textCustomer.addFieldError('Introduzca el clientId');
    textName.addFieldError('Introduzca el nombre');
    textEmail.addFieldError('Introduzca email');
    textPassword.addFieldError('Introduzca contraseña');
    textPassword2.addFieldError('Introduzca constraseña');
  }

  @override
  void onSubmitting() async {
    try {
      var registerLogic = FirebaseRegisterLogic();
      textTelephone.updateInitialValue("");
      var responseRegister = await registerLogic.register("", textCustomer.value, textName.value, textEmail.value, textTelephone.value, textPassword.value, "admin");
      var loginLogic = FirebaseLoginLogic();
      var token = await loginLogic.login(textEmail.value, textPassword.value);
      emitSuccess(successResponse: "", canSubmitAgain: true);
    } catch (e) {
      emitFailure(failureResponse:e.toString());
    }
  }
}
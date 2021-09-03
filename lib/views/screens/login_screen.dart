import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/device_size_extension.dart';
import '../../core/form_validator.dart';
import '../../core/service.dart';
import '../../core/sharedManager.dart';
import '../components/customSnackbar.dart';
import '../components/customWidgets.dart';
import '../mobx/login/obscurelogin.dart';

class LoginScreen extends StatelessWidget with FormValidator {
  final CustomWidgets _widgets = CustomWidgets.instance;
  final TextEditingController _controllerMail = TextEditingController();
  final TextEditingController _controllerPassw = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final CustomSnackBar _snackBar = CustomSnackBar.instance;
  final Service _service = Service.getInstance();
  final ObscureLoginStore obscureLogin = ObscureLoginStore();
  final SharedManager _sharedManager = SharedManager.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _widgets.customAppBar(),
      body: GestureDetector(
        onTap: () {
          unFocus(context);
        },
        child: Center(
            child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 100),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _textFormField('Kullanıcı Adı', Icons.person, _controllerMail,
                      validateEmail, false, [], null),
                  Observer(
                    builder: (context) => _textFormField(
                        'Şifre',
                        FontAwesomeIcons.key,
                        _controllerPassw,
                        validatePassword,
                        obscureLogin.isObscure,
                        [FilteringTextInputFormatter.digitsOnly],
                        changeObscureIcon()),
                  ),
                  _submitButton(context)
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }

  Container _textFormField(
      String title,
      IconData icon,
      TextEditingController controller,
      Function validator,
      bool obscure,
      List<TextInputFormatter> inputFormat,
      IconButton obscureIcon) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: TextFormField(
          obscureText: obscure,
          inputFormatters: inputFormat,
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            suffixIcon: obscureIcon,
            contentPadding: EdgeInsets.only(left: 20),
            icon: Icon(icon),
            border: _widgets.customTextFieldDecoration(Colors.grey),
            enabledBorder: _widgets.customTextFieldDecoration(Colors.grey),
            disabledBorder: _widgets.customTextFieldDecoration(Colors.grey),
            focusedBorder: _widgets.customTextFieldDecoration(Colors.grey),
            errorBorder: _widgets.customTextFieldDecoration(Colors.red),
            labelText: title,
          ),
        ));
  }

  IconButton changeObscureIcon() {
    return IconButton(
      icon: Icon(
        Icons.remove_red_eye,
        color: Colors.red,
      ),
      onPressed: () {
        obscureLogin.changeObscure();
      },
    );
  }

  Container _submitButton(BuildContext context) {
    var disableButton = false;
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        width: context.width,
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(10)),
        child: TextButton.icon(
            onPressed: () async {
              unFocus(context);
              if (!disableButton) {
                disableButton = true;
                _snackBar.removeSnackBar(context);
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  var res = await _service.login(
                      _controllerMail.text, _controllerPassw.text);
                  if (!res['HasError']) {
                    _snackBar.showSnackBar(context, Colors.green, 'Giriş Başarılı');
                    await _sharedManager.setToken(
                        res['Data']['Token'], _controllerMail.text);
                    Future.delayed(Duration(milliseconds: 500), () {
                      _snackBar.removeSnackBar(context);
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/discover', (route) => false);
                    });
                  } else {
                    _snackBar.showSnackBar(context, Colors.red, res['Message']);
                  }
                }
                disableButton = false;
              }
            },
            icon: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
            label: Text(
              'Giriş Yap',
              style: TextStyle(color: Colors.white),
            )));
  }

  void unFocus(BuildContext context) {
    var currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}

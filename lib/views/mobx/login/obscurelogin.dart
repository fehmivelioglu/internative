import 'package:mobx/mobx.dart';

part 'obscurelogin.g.dart';

class ObscureLoginStore = ObscureLogin with _$ObscureLoginStore;

abstract class ObscureLogin with Store{
  @observable
  bool isObscure = true;
  
  @action
  void changeObscure(){
    isObscure = !isObscure;
  }

}
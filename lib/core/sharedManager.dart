import 'package:shared_preferences/shared_preferences.dart';

class SharedManager {
  SharedPreferences _preferences;

  static SharedManager instance = SharedManager._privateConstructor();

  SharedManager._privateConstructor();

  static Future<void> init() async {
    instance._preferences = await SharedPreferences.getInstance();
  }

  String get getToken {
    return _preferences.getString('token').toString();
  }

   String get getEmail {
    return _preferences.getString('email').toString();
  }

  Future<void> setToken(String token,String email) async {
    await _preferences.setString('email', email);
    await _preferences.setString('token', token);
  }

  // Future<void> clearShared() async {
  //   await _preferences.clear();
  // }
}

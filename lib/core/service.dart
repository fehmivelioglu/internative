import 'dart:convert';

import 'package:http/http.dart' as http;

import 'sharedManager.dart';
import 'user_model.dart';

class Service {
  String _apiUrl;
  final SharedManager _sharedManager = SharedManager.instance;
  static final Service _instance = Service._privateConstructor();

  Service._privateConstructor() {
    _apiUrl = 'http://test13.internative.net';
  }

  static Service getInstance() {
    if (_instance == null) {
      return Service._privateConstructor();
    } else {
      return _instance;
    }
  }

  Future login(String email, String passw) async {
    var _url = _apiUrl + '/Login/SignIn';
    final response = await http.post(
      Uri.parse(_url),
      body: json.encode({'email': email, 'password': passw}),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );
    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  Future getUsers() async {
    var _url = _apiUrl + '/User/GetUsers';
    return await userListMethod(_url);
  }

  Future getFriendList() async {
    var _url = _apiUrl + '/Account/GetFriendList';
    return await userListMethod(_url);
  }

  Future getUserDetail(String id) async {
    var _url = _apiUrl + '/User/GetUserDetails';
    final response = await http.post(
      Uri.parse(_url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + _sharedManager.getToken
      },
      body: json.encode({'id': id}),
    );
    final jsonResponse = json.decode(response.body);
    var _user = UserModel.fromJson(jsonResponse['Data']);
    return _user;
  }

  Future addToFriends(String id) async {
    var _url = _apiUrl + '/User/AddToFriends';
    return await friendOperationMethod(_url, id);
  }

  Future removeFromFriends(String id) async {
    var _url = _apiUrl + '/User/RemoveFromFriends';
    return await friendOperationMethod(_url, id);
  }

  Future friendOperationMethod(String _url, String id) async {
    final response = await http.post(
      Uri.parse(_url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + _sharedManager.getToken
      },
      body: json.encode({'userid': id}),
    );
    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  Future userListMethod(String _url) async {
    final response = await http.get(
      Uri.parse(_url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + _sharedManager.getToken
      },
    );
    final jsonResponse = json.decode(response.body);
    var _users =
        jsonResponse['Data'].map((e) => UserModel.fromJson(e)).toList();
    return _users;
  }
}

import 'package:flutter/material.dart';

class CustomWidgets {
  static CustomWidgets _instace;
  static CustomWidgets get instance {
    _instace ??= CustomWidgets._init();
    return _instace;
  }

  CustomWidgets._init();

  AppBar customAppBar() {
    return AppBar(backgroundColor: Colors.red, title: Text('Fav Internative'));
  }

  OutlineInputBorder customTextFieldDecoration(Color color) {
    return OutlineInputBorder(
        borderSide: BorderSide(color: color),
        borderRadius: BorderRadius.circular(5));
  }
}

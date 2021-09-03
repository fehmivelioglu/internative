import 'package:flutter/material.dart';

class CustomSnackBar {
  static CustomSnackBar _instance;
  static CustomSnackBar get instance {
    _instance ??= CustomSnackBar._init();
    return _instance;
  }

  CustomSnackBar._init();

  SnackBar snackbar(String title, Color color) {
    return SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: color,
    );
  }

  void showSnackBar(BuildContext context, Color color, String title) {
    ScaffoldMessenger.of(context).showSnackBar(snackbar(title, color));
  }

  void removeSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }
}

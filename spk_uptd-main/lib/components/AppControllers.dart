import 'dart:math';
import 'package:flutter/material.dart';

class AppControllers extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  bool isObscureTextProv = true;
  bool get getisObscureTextProv => isObscureTextProv;
  void secureText(bool x) {
    isObscureTextProv = x;
    notifyListeners();
  }
}

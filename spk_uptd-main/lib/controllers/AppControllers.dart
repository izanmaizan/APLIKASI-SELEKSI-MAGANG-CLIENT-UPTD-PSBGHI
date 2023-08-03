import 'dart:math';
import 'package:flutter/material.dart';

class AppControllers extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  bool isObscureTextProv = true;
  bool get getisObscureTextProv => isObscureTextProv;

  int menuChoices = 0;
  int get getMenuChoices => menuChoices;

  String customShowDialog = "";
  String get getcustomShowDialog => customShowDialog;

  int menuMagang = 0;
  int get getmenuMagang => menuMagang;

  List<List<dynamic>> trainingData = [];
  List<List<dynamic>> get gettrainingData => trainingData;
  int trainingDataLayak = 0;
  int get gettrainingDataLayak => trainingDataLayak;
  int trainingDataTidak = 0;
  int get gettrainingDataTidak => trainingDataTidak;

  int menuC45Choice = 0;
  int get getmenuC45Choice => menuC45Choice;

  List<List<String>> isiTable = [];
  List<List<String>> get getisiTable => isiTable;

  List<int> colsTables = [];
  List<int> rowTables = [];
  List<int> get getColsTables => colsTables;
  List<int> get getRowsTables => rowTables;

  int editClient = 0;
  int get geteditClient => editClient;
  String namaEditClient = "";
  String get getnamaEditClient => namaEditClient;

  List<String> userActive = [];
  List<String> get getuserActive => userActive;
  int authChoices = 0;
  int get getAuthChoices => authChoices;

  int menuKelolaPengguna = 0;
  int get getmenuKelolaPengguna => menuKelolaPengguna;

  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  void secureText(bool x) {
    isObscureTextProv = x;
    notifyListeners();
  }

  void setmenuchoice(int x) {
    menuChoices = x;
    notifyListeners();
  }

  void setShowDialog(String x) {
    customShowDialog = x;
    notifyListeners();
  }

  void setmenuMagang(int x) {
    menuMagang = x;
    notifyListeners();
  }

  void setTrainingData(List<String> x) {
    trainingData.add(x);
    notifyListeners();
  }

  void resetTrainingData() {
    trainingData = [];
    trainingDataLayak = 0;
    trainingDataTidak = 0;
    notifyListeners();
  }

  void setTrainingDataLayak(int x) {
    trainingDataLayak = x;
    notifyListeners();
  }

  void setTrainingDataTidak(int x) {
    trainingDataTidak = x;
    notifyListeners();
  }

  void setMenuProsessing(int x) {
    menuC45Choice = x;
    notifyListeners();
  }

  void setIsiTabel(List<String> x) {
    getisiTable.add(x);
    notifyListeners();
  }

  void setResetIsiTabel() {
    // List<List<String>> isiTablex = [];
    isiTable = [];
    colsTables = [];
    rowTables = [];

    notifyListeners();
  }

  void setColsAndRows(int x, int z) {
    getColsTables.add(x);
    getRowsTables.add(z);
    notifyListeners();
  }

  void setIdEditClient(int x, String nama) {
    editClient = x;
    namaEditClient = nama;
    notifyListeners();
  }

  void setUser(List<String> x) {
    userActive = x;
    notifyListeners();
  }

  void setAuth(int x) {
    authChoices = x;
    notifyListeners();
  }

  void setMenuKelola(int x) {
    menuKelolaPengguna = x;
    notifyListeners();
  }

  void keluar() {
    userActive = [];
    notifyListeners();
  }
}

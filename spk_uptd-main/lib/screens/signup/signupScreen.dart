import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spk_uptd/components/constants.dart';
import 'package:spk_uptd/components/genTextFormField.dart';
import 'package:spk_uptd/controllers/AppControllers.dart';
import 'package:spk_uptd/helpers/dbHelpers.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final dbHelper = DatabaseHelper.instance;
  final _conKodeRegistrasi = TextEditingController();
  final _conUserName = TextEditingController();
  final _conEmail = TextEditingController();
  final _conPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var myListProvider = Provider.of<AppControllers>(context, listen: false);
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.height / 1.3,
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent,
            offset: Offset(0, 2),
            blurRadius: 4.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Text(
            "DAFTAR",
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          getTextFormField(
              controller: _conKodeRegistrasi,
              icon: Icons.code,
              inputType: TextInputType.name,
              labelName: "kode Registrasi",
              hintName: 'Masukan Kode Registrasi Anda'),
          SizedBox(
            height: 20,
          ),
          getTextFormField(
              controller: _conUserName,
              icon: Icons.person,
              inputType: TextInputType.name,
              labelName: "Username",
              hintName: 'Masukan Username Anda'),
          SizedBox(
            height: 20,
          ),
          getTextFormField(
              controller: _conEmail,
              icon: Icons.email,
              inputType: TextInputType.emailAddress,
              labelName: "Email",
              hintName: 'Masukan Email Anda'),
          SizedBox(
            height: 20,
          ),
          getTextFormField(
            controller: _conPassword,
            icon: Icons.lock,
            labelName: "Password",
            hintName: 'Masukan Password Anda',
            isObscureText: true,
          ),
          myListProvider.customShowDialog != ""
              ? SizedBox(
                  height: 10,
                )
              : SizedBox(),
          myListProvider.customShowDialog != ""
              ? Text(
                  myListProvider.customShowDialog.toString(),
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.w400),
                )
              : SizedBox(),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 200,
            height: 50,
            child: TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                primary: Colors.white,
                backgroundColor: primaryColor,
              ),
              onPressed: () {
                readDataByIdAndName();
              },
              child: Text(
                "DAFTAR",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Sudah punya Akun ? "),
              InkWell(
                onTap: () {
                  myListProvider.setAuth(0);
                },
                child: Text(
                  'MASUK',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void readDataByIdAndName() async {
    var myListProvider = Provider.of<AppControllers>(context, listen: false);
    final readData = await dbHelper.database;

    final List<Map<String, dynamic>> rows = await readData.query(
      'user',
      where: 'email = ?',
      whereArgs: [_conEmail.text],
    );
    if (rows.isNotEmpty) {
      final Map<String, dynamic> data = rows.first;
      myListProvider.setShowDialog('User Sudah Ada');
      Timer(Duration(seconds: 2), () {
        myListProvider.setShowDialog("");
      });
    } else {
      _insertData();
    }
  }

  void _insertData() async {
    var myListProvider = Provider.of<AppControllers>(context, listen: false);
    if (_conUserName.text.isNotEmpty ||
        _conEmail.text.isNotEmpty ||
        _conPassword.text.isNotEmpty) {
      String akses = "";
      if (_conKodeRegistrasi.text == "333") {
        akses = "admin";
      } else if (_conKodeRegistrasi.text == "123") {
        akses = "staff";
      } else {
        String akses = "umum";
      }
      final data = {
        'username': _conUserName.text,
        'email': _conEmail.text,
        'password': _conPassword.text,
        'tgl_lahir': "-",
        'alamat': "-",
        'jabatan': "-",
        'telepon': "-",
        'foto': "assets/images/profil.png",
        'akses': akses,
        'isActive': 0,
      };
      final id = await dbHelper.insertData(data);
      myListProvider.setShowDialog('User Sudah Dibuat');
      Timer(Duration(seconds: 2), () {
        myListProvider.setShowDialog("");
        myListProvider.setAuth(0);
      });
      // print('Data inserted with id: $id');
    }
  }
}

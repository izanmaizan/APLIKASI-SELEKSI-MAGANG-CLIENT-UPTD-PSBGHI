import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:spk_uptd/components/constants.dart';
import 'package:spk_uptd/components/genTextFormField.dart';
import 'package:spk_uptd/controllers/AppControllers.dart';
import 'package:spk_uptd/helpers/dbHelpers.dart';

class SigninScreen extends StatelessWidget {
  final dbHelper = DatabaseHelper.instance;
  final _conEmail = TextEditingController();
  final _conPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var myListProvider = Provider.of<AppControllers>(context, listen: false);
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.height / 1.5,
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
            "MASUK",
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
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
                readDataByIdAndName(context);
              },
              child: Text(
                "MASUK",
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
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("Belum Punya Akun ? "),
            InkWell(
              onTap: () {
                myListProvider.setAuth(1);
              },
              child: Text(
                'Daftar',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  void readDataByIdAndName(BuildContext context) async {
    var myListProvider = Provider.of<AppControllers>(context, listen: false);
    final readData = await dbHelper.database;

    final List<Map<String, dynamic>> rows = await readData.query(
      'user',
      where: 'email = ? AND password = ?',
      whereArgs: [_conEmail.text, _conPassword.text],
    );
    if (rows.isNotEmpty) {
      // print(data);
      final Map<String, dynamic> data = rows.first;

      // final id = await dbHelper.updateData(data);

      List<String> _data = [];
      _data.add(data['id'].toString());
      _data.add(data['username'].toString());
      _data.add(data['email'].toString());
      _data.add(data['akses'].toString());
      _data.add(data['tgl_lahir'].toString());
      _data.add(data['alamat'].toString());
      _data.add(data['jabatan'].toString());
      _data.add(data['telepon'].toString());
      _data.add(data['foto'].toString());
      _data.add(data['isActive'].toString());
      // _updateData(context, rows);

      myListProvider.setUser(_data);
    } else {
      myListProvider.setShowDialog('User tidak ditemukan');
      Timer(Duration(seconds: 2), () {
        myListProvider.setShowDialog("");
      });
      // print('Data tidak ditemukan');
      // _insertData();
    }
  }
}

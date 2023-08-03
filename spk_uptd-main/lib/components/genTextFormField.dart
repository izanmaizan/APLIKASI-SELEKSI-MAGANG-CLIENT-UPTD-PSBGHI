import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants.dart';

import '../controllers/AppControllers.dart';
import 'helpers.dart';

class getTextFormField extends StatelessWidget {
  TextEditingController controller;
  String labelName;
  String hintName;
  IconData icon;
  bool isObscureText;
  TextInputType inputType;
  bool isEnable;

  getTextFormField(
      {required this.controller,
      required this.labelName,
      required this.hintName,
      required this.icon,
      this.isObscureText = false,
      this.inputType = TextInputType.text,
      this.isEnable = true});

  @override
  Widget build(BuildContext context) {
    var myListProvider = Provider.of<AppControllers>(context, listen: false);

    return Container(
      width: (MediaQuery.of(context).size.width / 2) - 50,
      child: TextFormField(
        controller: controller,
        obscureText: isObscureText
            ? myListProvider.getisObscureTextProv
                ? true
                : false
            : false,
        enabled: isEnable,
        keyboardType: inputType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $hintName';
          }
          if (hintName == "Email" && !validateEmail(value)) {
            return 'Please Enter Valid Email';
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: isObscureText
              ? IconButton(
                  onPressed: () {
                    if (myListProvider.isObscureTextProv) {
                      myListProvider.secureText(false);
                    } else {
                      myListProvider.secureText(true);
                    }
                  },
                  icon: myListProvider.isObscureTextProv
                      ? Icon(icon)
                      : Icon(Icons.lock_open))
              : Icon(icon),
          labelText: labelName,
          hintText: hintName,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              width: 2,
              color: Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              width: 3,
              color: primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spk_uptd/components/constants.dart';
import 'package:spk_uptd/controllers/AppControllers.dart';

import 'component/my_fields.dart';
import 'component/my_tables.dart';
import 'component/c45_prosses.dart';

class C45Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var myListProvider = Provider.of<AppControllers>(context, listen: false);
    return SafeArea(
      child: SafeArea(
        child: SingleChildScrollView(
          primary: false,
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  myListProvider.customShowDialog != ""
                      ? Container(
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          width: 200,
                          child: Center(
                            child: Text(
                              myListProvider.customShowDialog.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : Text(""),
                ],
              ),
              MyFields(),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 10,
                height: MediaQuery.of(context).size.height / 1.1,
                color: secondaryColor,
                child: Column(
                  children: [
                    myListProvider.menuC45Choice == 0
                        ? MyTables()
                        : C45Prossesing(),
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

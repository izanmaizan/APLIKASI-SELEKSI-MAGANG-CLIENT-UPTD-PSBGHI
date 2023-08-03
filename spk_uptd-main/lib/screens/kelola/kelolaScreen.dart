import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spk_uptd/components/constants.dart';
import 'package:spk_uptd/components/responsive.dart';
import 'package:spk_uptd/controllers/AppControllers.dart';
import 'component/my_tables.dart';
// import 'component/tambah.dart';
// import 'component/review_tables.dart';
// import 'component/edit.dart';

class KelolaScreen extends StatelessWidget {
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
              SizedBox(
                height: 5,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 10,
                height: MediaQuery.of(context).size.height / 1.1,
                color: secondaryColor,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "DAFTAR PENGGUNA",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        // MyOptional(),
                      ],
                    ),
                    Consumer<AppControllers>(
                      builder: (context, appControllers, child) {
                        Widget selectedScreen;

                        switch (appControllers.menuKelolaPengguna) {
                          case 0:
                            selectedScreen = MyTables();
                            break;
                          // case 1:
                          //   selectedScreen = TambahScreen();
                          //   break;
                          // case 2:
                          //   selectedScreen = ReviewTables();
                          //   break;
                          // case 3:
                          //   selectedScreen = EditScreen();
                          //   break;

                          default:
                            selectedScreen = MyTables();
                        }
                        return selectedScreen;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

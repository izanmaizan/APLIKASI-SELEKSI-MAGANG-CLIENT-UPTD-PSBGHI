import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spk_uptd/components/constants.dart';
import 'package:spk_uptd/components/genTextFormField.dart';
import 'package:spk_uptd/components/responsive.dart';
import 'package:spk_uptd/controllers/AppControllers.dart';
import 'package:spk_uptd/helpers/dbHelpers.dart';

class ReviewTables extends StatefulWidget {
  @override
  State<ReviewTables> createState() => _ReviewTablesState();
}

class _ReviewTablesState extends State<ReviewTables> {
  void saveToSQL(context) async {
    var myListProvider = Provider.of<AppControllers>(context, listen: false);
    final dbHelper = DatabaseHelper.instance;
    if (myListProvider.getisiTable.isNotEmpty) {
      try {
        // print(myListProvider.getisiTable.toString());
        for (var i = 0; i < myListProvider.getisiTable.length; i++) {
          if (i != 0) {
            final data = {
              'nama_client': myListProvider.getisiTable[i][1].toString(),
              'jenis_kelamin_client':
                  myListProvider.getisiTable[i][2].toString(),
              'umur_client': myListProvider.getisiTable[i][3].toString(),
              'klasifikasi_kecacatan_client':
                  myListProvider.getisiTable[i][4].toString(),
              'tanggal_lahir_client':
                  myListProvider.getisiTable[i][5].toString(),
              'tanggal_masuk_client':
                  myListProvider.getisiTable[i][6].toString(),
              'nilai_raport': myListProvider.getisiTable[i][7].toString(),
            };
            final id = await dbHelper.insertDataClient(data);
          }
        }
        myListProvider.setShowDialog("Save Sukses");
        Timer(Duration(seconds: 2), () {
          myListProvider.setShowDialog("");
        });
      } catch (e) {
        myListProvider.setShowDialog("Save Gagal");
        Timer(Duration(seconds: 2), () {
          myListProvider.setShowDialog("");
        });
      }
    }
  }

  ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    var myListProvider = Provider.of<AppControllers>(context, listen: false);
    return Expanded(
        child: Container(
      // color: Color.fromARGB(255, 23, 24, 33),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      // Tindakan yang ingin Anda lakukan saat ikon kembali diklik
                      myListProvider.setmenuMagang(0);
                    },
                  ),
                  Text("Kembali"),
                  SizedBox(
                    width: 50,
                  ),
                  Text(
                    "REVIEW DATA FROM EXCEL",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  ElevatedButton.icon(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: defaultPadding * 1.5,
                        vertical: defaultPadding /
                            (Responsive.isMobile(context) ? 2 : 1),
                      ),
                    ),
                    onPressed: () {
                      saveToSQL(context);
                    },
                    icon: Icon(Icons.save),
                    label: Text("SAVE"),
                  ),
                ],
              ),
              Consumer<AppControllers>(
                builder: (context, setable, child) {
                  return setable.isiTable.isNotEmpty
                      ? (setable.getRowsTables[0] % setable.getColsTables[0]) ==
                              0
                          ? Text("BISA")
                          : Container(
                              width: MediaQuery.of(context).size.width / 1.3,
                              height: 500,
                              // color: Colors.red,
                              child: Scrollbar(
                                controller: controller,
                                child: SingleChildScrollView(
                                  controller: controller,
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Container(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Table(
                                            columnWidths: const {
                                              0: FixedColumnWidth(50),
                                              1: FixedColumnWidth(250),
                                              2: FixedColumnWidth(110),
                                              3: FixedColumnWidth(110),
                                              4: FixedColumnWidth(110),
                                              5: FixedColumnWidth(120),
                                              6: FixedColumnWidth(110),
                                              7: FixedColumnWidth(110),
                                              8: FixedColumnWidth(110),
                                              9: FixedColumnWidth(110),
                                              10: FixedColumnWidth(110),
                                            },
                                            border: TableBorder.symmetric(
                                              inside: BorderSide(
                                                  width: 2,
                                                  color: Color.fromARGB(
                                                      184, 7, 7, 7)),
                                              outside: BorderSide(
                                                  width: 1,
                                                  color: Color.fromARGB(
                                                      240, 0, 0, 0)),
                                            ),
                                            defaultColumnWidth:
                                                FixedColumnWidth(150),
                                            defaultVerticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            children: [
                                              for (var x = 0;
                                                  x <
                                                      setable
                                                          .getisiTable.length;
                                                  x++)
                                                ...(x == 0
                                                    ? [
                                                        TableRow(
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                Color.fromARGB(
                                                                    186,
                                                                    3,
                                                                    3,
                                                                    3),
                                                          ),
                                                          children: [
                                                            for (var xx = 0;
                                                                xx <
                                                                    setable
                                                                        .getisiTable[
                                                                            x]
                                                                        .length;
                                                                xx++)
                                                              ...(xx == 0
                                                                  ? [
                                                                      Container(
                                                                        height:
                                                                            40,
                                                                        width:
                                                                            10,
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            setable.getisiTable[x][xx].toString(),
                                                                            style:
                                                                                TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ]
                                                                  : [
                                                                      Text(
                                                                        setable
                                                                            .getisiTable[x][xx]
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15.0,
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                    ]),
                                                          ],
                                                        ),
                                                      ]
                                                    : [
                                                        TableRow(
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                Color.fromARGB(
                                                                    69,
                                                                    0,
                                                                    0,
                                                                    0),
                                                          ),
                                                          children: [
                                                            for (var xx = 0;
                                                                xx <
                                                                    setable
                                                                        .getisiTable[
                                                                            x]
                                                                        .length;
                                                                xx++)
                                                              ...(xx == 1
                                                                  ? [
                                                                      Text(
                                                                        "  " +
                                                                            setable.getisiTable[x][xx].toString(),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15.0),
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                      )
                                                                    ]
                                                                  : [
                                                                      Text(
                                                                        setable
                                                                            .getisiTable[x][xx]
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15.0),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      )
                                                                    ]),
                                                          ],
                                                        ),
                                                      ]),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                      : Text("DATA BELUM ADA");
                },
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

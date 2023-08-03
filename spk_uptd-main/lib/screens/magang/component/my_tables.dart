import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spk_uptd/components/constants.dart';
import 'package:spk_uptd/components/responsive.dart';
import 'package:spk_uptd/controllers/AppControllers.dart';
import 'package:spk_uptd/helpers/dbHelpers.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

class MyTables extends StatefulWidget {
  const MyTables({Key? key}) : super(key: key);

  @override
  State<MyTables> createState() => _MyTablesState();
}

class _MyTablesState extends State<MyTables> {
  final dbHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> dataList = [];
  List<Map<String, dynamic>> filteredList = [];
  TextEditingController searchController = TextEditingController();
  bool loadingS = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    dataList = await DatabaseHelper.instance.fetchDataClient();
    filterData(""); // Initialize the filtered list with all data
  }

  void filterData(String query) {
    // var myListProvider = Provider.of<AppControllers>(context, listen: false);
    // print(query);
    setState(() {
      if (query == "" || query == " ") {
        filteredList = dataList;
      } else {
        filteredList = dataList
            .where((data) =>
                data['nama_client'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      loadingS = false;
    });

    // print(filteredList);
  }

  void openFilePicker(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    var myListProvider = Provider.of<AppControllers>(context, listen: false);
    if (myListProvider.isiTable.isNotEmpty) {
      myListProvider.setResetIsiTabel();
    }
    if (result != null) {
      PlatformFile file = result.files.first;
      String filePath = file.path!;
      // print('Path berkas: $filePath');
      var files = filePath;
      var bytes = File(files).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      var rowHeadr = 0;
      var rowHeadrClasific = 0;
      for (var table in excel.tables.keys) {
        if (excel.tables[table]!.maxCols != 0 &&
            excel.tables[table]!.maxRows != 0) {
          myListProvider.setColsAndRows(
              excel.tables[table]!.maxCols, excel.tables[table]!.maxRows);
        }
        for (var row in excel.tables[table]!.rows) {
          List<String> isirow = [];
          List<String> lt = [];

          for (var cell in row) {
            if (cell != null) {
              if (cell.value.toString() == "A") {
                lt.add("A");
              } else if (cell.value.toString() == "B") {
                lt.add("B");
              } else if (cell.value.toString() == "C") {
                lt.add("C");
              } else if (cell.value.toString() == "D") {
                lt.add("D");
              } else if (cell.value.toString() == "E") {
                lt.add("E");
              }
              isirow.add(cell.value.toString());
            }
          }
          if (isirow.isNotEmpty) {
            myListProvider.setIsiTabel(isirow);
          }
        }
      }
      myListProvider.setShowDialog("Import Sukses");
      Timer(Duration(seconds: 2), () {
        myListProvider.setShowDialog("");
        myListProvider.setmenuMagang(2);
      });
    } else {
      // Tidak ada berkas yang dipilih
      myListProvider.setShowDialog("Import Gagal");
      Timer(Duration(seconds: 2), () {
        myListProvider.setShowDialog("");
      });
    }
    setState(() {
      loadingS = false;
    });

    // myListProvider.activatedClasification(true);
  }

  void exportToExcel(context) async {
    var myListProvider = Provider.of<AppControllers>(context, listen: false);

    // Create a new Excel workbook
    var excel = Excel.createExcel();

    // Create a new Excel sheet
    var sheet = excel['Sheet1'];

    // Add the title row
    sheet.appendRow([
      "No",
      "Nama Klien",
      "Jenis Kelamin",
      "Umur",
      "Klasifikasi Kecacatan",
      "Tanggal Lahir",
      "Tanggal Masuk",
      "Nilai Raport",
    ]);

    // Add the data rows
    for (var i = 1; i < filteredList.length; i++) {
      var rowData = filteredList[i];
      sheet.appendRow([
        i,
        rowData["nama_client"],
        rowData["jenis_kelamin_client"],
        rowData["umur_client"],
        rowData["klasifikasi_kecacatan_client"],
        rowData["tanggal_lahir_client"],
        rowData["tanggal_masuk_client"],
        rowData["nilai_raport"],
      ]);
    }
    String? outputFile = await FilePicker.platform.saveFile(
      allowedExtensions: ['xlsx'],
      dialogTitle: 'Please select an output file:',
      fileName: 'psbghi_client.xlsx',
    );
    if (outputFile != null) {
      final bytes = excel.encode()!;
      File(outputFile)
        ..createSync(recursive: true)
        ..writeAsBytesSync(bytes);
      myListProvider.setShowDialog("Export Sukses");
      Timer(Duration(seconds: 2), () {
        myListProvider.setShowDialog("");
      });
    } else {
      myListProvider.setShowDialog("Export Gagal");
      Timer(Duration(seconds: 2), () {
        myListProvider.setShowDialog("");
      });
    }
    setState(() {
      loadingS = false;
    });
  }

  ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    var myListProvider = Provider.of<AppControllers>(context, listen: false);
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: TextField(
                    controller: searchController,
                    onChanged: filterData,
                    decoration: InputDecoration(
                      hintText: "Nama Client",
                      fillColor: bgColor,
                      filled: true,
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ),
                myListProvider.userActive[3].toString() == "admin" ||
                        myListProvider.userActive[3].toString() == "staff"
                    ? ElevatedButton.icon(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: defaultPadding * 1.5,
                            vertical: defaultPadding /
                                (Responsive.isMobile(context) ? 2 : 1),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            loadingS = true;
                          });
                          myListProvider.setmenuMagang(1);
                        },
                        icon: Icon(Icons.import_export),
                        label: Text("Add"),
                      )
                    : SizedBox(),
                myListProvider.userActive[3].toString() == "admin" ||
                        myListProvider.userActive[3].toString() == "staff"
                    ? ElevatedButton.icon(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: defaultPadding * 1.5,
                            vertical: defaultPadding /
                                (Responsive.isMobile(context) ? 2 : 1),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            loadingS = true;
                          });
                          openFilePicker(context);
                        },
                        icon: Icon(Icons.import_export),
                        label: Text("Import"),
                      )
                    : SizedBox(),
                myListProvider.userActive[3].toString() == "admin" ||
                        myListProvider.userActive[3].toString() == "staff"
                    ? ElevatedButton.icon(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: defaultPadding * 1.5,
                            vertical: defaultPadding /
                                (Responsive.isMobile(context) ? 2 : 1),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            loadingS = true;
                          });
                          exportToExcel(context);
                        },
                        icon: Icon(Icons.import_export),
                        label: Text("Export"),
                      )
                    : SizedBox(),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
            loadingS
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columnSpacing: 10,
                        dataRowHeight: 40,
                        headingRowHeight: 40,
                        headingRowColor: MaterialStateProperty.all(
                            Color.fromARGB(170, 39, 130, 204)),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Color.fromARGB(239, 240, 240, 240),
                          ),
                        ),
                        columns: [
                          DataColumn(
                            label: Center(
                              child: Text(
                                "No",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Center(
                              child: Text(
                                "Nama Klien",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Jenis Kelamin",
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Umur",
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Klasifikasi Kecacatan",
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Tanggal Masuk",
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Nilai Raport",
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          myListProvider.userActive[3].toString() == "admin" ||
                                  myListProvider.userActive[3].toString() ==
                                      "staff"
                              ? DataColumn(
                                  label: Center(
                                    child: Text(
                                      "OPTION",
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              : DataColumn(label: Text("")),
                        ],
                        rows: [
                          for (int i = 0; i < filteredList.length; i++)
                            DataRow(
                              cells: [
                                DataCell(
                                  Center(
                                    child: Text(
                                      (i + 1).toString(),
                                      style: TextStyle(fontSize: 15.0),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    filteredList[i]['nama_client'],
                                    style: TextStyle(fontSize: 15.0),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                      filteredList[i]['jenis_kelamin_client'],
                                      style: TextStyle(fontSize: 15.0),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                      filteredList[i]['umur_client'],
                                      style: TextStyle(fontSize: 15.0),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                      filteredList[i]
                                          ['klasifikasi_kecacatan_client'],
                                      style: TextStyle(fontSize: 15.0),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                      filteredList[i]['tanggal_masuk_client'],
                                      style: TextStyle(fontSize: 15.0),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                      filteredList[i]['nilai_raport'],
                                      style: TextStyle(fontSize: 15.0),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                myListProvider.userActive[3].toString() ==
                                            "admin" ||
                                        myListProvider.userActive[3]
                                                .toString() ==
                                            "staff"
                                    ? DataCell(Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.cyanAccent,
                                            ),
                                            onPressed: () {
                                              // Tindakan yang ingin Anda lakukan saat ikon kembali diklik
                                              myListProvider.setIdEditClient(
                                                  filteredList[i]['id'],
                                                  filteredList[i]
                                                      ['nama_client']);
                                              myListProvider.setmenuMagang(3);
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.redAccent,
                                            ),
                                            onPressed: () {
                                              // Tindakan yang ingin Anda lakukan saat ikon kembali diklik
                                              deleteDataCliente(
                                                  filteredList[i]['id']);
                                            },
                                          ),
                                        ],
                                      ))
                                    : DataCell(Text("")),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  String valueFrequently(
      String fisik, String mental, String sosial, String keterampilan) {
    // Create an array to store all the input strings
    List<String> inputStrings = [fisik, mental, sosial, keterampilan];

    // Create a Map to store the count of each string
    Map<String, int> countMap = {};

    // Loop through the input strings and count their occurrences
    for (String str in inputStrings) {
      countMap[str] = (countMap[str] ?? 0) + 1;
    }

    // Find the most frequent string
    String mostFrequentString = "";
    int maxCount = 0;
    countMap.forEach((str, count) {
      if (count > maxCount) {
        maxCount = count;
        mostFrequentString = str;
      }
    });

    return mostFrequentString;
  }
  // String valueFrequenly(
  //   String BFisik,
  //   String BMental,
  //   String BSosial,
  //   String BKeterampilan,
  // ) {
  //   String xString = "a";
  //   return xString;
  // }

  void deleteDataCliente(int x) async {
    final id = await dbHelper.deleteDataClient(x);
    fetchData();
  }
}

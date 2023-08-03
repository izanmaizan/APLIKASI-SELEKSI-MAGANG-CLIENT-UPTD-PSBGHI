import 'dart:async';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spk_uptd/components/constants.dart';
import 'package:spk_uptd/components/responsive.dart';
import 'package:spk_uptd/controllers/AppControllers.dart';
import 'package:spk_uptd/helpers/dbHelpers.dart';
import 'package:intl/intl.dart';
import 'package:ml_algo/ml_algo.dart';
import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';

class MyTables extends StatefulWidget {
  const MyTables({Key? key}) : super(key: key);

  @override
  State<MyTables> createState() => _MyTablesState();
}

class _MyTablesState extends State<MyTables> {
  List<Map<String, dynamic>> dataList = [];
  List<Map<String, dynamic>> filteredList = [];
  bool loadingS = true;
  List<String> pohonKeputusan = [];

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
    var myListProvider = Provider.of<AppControllers>(context, listen: false);
    myListProvider.resetTrainingData();
    setState(() {
      if (query == "" || query == " ") {
        filteredList = dataList;
      } else {
        filteredList = dataList
            .where((data) =>
                data['nama_client'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
    int layak = 0;
    int tidak = 0;
    List<String> listData = [];
    for (var cell in filteredList) {
      List<String> lt = [];
      if (int.tryParse(cell['umur_client'])! >= 17) {
        lt.add("Cukup umur");
      } else {
        lt.add("Tidak cukup umur");
      }
      if (hitungTahun(cell['tanggal_masuk_client']) >= 2) {
        lt.add("Sudah lama");
      } else {
        lt.add("Belum lama");
      }
      // if (cell['klasifikasi_kecacatan_client'] ) {

      // }
      lt.add(cell['klasifikasi_kecacatan_client']);
      // lt.add(cell['nilai_raport']);
      if (cell['nilai_raport'] == 'A' ||
          cell['nilai_raport'] == 'B' ||
          cell['nilai_raport'] == 'C') {
        lt.add("Nilai sudah cukup");
      } else {
        lt.add("Nilai belum cukup");
      }

      if (lt[0] == "Tidak cukup umur") {
        lt.add('Tidak');
        tidak += 1;
      } else if (lt[1] == "Belum lama") {
        lt.add('Tidak');
        tidak += 1;
      } else if (cell['klasifikasi_kecacatan_client'] == "Idiot") {
        lt.add('Tidak');
        tidak += 1;
      } else if (lt[1] == "Nilai belum cukup") {
        lt.add('Tidak');
        tidak += 1;
      } else {
        lt.add("Layak");
        layak += 1;
      }

      // lt.add();

      // int tahun = hitungTahun(cell['tanggal_masuk_client']);
      // print(tahun); // lt.add(cell['bimbingan_fisik_client']);
      // lt.add(cell['bimbingan_mental_client']);
      // lt.add(cell['bimbingan_sosial_client']);
      // lt.add(cell['bimbingan_keterampilan_client']);
      // double mean = calculateMean(lt);
      // String status = mean >= 70 ? 'Layak' : 'Tidak Layak';
      // if (status == "Layak") {
      //   pohonKeputusan.add("Layak");
      //   lt.add("Layak");
      //   layak += 1;
      // } else if (status == "Tidak Layak") {
      //   pohonKeputusan.add("Tidak Layak");
      //   lt.add("Tidak Layak");
      //   tidak += 1;
      // } else {
      //   pohonKeputusan.add("Layak/T");
      //   lt.add("Layak");
      //   layak += 1;
      // }
      pohonKeputusan.add(lt[4]);
      myListProvider.setTrainingData(lt);
      // print(cell['umur_client']);
      // prin
      // print(lt);
    }

    // Persiapan data dalam bentuk DataFrame dari pustaka ml_dataframe
    // Data baru untuk prediksi
    // Data aturan klasifikasi
    // Data aturan klasifikasi
    // final Map<String, Map<String, String>> rules = {
    //   'umur': {'Cukup Umur': 'layak', 'Tidak Cukup Umur': 'tidak'},
    //   'tanggalMasuk': {'Sudah Lama': 'layak', 'Belum Lama': 'tidak'},
    //   'klasifikasiKecacatan': {
    //     'Debil': 'layak',
    //     'Imbisil': 'layak',
    //     'Idiot': 'tidak',
    //   },
    //   'nilaiRaport': {
    //     'Nilai sudah cukup': 'layak',
    //     'Nilai belum cukup': 'tidak',
    //   },
    // };

    // // Fungsi untuk melakukan klasifikasi berdasarkan aturan yang telah ditentukan
    // String classify(
    //     Map<String, dynamic> data, Map<String, Map<String, String>> rules) {
    //   for (final entry in rules.entries) {
    //     final attributeName = entry.key;
    //     final attributeValue = data[attributeName].toString();

    //     if (entry.value.containsKey(attributeValue)) {
    //       return entry.value[attributeValue]!;
    //     }
    //   }

    //   return 'Tidak Layak'; // Default jika tidak ada klasifikasi yang sesuai
    // }

    // // Data untuk klasifikasi
    // final List<Map<String, dynamic>> dataset = [
    //   {
    //     'No.': 1,
    //     'umur': 'Cukup Umur',
    //     'Tanggal masuk': 'Sudah Lama',
    //     'Kecacatan': 'Debil',
    //     'Nilai Raport': 'Nilai sudah cukup',
    //   },
    //   {
    //     'No.': 2,
    //     'umur': 'Tidak Cukup Umur',
    //     'Tanggal masuk': 'Belum Lama',
    //     'Kecacatan': 'Imbisil',
    //     'Nilai Raport': 'Nilai belum cukup',
    //   },
    //   {
    //     'No.': 3,
    //     'umur': 'Cukup Umur',
    //     'Tanggal masuk': 'Sudah Lama',
    //     'Kecacatan': 'Idiot',
    //     'Nilai Raport': 'Nilai belum cukup',
    //   },
    //   {
    //     'No.': 4,
    //     'umur': 'Cukup Umur',
    //     'Tanggal masuk': 'Sudah Lama',
    //     'Kecacatan': 'Debil',
    //     'Nilai Raport': 'Nilai belum cukup',
    //   },
    // ];

    // // Lakukan klasifikasi pada setiap data dalam dataset
    // for (final data in dataset) {
    //   final result = classify(data, rules);
    //   print('No. ${data['No.']} - Status: $result');
    // }
    myListProvider.setTrainingDataLayak(layak);
    myListProvider.setTrainingDataTidak(tidak);
    // print(myListProvider.trainingData);
    setState(() {
      loadingS = false;
    });
  }

  int hitungTahun(String tanggalString) {
    final DateTime sekarang = DateTime.now();
    final DateTime tanggalTarget =
        DateFormat("dd-MM-yyyy").parse(tanggalString);

    int yearsDiff = sekarang.difference(tanggalTarget).inDays ~/ 365;
    // if
    // return yearsDiff;
    // print(yearsDiff);
    return yearsDiff;
  }
  // double calculateMean(List<String> lt) {
  //   double sum = 0;

  //   for (String grade in lt) {
  //     double score = gradeToScore(grade);
  //     sum += score;
  //   }

  //   return sum / lt.length;
  // }

  // double gradeToScore(String grade) {
  //   if (grade == 'A') {
  //     return 100;
  //   } else if (grade == 'B') {
  //     return 85;
  //   } else if (grade == 'C') {
  //     return 65;
  //   } else if (grade == 'D') {
  //     return 50;
  //   } else {
  //     return 0;
  //   }
  // }

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
      "Umur",
      "Tanggal masuk",
      "Kecacatan",
      "Nilai raport",
      "Layak/T"
    ]);

    // Add the data rows
    for (var i = 1; i < filteredList.length; i++) {
      var rowData = filteredList[i];
      sheet.appendRow([
        i,
        rowData["nama_client"],
        rowData["umur_client"],
        rowData["klasifikasi_kecacatan_client"],
        rowData["tanggal_masuk_client"],
        rowData["nilai_raport"],
        pohonKeputusan[i]
      ]);
      // print(rowData);
      // print();
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

  @override
  Widget build(BuildContext context) {
    var myListProvider = Provider.of<AppControllers>(context, listen: false);
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: ElevatedButton.icon(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: defaultPadding * 1.5,
                        vertical: defaultPadding /
                            (Responsive.isMobile(context) ? 2 : 1),
                      ),
                    ),
                    onPressed: () {
                      // simpanData();
                      myListProvider.setMenuProsessing(1);
                    },
                    icon: Icon(Icons.precision_manufacturing_sharp),
                    label: Text("Algorithme C45"),
                  ),
                ),
                SizedBox(
                  width: 10,
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
                          exportToExcel(context);
                        },
                        icon: Icon(Icons.import_export),
                        label: Text("Export"),
                      )
                    : SizedBox(),
              ],
            ),
            SizedBox(
              height: 10,
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
                            label: Text(
                              "No",
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "NAMA CLIENT",
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
                              "Tanggal masuk",
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Kecacatan",
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Nilai raport",
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Layak/Tidak",
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                        rows: [
                          for (int i = 0;
                              i < myListProvider.trainingData.length;
                              i++)
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
                                      myListProvider.trainingData[i][0],
                                      style: TextStyle(fontSize: 15.0),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                      myListProvider.trainingData[i][1],
                                      style: TextStyle(fontSize: 15.0),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                      myListProvider.trainingData[i][2],
                                      style: TextStyle(fontSize: 15.0),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                      myListProvider.trainingData[i][3],
                                      style: TextStyle(fontSize: 15.0),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                      myListProvider.trainingData[i][4],
                                      style: TextStyle(fontSize: 15.0),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
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
}

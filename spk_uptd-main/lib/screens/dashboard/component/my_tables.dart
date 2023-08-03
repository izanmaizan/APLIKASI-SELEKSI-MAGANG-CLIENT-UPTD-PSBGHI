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
    });

    // print(filteredList);
  }

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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 5,
                ),
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
                SizedBox(
                  width: 5,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
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
                          "Nama Klient",
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
                        "Tanggal Lahir",
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
                                filteredList[i]['tanggal_lahir_client'],
                                style: TextStyle(fontSize: 15.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          DataCell(
                            Center(
                              child: Text(
                                filteredList[i]['klasifikasi_kecacatan_client'],
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

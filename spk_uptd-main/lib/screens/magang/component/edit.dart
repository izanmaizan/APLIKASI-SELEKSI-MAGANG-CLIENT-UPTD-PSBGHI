import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spk_uptd/components/constants.dart';
import 'package:spk_uptd/components/genTextFormField.dart';
import 'package:spk_uptd/components/responsive.dart';
import 'package:spk_uptd/controllers/AppControllers.dart';
import 'package:spk_uptd/helpers/dbHelpers.dart';

class EditScreen extends StatefulWidget {
  @override
  State<EditScreen> createState() => _EditScreenState();
}

const List<String> list = <String>['A', 'B', 'C', 'D', 'E'];
const List<String> jenisKelaminlist = <String>['Laki-Laki', 'Perempuan'];
const List<String> jenisKecacatannlist = <String>['Debil', 'Embisil', 'Idiot'];

class _EditScreenState extends State<EditScreen> {
  List<Map<String, dynamic>> dataList = [];
  final dbHelper = DatabaseHelper.instance;
  String nilai_raport = list.first;
  String jenis_kelamin_client = jenisKelaminlist.first;
  String klasifikasi_kecacatan_client = jenisKecacatannlist.first;

  bool loadingS = false;

  TextEditingController nama = TextEditingController();
  TextEditingController umur_client = TextEditingController();
  TextEditingController tanggal_lahir_client = TextEditingController();
  TextEditingController tanggal_masuk_client = TextEditingController();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        tanggal_lahir_client.text =
            "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  Future<void> _selectDateMasuk(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        tanggal_masuk_client.text =
            "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var myListProvider = Provider.of<AppControllers>(context, listen: false);

    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          primary: false,
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      // Tindakan yang ingin Anda lakukan saat ikon kembali diklik
                      myListProvider.setmenuMagang(0);
                    },
                  ),
                  Text("Kembali")
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Text(
                    "Nama",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 163,
                  ),
                  Text(
                    ":",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.5 - 35,
                    child: TextField(
                      controller: nama,
                      // onChanged: filterData,
                      decoration: InputDecoration(
                        hintText: myListProvider.namaEditClient != ""
                            ? myListProvider.namaEditClient
                            : "Nama Client",
                        fillColor: bgColor,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    "Jenis Kelamin",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 101,
                  ),
                  Text(
                    ":",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 13,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: DropdownButton<String>(
                      value: jenis_kelamin_client,
                      // icon: const Icon(Icons.arrow_downward),
                      elevation: 12,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 249, 249, 249)),
                      underline: Container(
                        height: 2,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          jenis_kelamin_client = value!;
                        });
                      },
                      items: jenisKelaminlist
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    "Umur",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 168,
                  ),
                  Text(
                    ":",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.5 - 35,
                    child: TextField(
                      controller: umur_client,
                      // onChanged: filterData,
                      decoration: InputDecoration(
                        hintText: "Umur",
                        fillColor: bgColor,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    "Kecacatan",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 125,
                  ),
                  Text(
                    ":",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 13,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: DropdownButton<String>(
                      value: klasifikasi_kecacatan_client,
                      // icon: const Icon(Icons.arrow_downward),
                      elevation: 12,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 249, 249, 249)),
                      underline: Container(
                        height: 2,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          klasifikasi_kecacatan_client = value!;
                        });
                      },
                      items: jenisKecacatannlist
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    "Tanggal Lahir",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 105,
                  ),
                  Text(
                    ":",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.5 - 35,
                    child: TextFormField(
                      readOnly: true, // Prevents manual input
                      controller: tanggal_lahir_client,
                      onTap: () => _selectDate(context),
                      decoration: InputDecoration(
                        hintText: "Tanggal Lahir",
                        fillColor: bgColor,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    "Tanggal Masuk",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 92,
                  ),
                  Text(
                    ":",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.5 - 35,
                    child: TextFormField(
                      readOnly: true, // Prevents manual input
                      controller: tanggal_masuk_client,
                      onTap: () => _selectDateMasuk(context),
                      decoration: InputDecoration(
                        hintText: "Tanggal Masuk",
                        fillColor: bgColor,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Nilai Raport",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 88,
                  ),
                  Text(
                    ":",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: DropdownButton<String>(
                      value: nilai_raport,
                      // icon: const Icon(Icons.arrow_downward),
                      elevation: 12,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 249, 249, 249)),
                      underline: Container(
                        height: 2,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          nilai_raport = value!;
                        });
                      },
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              loadingS
                  ? Container(
                      child: CircularProgressIndicator(),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                              setState(() {
                                loadingS = true;
                              });
                              simpanData();
                            },
                            icon: Icon(Icons.save_as_outlined),
                            label: Text("SIMPAN"),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void simpanData() async {
    var myListProvider = Provider.of<AppControllers>(context, listen: false);
    if (nama.text.isNotEmpty) {
      final data = {
        'nama_client': nama.text,
        'jenis_kelamin_client': jenis_kelamin_client,
        'umur_client': umur_client.text,
        'klasifikasi_kecacatan_client': klasifikasi_kecacatan_client,
        'tanggal_lahir_client': tanggal_lahir_client.text,
        'tanggal_masuk_client': tanggal_masuk_client.text,
        'nilai_raport': nilai_raport,
      };
      final id =
          await dbHelper.updateDataClient(data, myListProvider.editClient);
      // myListProvider.setShowDialog('User Sudah Dibuat');

      // print('Data inserted with id: $id');
    } else {
      final data = {
        'nama_client': myListProvider.namaEditClient,
        'jenis_kelamin_client': jenis_kelamin_client,
        'umur_client': umur_client.text,
        'klasifikasi_kecacatan_client': klasifikasi_kecacatan_client,
        'tanggal_lahir_client': tanggal_lahir_client.text,
        'tanggal_masuk_client': tanggal_masuk_client.text,
        'nilai_raport': nilai_raport,
      };
      final id =
          await dbHelper.updateDataClient(data, myListProvider.editClient);
    }
    myListProvider.setShowDialog('Data Sudah Diupdate');
    Timer(Duration(seconds: 2), () {
      myListProvider.setShowDialog("");
    });
    setState(() {
      loadingS = false;
    });
  }
}

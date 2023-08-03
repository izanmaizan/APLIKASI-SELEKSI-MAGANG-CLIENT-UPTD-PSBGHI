import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spk_uptd/components/constants.dart';
import 'package:spk_uptd/controllers/AppControllers.dart';

class ProfilScreen extends StatelessWidget {
  List<String> gambarList = [
    'assets/images/gambar_1.jpg',
    'assets/images/gambar_2.jpg',
    'assets/images/gambar_3.jpg',
    'assets/images/gambar_5.jpg',
    'assets/images/gambar_6.jpg',
    'assets/images/gambar_7.jpg',
    'assets/images/gambar_8.jpg',
    'assets/images/gambar_9.jpg',
    'assets/images/gambar_10.jpg',
    // ... daftar gambar lainnya
  ];
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
              Container(
                width: MediaQuery.of(context).size.width / 1,
                height: MediaQuery.of(context).size.height / 1.1,
                color: secondaryColor,
                child: Column(
                  children: [
                    Text("MY PROFIL"),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

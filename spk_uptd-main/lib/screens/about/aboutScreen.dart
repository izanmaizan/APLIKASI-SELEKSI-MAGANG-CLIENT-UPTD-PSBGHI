import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spk_uptd/components/constants.dart';
import 'package:spk_uptd/controllers/AppControllers.dart';

class AboutScreen extends StatelessWidget {
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
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(defaultPadding),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Image.asset(
                            'assets/images/psbghi.jpg',
                            width: 300,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: [
                            Text(
                              "UPTD PSBGHI",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                                "Panti Sosial Bina Grahita (PSBG) Harapan Ibu Padang adalah Unit Pelaksana Tekhnis Dinas (UPTD) \ndan bertanggung jawab langsung kepada Dinas Sosial Provinsi Sumatera Barat \ndalam melaksanakan pelayanan dan rehabilitasi sosial kepada penyandang cacat mental. \nUPTD PSBGHI ini berlokasi di jl. Wisma Bunda kalumbuk kecamatan kuranji Padang. \nPanti ini memulai operasionalnya sejak 26 November 1981."),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: gambarList.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          child: Image.asset(
                                            gambarList[index],
                                            fit: BoxFit.contain,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 10),
                                    width: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: AssetImage(gambarList[index]),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          "VISI",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "MISI",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 100,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Terwujudnya kesejahteraan kelayan dan mandiri \ndalam masyarakat melalui pelayanan prima \ndalam UPTD  Panti Sosial Bina Grahita \ndengan mendorong peran serta dan \npemberdayaan masyarakat serta \nkesetiakawanan social",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          "1.	Meningkatkan kemampuan potensi penerima pelayanan.\n2.	Meningkatkan kesadaran hidup berkeluarga \ndan bermasyarakat yang harmonis.\n3.	Memperkuat lembaga dan memperluas \njaringan lembaga/ instatnsi terkait.\n4.	Mengoptimalkan potensi dari sumber kemasyrakatan.",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Row(
                    //   children: [
                    //     SizedBox(
                    //       width: 150,
                    //     ),
                    //   ],
                    // ),
                    // Row(
                    //   children: [
                    //     SizedBox(
                    //       width: 10,
                    //     ),

                    //   ],
                    // )
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

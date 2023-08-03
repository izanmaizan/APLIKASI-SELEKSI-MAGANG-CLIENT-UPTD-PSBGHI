import 'package:flutter/material.dart';
import 'package:spk_uptd/components/constants.dart';

class CloudStorageInfo {
  final String? svgSrc, title, totalStorage;
  final int? numOfFiles, percentage;
  final Color? color;

  CloudStorageInfo({
    this.svgSrc,
    this.title,
    this.totalStorage,
    this.numOfFiles,
    this.percentage,
    this.color,
  });
}

List demoMyFiles = [
  CloudStorageInfo(
    title: "Client",
    numOfFiles: 1328,
    svgSrc: "assets/icons/drop_box.svg",
    totalStorage: "1328",
    color: primaryColor,
    percentage: 35,
  ),
  CloudStorageInfo(
    title: "Layak",
    numOfFiles: 1328,
    svgSrc: "assets/icons/drop_box.svg",
    totalStorage: "1000",
    color: Color(0xFFFFA113),
    percentage: 35,
  ),
  CloudStorageInfo(
    title: "Tidak Layak",
    numOfFiles: 1328,
    svgSrc: "assets/icons/drop_box.svg",
    totalStorage: "328",
    color: Color(0xFFA4CDFF),
    percentage: 10,
  ),
  // CloudStorageInfo(
  //   title: "Tersisa",
  //   numOfFiles: 5328,
  //   svgSrc: "assets/icons/drop_box.svg",
  //   totalStorage: "7.3GB",
  //   color: Color(0xFF007EE5),
  //   percentage: 78,
  // ),
];

List KlientMagang = [
  CloudStorageInfo(
    title: "Client",
    numOfFiles: 1328,
    svgSrc: "assets/icons/drop_box.svg",
    totalStorage: "1328",
    color: primaryColor,
    percentage: 35,
  ),
];

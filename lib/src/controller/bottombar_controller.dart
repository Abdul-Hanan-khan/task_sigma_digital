import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomBarController extends GetxController {
  RxInt pageIndex = 0.obs;
  List icons = [
    "assets/icons/icon_watch.svg", "assets/icons/icon_watch.svg"
  ];
  List bottomBartItems=["Upcoming","Popular"];

  onTap(index) {
    pageIndex.value = index;
  }

}
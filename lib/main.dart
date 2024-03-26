import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:movie_app_task/src/controller/bottombar_controller.dart';

import 'package:get/get.dart';
import 'package:movie_app_task/src/view/bottomBar/bottombar_screen.dart';

import 'src/controller/movie_controller.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bottomController = Get.put(BottomBarController());
    var movieDetailsController = Get.put(MovieController());

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (BuildContext context, Widget? child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: BottomBarScreen(),
        );
      },
    );
  }
}

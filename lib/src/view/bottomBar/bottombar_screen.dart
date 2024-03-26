import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:movie_app_task/src/controller/movie_controller.dart';
import 'package:movie_app_task/src/view/custom_widgets/custom_text.dart';
import 'package:movie_app_task/src/view/home/dashboard/popular_movies.dart';
import 'package:movie_app_task/src/view/home/dashboard/up_coming_movies.dart';

import '../../core/app_colors.dart';

import '../../controller/bottombar_controller.dart';

class BottomBarScreen extends StatefulWidget {
  BottomBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {

  final BottomBarController _con = Get.find();
  MovieController movieController = Get.find();

  int count = 0;

  // sdf
  @override
  Widget build(BuildContext context) {

    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        // key: _con.scaffoldKey,
        body: _con.pageIndex.value == 0
            ? UpComingMovies() : PopularMovies(),


        bottomNavigationBar: bottombar(),
      ),
    );
  }

  bottombar() {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppColors.bottomBarColor,
        borderRadius: const BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30)),
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            _con.icons.length,
            (index) => GestureDetector(
              onTap:(){
                _con.onTap(index);
                if(_con.pageIndex.value ==0){
                  movieController.loadUpComingMovies();
                }else if (_con.pageIndex.value ==1){
                  movieController.loadPopularMovies();
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    _con.icons[index],
                    color: _con.pageIndex.value == index
                        ? AppColors.bottomBarIconColorSelected
                        : AppColors.bottomBarIconColorUnSelected,
                    height: 20.sp,
                    width: 20.sp,
                  ),
                  SizedBox(height: 7.h,),
                  CustomText(text: _con.bottomBartItems[index],fontSize: 12.sp,textColor: _con.pageIndex.value == index
                      ? AppColors.bottomBarIconColorSelected
                      : AppColors.bottomBarIconColorUnSelected,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

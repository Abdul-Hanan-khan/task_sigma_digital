import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:movie_app_task/src/controller/movie_controller.dart';
import 'package:movie_app_task/src/core/app_colors.dart';
import 'package:movie_app_task/src/core/app_strings.dart';
import 'package:movie_app_task/src/view/booking/date_and_hall_selection_screen.dart';
import 'package:movie_app_task/src/view/custom_widgets/custom_button.dart';
import 'package:movie_app_task/src/view/custom_widgets/custom_text.dart';
import 'package:movie_app_task/src/view/video_player_screen.dart';

class MovieDetailScreen extends StatelessWidget {
  MovieController controller = Get.find();

  MovieDetailScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(child: _buildDetailBody(context)),
        ),
      ),
      onWillPop: () async => onWillPop(),
    );
  }

  onWillPop(){
    if(controller.playTrailer.value ){
      // controller.trailerKey ="";
      controller.playTrailer.value = false;
    }else{
      Get.back();
    }


  }

  Widget _buildDetailBody(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? Padding(
            padding:  EdgeInsets.only(top: Get.height * 0.3),
            child: const Center(
                child: CupertinoActivityIndicator(),
              ),
          )
          : Column(
              children: [
                Stack(
                  children: <Widget>[
                    controller.playTrailer.value
                        ? Container(
                        height:controller.playerController.value.isFullScreen?Get.height: Get.height* 0.36,
                        width: Get.width,
                        child: BasicPlayerPage())
                        : ClipPath(

                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                              child: CachedNetworkImage(
                                imageUrl:
                                    'https://image.tmdb.org/t/p/original/${controller.movieDetails.value.backdropPath}',
                                height: Get.height * 0.5,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: CupertinoActivityIndicator(),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/img_not_found.jpg'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    controller.playTrailer.value?Container(): Positioned(
                      bottom: 0.5.h,
                      child: Container(
                        height: 250.h,
                        width: Get.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30.r),
                              bottomRight: Radius.circular(30.r)),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.black.withOpacity(0.8)
                            ], // Adjust the colors as needed
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 70.h,
                      child: controller.isLoading.value
                          ? Container()
                          : Container(
                        width: Get.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Column(
                                  children: [
                                    controller.playTrailer.value
                                        ? Container()
                                        : Center(
                                            child: CustomButton(
                                              buttonText: AppStrings.getTicket,
                                              buttonColor: AppColors.buttonColor,
                                              buttonTextSize: 15.sp,
                                              width: Get.width * 0.65,
                                              buttonTextColor: AppColors.white,
                                              onTap: () {
                                                Get.to(DataAndHallSelectionScreen(controller.movieDetails.value.originalTitle!,controller.movieDetails.value.releaseDate!));
                                                // controller.playTrailer.value = true;
                                              },
                                            ),
                                          ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    controller. playTrailer.value
                                        ? Container()
                                        : controller.loadingTrailer.value?const Center(child: CircularProgressIndicator(),) :InkWell(
                                            onTap: () {
                                              controller.playTrailer.value = true;
                                            },
                                            child: Container(
                                              width: Get.width * 0.65,
                                              height: 50.h,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(7.r),
                                                border: Border.all(
                                                    color: AppColors.buttonColor),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    // width: Get.width * 0.25,
                                                    child: Icon(
                                                      Icons.play_arrow,
                                                      color: AppColors.white,
                                                    ),
                                                  ),
                                                  CustomText(
                                                    text: AppStrings.watchTrailer,
                                                    textColor: AppColors.white,
                                                    fontFamily: AppStrings
                                                        .poppinsSemiBold,
                                                    fontSize: 15.sp,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                    ),

                    controller.playerController.value.isFullScreen? Container(): Positioned(
                        left: 10.w,
                        top: 10.h,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(onPressed: (){
                          onWillPop();
                        }, icon: Icon(Icons.arrow_back_ios_new_outlined,color: AppColors.grey,size: 23.sp)),
                        CustomText(text: AppStrings.watch,textColor: AppColors.grey,fontSize: 20.sp,)
                      ],
                    ))
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                CustomText(
                                  text: AppStrings.genre,
                                  fontFamily: AppStrings.poppinsSemiBold,
                                  fontSize: 18,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          controller
                              .movieDetails.value.genres == null?Container():     Container(
                            height: 50.h,
                            // width: Get.width,
                            child: ListView.builder(
                                itemCount: controller
                                    .movieDetails.value.genres!.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  Color randomColor = getRandomColor();

                                  return Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8.sp),
                                        decoration: BoxDecoration(
                                          color: randomColor,
                                          borderRadius:
                                              BorderRadius.circular(20.r),
                                        ),
                                        child: CustomText(
                                          text: controller.movieDetails.value
                                              .genres![index].name!,
                                          textColor:
                                              randomColor.computeLuminance() >
                                                      0.5
                                                  ? AppColors.black
                                                  : AppColors.white,
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      )
                                    ],
                                  );
                                }),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                CustomText(
                                  text: AppStrings.overView,
                                  fontFamily: AppStrings.poppinsSemiBold,
                                  fontSize: 18,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          CustomText(
                            text: controller.movieDetails.value.overview!,
                            fontSize: 17.sp,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Color getRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
}

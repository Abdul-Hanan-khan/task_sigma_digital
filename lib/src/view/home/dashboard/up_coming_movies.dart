import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app_task/main.dart';
import 'package:movie_app_task/src/controller/movie_controller.dart';
import 'package:movie_app_task/src/core/app_colors.dart';
import 'package:movie_app_task/src/core/app_strings.dart';
import 'package:movie_app_task/src/model/movies_model.dart';
import 'package:movie_app_task/src/view/custom_widgets/custom_text.dart';
import 'package:movie_app_task/src/view/movie_detail_screen.dart';
import 'package:get/get.dart';
import 'package:movie_app_task/src/view/search_screen.dart';

class UpComingMovies extends StatelessWidget {
  MovieController movieDetailsController = Get.find();
  RxBool isSelectable = false.obs;
  List<String> selectedMovieIds = [];

  onWillPopUp() {
    isSelectable.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPopUp(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: CustomText(
              text: AppStrings.upComing,
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Get.to(SearchScreen());
                },
                icon: Icon(Icons.search),
                color: AppColors.black,
              )
            ],
          ),
          body: SingleChildScrollView(child: _buildBody(context)),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Obx(() => movieDetailsController.loadingUpcomingMovies.value
        ? Padding(
          padding: EdgeInsets.only(top: Get.height * 0.3),
          child: const Center(
              child: CircularProgressIndicator(),
            ),
        )
        : Container(
      color: AppColors.scaffoldBackgroundColor,
          child: ListView.builder(
            itemCount: movieDetailsController.upCommingMovies.value.results!.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              Results movie =
              movieDetailsController.upCommingMovies.value.results![index];

              return InkWell(
                onTap: (){
                  movieDetailsController.getDetails(movieId: movie.id!);
                  Get.to(MovieDetailScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: <Widget>[


                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.r),
                          ),

                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.r),
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://image.tmdb.org/t/p/original/${movie.backdropPath}',
                            height: MediaQuery.of(context).size.height / 3,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>  const Center(
                                    child: CupertinoActivityIndicator()),
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
                      Positioned(
                        bottom: 0,
                        child: Container(
                          height: 100.h,
                          width: Get.width*0.95,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.r),bottomRight: Radius.circular(20.r)),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, AppColors.black.withOpacity(0.7)], // Adjust the colors as needed
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                            bottom: 15.h,
                            left: 15.h,
                          ),
                          child: CustomText(
                            text: movie.title!,
                            fontSize: 16.sp,
                            fontFamily: AppStrings.poppinsBold,
                            textColor: AppColors.white,
                          )),

                    ],
                  ),
                ),
              );
            },
            // separatorBuilder: (BuildContext context, int index) { return SizedBox(height: 10.h,);},
          ),
        ));
  }
}

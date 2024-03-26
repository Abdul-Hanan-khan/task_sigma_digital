

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:movie_app_task/main.dart';
import 'package:movie_app_task/src/controller/movie_controller.dart';
import 'package:movie_app_task/src/controller/search_controller.dart';

import 'package:movie_app_task/src/core/app_colors.dart';
import 'package:movie_app_task/src/core/app_strings.dart';
import 'package:movie_app_task/src/model/movies_model.dart';
import 'package:movie_app_task/src/view/custom_widgets/custom_text.dart';
import 'package:movie_app_task/src/view/movie_detail_screen.dart';


class SearchScreen extends StatelessWidget {
  TextEditingController search = TextEditingController();
  var movieDetailsController=Get.put(MovieController());
  SearchProductController controller = SearchProductController();

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => SafeArea(
            child: Scaffold(

            body: Column(
              children: [
                SizedBox(height: 20.h,),
                Container(width: Get.width*0.9,height: 50.h,decoration: BoxDecoration(
                  color: AppColors.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                     Icon(
                      Icons.search,
                      color: AppColors.black,
                       size: 30.sp,
                    ),
                    Container(
                      width: Get.width * 0.6,
                      child: TextField(
                        controller: controller.searchFieldController,
                        decoration:  InputDecoration(
                          border: InputBorder.none,
                          hintText: AppStrings.tvShowsMoviesNMore,
                          hintStyle: TextStyle(color: AppColors.grey)
                        ),
                        onChanged: (value) {
                          if (value.length == 0){
                            controller.clearSearches();
                            controller.showGrid.value = true;
                          }
                          else{

                            controller.loadSearchProduct(value);
                            controller.showGrid.value = false;
                          }
                        },
                      ),
                    ),

                    IconButton(
                      icon:  Icon(
                        Icons.close,
                        color: Colors.grey,
                       size: 30.sp
                      ),
                      onPressed: () {
                        Get.back();
                      },
                      color: Colors.black,
                    ),
                  ],
                ),
                ),
                SizedBox(height: 20.h,),
                controller.searchProcessing.value?const Center(child: CircularProgressIndicator(),): Container(
                  color: AppColors.scaffoldBackgroundColor,
                  child: controller.searchFieldController.text.trim().length <1 || controller.showGrid.value
                      ? itemsGrid()
                      : searchedItemsList(),
                ),

              ],
            )
      ),
          ),
    );
  }

  Widget itemsGrid() {
    return Obx(
          () => Container(
            height: Get.height - 125.h,
            padding: EdgeInsets.only(top: 10.h),
            child: GridView.builder(
              shrinkWrap: true,

              // physics: NeverScrollableScrollPhysics(),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2/1.35
              ),
              itemCount: movieDetailsController.upCommingMovies.value.results!.length,
              itemBuilder: (context, index) {
                Results movie =  movieDetailsController.upCommingMovies.value.results![index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: (){
                          // print(movie.id);
                          movieDetailsController.getDetails(movieId: movie.id!);
                          Get.to(MovieDetailScreen());
                        },
                          child: CachedNetworkImage(
                            imageUrl:
                            'https://image.tmdb.org/t/p/w200${movieDetailsController.upCommingMovies.value.results![index].backdropPath}',
                            imageBuilder:
                                (context, imageProvider) {
                              return Container(
                                width: 170.w,
                                height: 120.h,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(
                                    Radius.circular(20.r),
                                  ),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                            placeholder: (context, url) =>
                                Container(
                                  width: 80,
                                  height: 80,
                                  child: const Center(
                                    child:  CupertinoActivityIndicator(),
                                  ),
                                ),
                            errorWidget:
                                (context, url, error) =>
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/img_not_found.jpg'),
                                    ),
                                  ),
                                ),
                          ),
                        ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          height: 30.h,
                          width: Get.width * 0.4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.r),bottomRight: Radius.circular(20.r)),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, AppColors.black.withOpacity(0.5)], // Adjust the colors as needed
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          left: 10.w,
                          bottom: 10.h,
                          child: CustomText(text: movie.title!,textColor: AppColors.white,fontSize: 13.sp,fontFamily: AppStrings.poppinsSemiBold,))
                    ],
                  ),
                );
              },
            ),
          ),
    );
  }

  Widget searchedItemsList() {
    return Obx(
          () => Container(
            height: Get.height - 125.h,
            padding: EdgeInsets.only(top: 10.h),
           child: ListView.builder(
               itemCount: controller.searchList.length,
               itemBuilder: (context,index){
             Results movie = controller.searchList.value[index];
             return ListTile(
               leading:  GestureDetector(
                 onTap: (){
                   // print(movie.id);
                   movieDetailsController.getDetails(movieId: movie.id!);
                   Get.to(MovieDetailScreen());
                 },
                 child: CachedNetworkImage(
                   imageUrl:
                   'https://image.tmdb.org/t/p/w200${controller.searchList.value![index].backdropPath}',
                   imageBuilder:
                       (context, imageProvider) {
                     return Container(
                       width: 150.w,
                       height: 140.w,
                       decoration: BoxDecoration(
                         borderRadius:
                         BorderRadius.all(
                           Radius.circular(10.r),
                         ),
                         image: DecorationImage(
                           image: imageProvider,
                           fit: BoxFit.cover,
                         ),
                       ),
                     );
                   },
                   placeholder: (context, url) =>
                       Container(
                         width: 80,
                         height: 80,
                         child: const Center(
                           child:  CupertinoActivityIndicator(),
                         ),
                       ),
                   errorWidget:
                       (context, url, error) =>
                       Container(
                         width: 80,
                         height: 80,
                         decoration: const BoxDecoration(
                           image: DecorationImage(
                             image: AssetImage(
                                 'assets/images/img_not_found.jpg'),
                           ),
                         ),
                       ),
                 ),
               ),
               title: CustomText(text: movie.title!,fontFamily: AppStrings.poppinsBold,fontSize: 18.sp,),
               subtitle: CustomText(text: movie.releaseDate!,fontFamily: AppStrings.poppinsRegular,fontSize: 15.sp,),

             );
           }),
          ),
    );
  }
}
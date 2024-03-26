import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:movie_app_task/main.dart';
import 'package:movie_app_task/src/controller/movie_controller.dart';
import 'package:movie_app_task/src/core/app_colors.dart';
import 'package:movie_app_task/src/core/app_strings.dart';
import 'package:movie_app_task/src/model/seating_plan_model.dart';
import 'package:movie_app_task/src/view/custom_widgets/custom_button.dart';
import 'package:movie_app_task/src/view/custom_widgets/custom_text.dart';

class HallDetailsScreen extends StatelessWidget {
  String movieName;
  String releaseDate;

  HallDetailsScreen({required this.movieName, required this.releaseDate});

  MovieController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          topSection(),
          SizedBox(
            height: 20.h,
          ),
          Obx(() => controller.fetchingSeatInfoProcessing.value
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: Get.height * 0.2),
                    child: CircularProgressIndicator(),
                  ),
                )
              : Column(
                  children: [
                    seatingSection(),
                    seatInfoSection(),
                    SizedBox(
                      height: 50.h,
                    ),
                  ],
                )),
          bottomSection()
        ],
      ),
    ));
  }

  Widget topSection() {
    return Container(
      padding: EdgeInsets.all(15.sp),
      width: Get.width,
      height: 100.h,
      color: AppColors.white,
      child: Row(
        children: [
          Container(
            width: Get.width * 0.08,
            child: Center(
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_outlined),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
          ),
          Container(
            width: Get.width * 0.83,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: movieName,
                  fontSize: 19.sp,
                ),
                CustomText(
                  text: "${AppStrings.inTheaters} $releaseDate",
                  fontSize: 19.sp,
                  textColor: AppColors.buttonColor,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget seatingSection() {
    final double _minScale = 0.5;
    final TransformationController _transformationController =
        TransformationController();
    return Column(
      children: [
        Stack(
          alignment:  AlignmentDirectional.topCenter,
          children: [
            SizedBox(
              width: Get.width * 0.85,
              child: SvgPicture.asset(
                "assets/icons/screen_icon.svg",
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
                top: 4.h,
                child: CustomText(text: AppStrings.screen,fontSize: 12,textColor: Colors.green,))
          ],
        ),
        InteractiveViewer(
          transformationController: _transformationController,
          child: Container(
            width: Get.width * 0.85,
            height: Get.height * 0.35,
            // color: Colors.orange,
            // width: Get.width,
            child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.seatingPlanList.length,
                itemBuilder: (context, index) {
                  return itemSeatingSection(controller.seatingPlanList[index]);
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 10.h,
                  );
                }),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
                padding: EdgeInsets.all(3.sp),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white,
                    border: Border.all(color: AppColors.grey.withOpacity(0.2))),
                child: InkWell(
                    onTap: () {
                      final scale =
                          _transformationController.value.getMaxScaleOnAxis();
                      if (scale / 1.5 > _minScale) {
                        _transformationController.value *=
                            Matrix4.diagonal3Values(1.1, 1.1, 1);
                      }
                    },
                    child: Icon(Icons.add))),
            SizedBox(width: 5.w,),
            InkWell(
              onTap: () {
                final scale = _transformationController.value.getMaxScaleOnAxis();
                if(scale>1.0){
                  _transformationController.value *= Matrix4.diagonal3Values(0.9, 0.9, 1);
                }
              },
              child: Container(
                padding: EdgeInsets.all(3.sp),
                  decoration: BoxDecoration(shape: BoxShape.circle,
                    color: AppColors.white,
                    border:Border.all(color: AppColors.grey.withOpacity(0.2))
                  ),
                  child: Icon(Icons.remove)),
            ),
            SizedBox(width: 25.w,),

          ],
        ),
        // SizedBox(height: 20.h,),
      ],
    );
  }

  Widget seatInfoSection() {
    return Container(
      padding: EdgeInsets.all(15.sp),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  seatCategoryInfo(
                      color: AppColors.selectedSeatColor,
                      categoryName: "Selected"),
                  SizedBox(
                    height: 10.h,
                  ),
                  seatCategoryInfo(
                      color: AppColors.vipSeatColor, categoryName: "VIP")
                ],
              ),
              SizedBox(
                width: 25.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  seatCategoryInfo(
                      color: AppColors.grey, categoryName: "Not Available"),
                  SizedBox(
                    height: 10.h,
                  ),
                  seatCategoryInfo(
                      color: AppColors.regularSeatColor,
                      categoryName: "Regular")
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget bottomSection() {
    return Container(
      width: Get.width,
      padding: EdgeInsets.only(left: 15.w),
      child: Row(
        children: [
          Container(
            height: 50.h,
            width: Get.width * 0.25,
            decoration: BoxDecoration(
              color: AppColors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: AppStrings.totalPrice,
                    fontSize: 17.sp,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Obx(() => CustomText(
                        text: "\$ ${controller.selectedSeatPrice.value}",
                        fontSize: 17.sp,
                        fontFamily: AppStrings.poppinsSemiBold,
                      )),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 5.w,
          ),
          CustomButton(
            width: Get.width * 0.65,
            height: 50.h,
            borderRadius: 15.r,
            buttonText: AppStrings.proceedToPay,
            buttonTextColor: AppColors.white,
          )
        ],
      ),
    );
  }

  Widget itemSeatingSection(SeatingPlanModel seatingDetails) {
    return Container(
      // color: Colors.orange,
      height: 15.h,
      // width: Get.width,
      child: Center(
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: seatingDetails.rows!.length,
          itemBuilder: (context, index) {
            return Builder(builder: (context) {
              Widget widget = Container();
              switch (seatingDetails.rows![index].seatingPlan) {
                case "s1":
                  widget = s1SeatingPlan(
                      index: index, seatInfo: seatingDetails.rows![index]);
                  break;
                case "s2":
                  widget = s2SeatingPlan(
                      index: index, seatInfo: seatingDetails.rows![index]);
                  break;
                case "s3":
                  widget = s3SeatingPlan(
                      index: index, seatInfo: seatingDetails.rows![index]);
                  break;
                default:
                  widget = Container();
                  break;
              }

              return widget;
            });
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              width: 2.w,
            );
          },
        ),
      ),
    );
  }

  Widget s1SeatingPlan({required int index, required Rows seatInfo}) {
    if (index == 2 || index == 16) {
      return Obx(
        () => GestureDetector(
          onTap: () {
            controller.selectedSeatNumber.value = seatInfo.seatNumber!;
            controller.selectedSeatPrice.value = seatInfo.price!;
          },
          child: Padding(
            padding: EdgeInsets.only(left: 10.sp),
            child: SizedBox(
              child: SvgPicture.asset(
                "assets/icons/icon_seat.svg",
                fit: BoxFit.fill,
                color:
                    controller.selectedSeatNumber.value == seatInfo.seatNumber
                        ? AppColors.selectedSeatColor
                        : seatInfo.category == "Regular"
                            ? AppColors.regularSeatColor
                            : seatInfo.category == "Vip"
                                ? AppColors.vipSeatColor
                                : AppColors.grey,
              ),
            ),
          ),
        ),
      );
    } else {
      return Obx(
        () => GestureDetector(
          onTap: () {
            controller.selectedSeatNumber.value = seatInfo.seatNumber!;
            controller.selectedSeatPrice.value = seatInfo.price!;
          },
          child: SvgPicture.asset(
            "assets/icons/icon_seat.svg",
            fit: BoxFit.fill,
            color: controller.selectedSeatNumber.value == seatInfo.seatNumber
                ? AppColors.selectedSeatColor
                : seatInfo.category == "Regular"
                    ? AppColors.regularSeatColor
                    : seatInfo.category == "Vip"
                        ? AppColors.vipSeatColor
                        : AppColors.grey,
          ),
        ),
      );
    }
  }

  Widget s2SeatingPlan({required int index, required Rows seatInfo}) {
    if (index == 4 || index == 18) {
      return Obx(
        () => Padding(
          padding: EdgeInsets.only(left: 10.sp),
          child: GestureDetector(
            onTap: () {
              controller.selectedSeatNumber.value = seatInfo.seatNumber!;
              controller.selectedSeatPrice.value = seatInfo.price!;
            },
            child: SvgPicture.asset(
              "assets/icons/icon_seat.svg",
              fit: BoxFit.fill,
              color: controller.selectedSeatNumber.value == seatInfo.seatNumber
                  ? AppColors.selectedSeatColor
                  : seatInfo.category == "Regular"
                      ? AppColors.regularSeatColor
                      : seatInfo.category == "Vip"
                          ? AppColors.vipSeatColor
                          : AppColors.grey,
            ),
          ),
        ),
      );
    } else {
      return Obx(
        () => GestureDetector(
          onTap: () {
            controller.selectedSeatNumber.value = seatInfo.seatNumber!;
            controller.selectedSeatPrice.value = seatInfo.price!;
          },
          child: SvgPicture.asset(
            "assets/icons/icon_seat.svg",
            fit: BoxFit.fill,
            color: controller.selectedSeatNumber.value == seatInfo.seatNumber
                ? AppColors.selectedSeatColor
                : seatInfo.category == "Regular"
                    ? AppColors.regularSeatColor
                    : seatInfo.category == "Vip"
                        ? AppColors.vipSeatColor
                        : AppColors.grey,
          ),
        ),
      );
    }
  }

  Widget s3SeatingPlan({required int index, required Rows seatInfo}) {
    if (index == 5 || index == 19) {
      return Obx(
        () => Padding(
          padding: EdgeInsets.only(left: 10.sp),
          child: GestureDetector(
            onTap: () {
              controller.selectedSeatNumber.value = seatInfo.seatNumber!;
              controller.selectedSeatPrice.value = seatInfo.price!;
            },
            child: SvgPicture.asset(
              "assets/icons/icon_seat.svg",
              fit: BoxFit.fill,
              color: controller.selectedSeatNumber.value == seatInfo.seatNumber
                  ? AppColors.selectedSeatColor
                  : seatInfo.category == "Regular"
                      ? AppColors.regularSeatColor
                      : seatInfo.category == "Vip"
                          ? AppColors.vipSeatColor
                          : AppColors.grey,
            ),
          ),
        ),
      );
    } else {
      return Obx(
        () => GestureDetector(
          onTap: () {
            controller.selectedSeatNumber.value = seatInfo.seatNumber!;
            controller.selectedSeatPrice.value = seatInfo.price!;
          },
          child: SvgPicture.asset(
            "assets/icons/icon_seat.svg",
            fit: BoxFit.fill,
            color: controller.selectedSeatNumber.value == seatInfo.seatNumber
                ? AppColors.selectedSeatColor
                : seatInfo.category == "Regular"
                    ? AppColors.regularSeatColor
                    : seatInfo.category == "Vip"
                        ? AppColors.vipSeatColor
                        : AppColors.grey,
          ),
        ),
      );
    }
  }

  Widget seatCategoryInfo(
      {required Color color, required String categoryName}) {
    return Row(
      children: [
        SizedBox(
          width: 25.sp,
          height: 25.sp,
          child: SvgPicture.asset("assets/icons/icon_seat.svg",
              fit: BoxFit.fill, color: color),
        ),
        SizedBox(
          width: 15.w,
        ),
        CustomText(
          text: categoryName,
          textColor: AppColors.grey,
          fontSize: 20.sp,
        )
      ],
    );
  }
}

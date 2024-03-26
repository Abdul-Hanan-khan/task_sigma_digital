import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:movie_app_task/src/controller/movie_controller.dart';
import 'package:movie_app_task/src/core/app_colors.dart';
import 'package:movie_app_task/src/model/available_hall_model.dart';
import 'package:movie_app_task/src/view/booking/hall_details_screen.dart';
import 'package:movie_app_task/src/view/custom_widgets/custom_button.dart';
import 'package:movie_app_task/src/view/custom_widgets/custom_text.dart';

import '../../core/app_strings.dart';

class DataAndHallSelectionScreen extends StatelessWidget {
  String movieName;
  String releaseDate;

  DataAndHallSelectionScreen(this.movieName, this.releaseDate, {super.key});

  MovieController controller = Get.find();
  String formattedDate = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [topSection(), hallSection(), proceedToPay()],
        ),

    ));
  }

  Widget topSection() {
    DateTime date = DateTime.parse(releaseDate);

    formattedDate = DateFormat('MMMM dd, yyyy').format(date);
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
                  text: "${AppStrings.inTheaters} $formattedDate",
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

  Widget hallSection() {
    return Container(
      // color: Colors.orange,
      padding: EdgeInsets.all(20.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: Get.width,
          ),
          CustomText(text: AppStrings.date),
          SizedBox(
            height: 10.h,
          ),
          Container(
            height: 50.h,
            width: Get.width,
            child: ListView.builder(
              itemCount: controller.moviesDates.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Obx(
                  () => GestureDetector(
                    onTap: () {
                      controller.selectedDateIndex.value = index;
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10.h, horizontal: 7),
                      width: 80.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: controller.selectedDateIndex.value == index
                            ? AppColors.buttonColor
                            : AppColors.grey.withOpacity(0.3),
                        boxShadow: [
                          BoxShadow(
                            color: controller.selectedDateIndex.value == index
                                ? Colors.grey.withOpacity(0.3)
                                : Colors.transparent,
                            spreadRadius: 3,
                            blurRadius: 2,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: CustomText(
                          text: controller.moviesDates[index],
                          fontSize: 18.sp,
                          textColor: controller.selectedDateIndex.value == index
                              ? AppColors.white
                              : AppColors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            height: Get.height * 0.4,
            width: Get.width,
            child: ListView.separated(
              itemCount: controller.availableHall.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return hallItem(controller.availableHall[index], index);
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width: 15.w,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget proceedToPay() {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: CustomButton(
        buttonText: AppStrings.proceedToPay,
        buttonColor: AppColors.buttonColor,
        buttonTextColor: AppColors.white,
        width: Get.width * 0.8,
        borderRadius: 15.r,
        onTap: () async {
          controller.fetchingSeatInfoProcessing.value = true;
          Get.to(HallDetailsScreen(
            movieName: movieName,
            releaseDate: formattedDate,
          ));
          controller.seatingPlanList = await controller.loadSearingInfo();
          controller.generateSeatNumbers();

          // print(controller.seatingPlanList);

        },
      ),
    );
  }

  Widget hallItem(AvailableHall hall, int index) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20.h,
          ),
          Row(
            children: [
              CustomText(
                text: hall.timings!,
                textColor: AppColors.black,
                fontSize: 18.sp,
                fontFamily: AppStrings.poppinsSemiBold,
              ),
              SizedBox(
                width: 10.w,
              ),
              CustomText(
                text: hall.hallName!,
                textColor: AppColors.grey,
                fontSize: 18.sp,
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Obx(
            () => GestureDetector(
              onTap: () {
                controller.selectedHallIndex.value = index;
              },
              child: Container(
                padding: EdgeInsets.all(25.sp),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                        color: controller.selectedHallIndex.value == index
                            ? AppColors.buttonColor
                            : AppColors.grey.withOpacity(0.3))),
                child: SvgPicture.asset(
                  hall.image!,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h,),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: AppStrings.from+" "),
                TextSpan(
                  text: '\$${hall.rate} ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: AppStrings.or),
                TextSpan(
                  text: ' ${hall.bonus} bonus',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

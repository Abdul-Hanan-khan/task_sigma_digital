import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:movie_app_task/src/controller/bottombar_controller.dart';
import 'package:movie_app_task/src/model/available_hall_model.dart';
import 'package:movie_app_task/src/model/movie_details_model.dart';
import 'package:movie_app_task/src/model/seating_plan_model.dart';
import 'package:movie_app_task/src/model/movies_model.dart';
import 'package:movie_app_task/src/core/api_service.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:convert' as convert;

class MovieController extends GetxController {


  RxBool isLoading = false.obs;
  RxBool loadingTrailer = false.obs;
  Rx<SingleMovieDetails> movieDetails = SingleMovieDetails().obs;
  RxBool playTrailer = false.obs;
  RxBool fetchingSeatInfoProcessing = false.obs;
  List<SeatingPlanModel> seatingPlanList = <SeatingPlanModel>[];

  List<AvailableHall> availableHall = <AvailableHall>[];
  List moviesDates = [];
  String trailerKey = "";
  late YoutubePlayerController playerController =
      YoutubePlayerController(initialVideoId: trailerKey);

  RxInt selectedDateIndex = 0.obs;
  RxInt selectedHallIndex = 0.obs;
  RxString selectedSeatNumber = "".obs;
  RxInt selectedSeatPrice = 0.obs;

  RxBool loadingUpcomingMovies = true.obs;
  Rx<Movies> upCommingMovies = Movies().obs;
  RxBool loadingPopularMovies = true.obs;

  Rx<Movies> popularMovies = Movies().obs;
  BottomBarController bottomBarController = Get.find();

  @override
  void onInit() async {
    // TODO: implement onInit
    if(bottomBarController.pageIndex.value ==0){
      loadUpComingMovies();
    }else if (bottomBarController.pageIndex.value ==1){
      loadPopularMovies();
    }
    addDummyData();
    super.onInit();
  }

  loadUpComingMovies() async {
    loadingUpcomingMovies.value = true;
    upCommingMovies.value = await ApiService.upcomingMovies();
    loadingUpcomingMovies.value = false;
  }

  loadPopularMovies()async{
  loadingPopularMovies.value = true;

  popularMovies.value =   await ApiService.popularMovies();
  loadingPopularMovies.value = false;
}

  void getDetails({required int movieId}) async {
    isLoading.value = true;
    await ApiService.getSingleMovieDetails(movieId: movieId)
        .then((value) async {
      movieDetails.value = value;
      isLoading.value = false;
      loadingTrailer.value = true;
      await ApiService.getMovieTrailer(movieId: movieId).then((value) {
        trailerKey = value;

        loadingTrailer.value = false;
      });
      // get Trailer Video
    });

    log(movieDetails.toString());
  }

  addDummyData() {
    availableHall.clear();
    availableHall.add(AvailableHall(
        id: 1,
        hallName: "Cinetech + Hall 1",
        image: "assets/images/hall_seats_image.svg",
        timings: "12:30",
        rate: 50,
        bonus: 2500));
    availableHall.add(AvailableHall(
        id: 2,
        hallName: "Cinetech + Hall 2",
        image: "assets/images/hall_seats_image.svg",
        timings: "13:30",
        rate: 75,
        bonus: 4000));
    availableHall.add(AvailableHall(
        id: 3,
        hallName: "Cinetech + Hall 3",
        image: "assets/images/hall_seats_image.svg",
        timings: "14:30",
        rate: 100,
        bonus: 5000));

    moviesDates = [
      "1 Mar",
      "2 Mar",
      "3 Mar",
      "4 Mar",
      "5 Mar",
      "6 Mar",
      "7 Mar",
      "8 Mar",
      "9 Mar",
      "10 Mar",
      "11 Mar",
      "12 Mar",
      "13 Mar"
    ];
  }

  Future<List<SeatingPlanModel>> loadSearingInfo() async {
    fetchingSeatInfoProcessing.value = true;

    try {
      String jsonData =
          await rootBundle.loadString('lib/src/core/content_json.json');
      List rawList = convert.jsonDecode(jsonData);
      return rawList.map((json) => SeatingPlanModel.fromJson(json)).toList();
    } catch (e) {
      print("failed due to some reason");
      return <SeatingPlanModel>[];
    }
  }

  generateSeatNumbers() {
    for (int i = 0; i < seatingPlanList.length; i++) {
      for (int j = 0; j < seatingPlanList[i].rows!.length; j++) {
        seatingPlanList[i].rows![j].seatNumber =
            "${seatingPlanList[i].rows![j].row!}S${j+1}";
      }
    }
    Future.delayed(Duration(seconds: 2), () {
      fetchingSeatInfoProcessing.value = false;
    });
  }
}

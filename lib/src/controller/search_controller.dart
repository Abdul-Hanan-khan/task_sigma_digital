
import 'package:get/get.dart';
import 'package:movie_app_task/src/model/movies_model.dart';
import 'package:movie_app_task/src/core/api_service.dart';
import 'package:flutter/material.dart';



class SearchProductController extends GetxController{
  // RxList<SearchProduct> searchedProducts = <SearchProduct>[].obs;
  Rx<Movies>? searchedProducts = Movies().obs;
  RxList<Results> searchList=<Results>[].obs;
  RxBool searchProcessing = false.obs;
  RxBool showGrid = false.obs;
  TextEditingController searchFieldController = TextEditingController();


  loadSearchProduct(String searchString) async {
    searchProcessing.value = true;
    searchedProducts!.value = (await ApiService.searchMovie(query: "$searchString"));

    print(searchedProducts);
    if(searchedProducts!.value.results != null){
      searchList.value=searchedProducts!.value.results!;
    }
    searchProcessing.value = false;

    print(searchList);
  }

  clearSearches(){
    searchedProducts!.value=Movies();
    searchFieldController.clear();
  }

}
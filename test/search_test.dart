import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app_task/src/core/api_service.dart';
import 'package:movie_app_task/src/model/movie_details_model.dart';
import 'package:movie_app_task/src/model/movies_model.dart';

void main() {
  late Movies mockUpComingMovie;

  setUpAll(() {
    mockUpComingMovie = Movies();
  });

  test("Search Movies Test", () async {
    mockUpComingMovie = await ApiService.searchMovie(query: "action");
    expect(mockUpComingMovie.results, isNotNull);
  });

  tearDownAll(() {
    mockUpComingMovie = Movies();
  });
}

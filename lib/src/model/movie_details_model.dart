class SingleMovieDetails {
  String? backdropPath;
  int ?budget;
  List<Genres>? genres;
  int ?id;
  String? imdbId;
  String ?originalLanguage;
  String ?originalTitle;
  String ?overview;
  String ?posterPath;
  String ?releaseDate;
  int ?runtime;
  String ?tagline;
  String ?title;
  bool ?video;

  SingleMovieDetails(
      {

        this.backdropPath,

        this.budget,
        this.genres,
        this.id,
        this.imdbId,
        this.originalLanguage,
        this.originalTitle,
        this.overview,
        this.posterPath,
        this.releaseDate,
        this.runtime,
        this.tagline,
        this.title,
        this.video,


      });

  SingleMovieDetails.fromJson(Map<String, dynamic> json) {
    // adult = json['adult'];
    backdropPath = json['backdrop_path'].toString();
    // belongsToCollection = json['belongs_to_collection'];
    budget = int.parse(json['budget'].toString());
    if (json['genres'] != null) {
      genres = <Genres>[];
      json['genres'].forEach((v) {
        genres!.add(new Genres.fromJson(v));
      });
    }
    // homepage = json['homepage'];
    id = int.parse(json['id'].toString());
    imdbId = json['imdb_id'].toString();
    originalLanguage = json['original_language'].toString();
    originalTitle = json['original_title'].toString();
    overview = json['overview'].toString();
    // popularity = json['popularity'];
    posterPath = json['poster_path'].toString();
    releaseDate = json['release_date'].toString();
    runtime = int.parse(json['runtime'].toString());
    tagline = json['tagline'].toString();
    title = json['title'].toString();
    video = json['video'];;
  }


}

class Genres {
  int ?id;
  String ?name;

  Genres({this.id, this.name});

  Genres.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    name = json['name'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

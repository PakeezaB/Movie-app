class MovieDetail {
  final int id;
  final String title;
  final String posterPath;
  final String releaseDate;
  final List<String> genres;
  final String overview;

  MovieDetail({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.releaseDate,
    required this.genres,
    required this.overview,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      id: json['id'],
      title: json['title'],
      posterPath: json['poster_path'],
      releaseDate: json['release_date'],
      genres: List<String>.from(json['genres'].map((genre) => genre['name'])),
      overview: json['overview'],
    );
  }
}

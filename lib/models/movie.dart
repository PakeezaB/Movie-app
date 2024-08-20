class Movie {
  late final int id;
  late final String title;
  late final String posterPath;
  final String releaseDate;
  final String overview;
  final List<dynamic> genres;

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.releaseDate,
    required this.overview,
    required this.genres,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      posterPath: json['poster_path'],
      releaseDate: json['release_date'],
      overview: json['overview'],
      genres: json['genres'] ?? [],
    );
  }
}

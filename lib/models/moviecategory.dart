class MovieCategory {
  final int id;
  final String name;
  String? imageUrl;

  MovieCategory({required this.id, required this.name, this.imageUrl});

  factory MovieCategory.fromJson(Map<String, dynamic> json) {
    return MovieCategory(
      id: json['id'],
      name: json['name'],
    );
  }
}

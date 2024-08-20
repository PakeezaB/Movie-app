import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/moviecategory.dart';

class CategoryViewModel extends ChangeNotifier {
  final String _apiKey = '362efcce587f5b8d71327dcc272e5821';
  final String _categoryUrl =
      'https://api.themoviedb.org/3/genre/movie/list?api_key=';
  final String _movieUrl =
      'https://api.themoviedb.org/3/discover/movie?api_key=';

  List<MovieCategory> categories = [];
  bool isLoading = false;

  Future<void> fetchCategories() async {
    isLoading = true;
    notifyListeners();

    try {
      final response =
          await http.get(Uri.parse('$_categoryUrl$_apiKey&language=en-US'));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        List<dynamic> genres = data['genres'];
        categories =
            genres.map((json) => MovieCategory.fromJson(json)).toList();
        await fetchMovieImagesForCategories();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching categories: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMovieImagesForCategories() async {
    for (var category in categories) {
      try {
        final response = await http.get(Uri.parse(
            '$_movieUrl$_apiKey&with_genres=${category.id}&language=en-US&sort_by=popularity.desc'));

        if (response.statusCode == 200) {
          Map<String, dynamic> data = jsonDecode(response.body);
          List<dynamic> movies = data['results'];

          if (movies.isNotEmpty) {
            category.imageUrl =
                'https://image.tmdb.org/t/p/w500${movies[0]['poster_path']}';
          } else {
            category.imageUrl = 'https://via.placeholder.com/150';
          }
        } else {
          throw Exception('Failed to load movie images');
        }
      } catch (e) {
        category.imageUrl = 'https://via.placeholder.com/150';
        // ignore: avoid_print
        print('Error fetching movie image for category ${category.name}: $e');
      }
    }
    notifyListeners();
  }
}

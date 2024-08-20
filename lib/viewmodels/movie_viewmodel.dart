import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/movie.dart';

class MovieViewModel with ChangeNotifier {
  final String _apiKey = '362efcce587f5b8d71327dcc272e5821';
  final String _baseUrl = 'https://api.themoviedb.org/3/movie/popular';

  List<Movie> _movies = [];
  List<Movie> _allMovies = []; // To hold the complete list of movies
  bool _isLoading = false;

  List<Movie> get movies => _movies;
  bool get isLoading => _isLoading;

  Future<void> fetchMovies() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('$_baseUrl?api_key=$_apiKey'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> movieList = data['results'];

        _movies = movieList.map((json) => Movie.fromJson(json)).toList();
        // Save all movies for filtering purposes
        _allMovies = List.from(_movies);
        notifyListeners();
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      // Handle any exceptions if needed (network errors, etc.)
      // ignore: avoid_print
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Movie> fetchMovieDetail(int movieId) async {
    final String url =
        'https://api.themoviedb.org/3/movie/$movieId?api_key=$_apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Movie.fromJson(data);
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  Future<void> filterMovies(String query) async {
    if (query.isEmpty) {
      _movies = List.from(_allMovies); // Reset to full movie list
    } else {
      _movies = _allMovies.where((movie) {
        final titleLower = movie.title.toLowerCase();
        final searchLower = query.toLowerCase();
        return titleLower.contains(searchLower);
      }).toList();
    }
    notifyListeners();
  }
}

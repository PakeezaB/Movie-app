// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app_3/models/moviedetail.dart';

class MovieDetailViewModel with ChangeNotifier {
  final String apiKey = '362efcce587f5b8d71327dcc272e5821';
  MovieDetail? _movieDetail;
  bool _isLoading = false;
  String? _errorMessage;

  MovieDetail? get movieDetail => _movieDetail;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchMovieDetailByName(String movieName) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      // Step 1: Search by movie name to get the movie ID
      final String searchUrl =
          'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$movieName';
      final searchResponse = await http.get(Uri.parse(searchUrl));
      print('Search response body: ${searchResponse.body}');

      if (searchResponse.statusCode == 200) {
        final searchData = json.decode(searchResponse.body);
        if (searchData != null &&
            searchData.containsKey('results') &&
            searchData['results'] is List) {
          final results = searchData['results'] as List;
          if (results.isNotEmpty) {
            final movieId = results[0]['id'];

            // Step 2: Fetch movie details using the movie ID
            await fetchMovieDetailById(movieId);
          } else {
            _setErrorMessage('No movie found with the name "$movieName".');
          }
        } else {
          _setErrorMessage('Unexpected search response format.');
        }
      } else {
        _setErrorMessage(
            'Failed to search for movies. Server responded with status code: ${searchResponse.statusCode}.');
      }
    } catch (e) {
      _setErrorMessage('An error occurred while fetching movie details: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchMovieDetailById(int movieId) async {
    final String detailUrl =
        'https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey';

    try {
      final response = await http.get(Uri.parse(detailUrl));
      print('Detail response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _setMovieDetail(MovieDetail.fromJson(data));
      } else {
        _setErrorMessage(
            'Failed to load movie details. Server responded with status code: ${response.statusCode}.');
      }
    } catch (e) {
      _setErrorMessage('An error occurred while fetching movie details: $e');
    }
  }

  void _setMovieDetail(MovieDetail movieDetail) {
    _movieDetail = movieDetail;
    notifyListeners();
  }

  void _setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }
}

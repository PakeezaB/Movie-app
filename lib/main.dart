import 'package:flutter/material.dart';
import 'package:movie_app_3/views/movie_detailscreen.dart';
import 'package:provider/provider.dart';
import 'package:movie_app_3/viewmodels/movie_viewmodel.dart';
import 'package:movie_app_3/viewmodels/category_viewmodel.dart';
import 'package:movie_app_3/viewmodels/detail_viewmodel.dart';
import 'package:movie_app_3/views/movie_listscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => MovieViewModel()..fetchMovies()),
        ChangeNotifierProvider(
            create: (context) => CategoryViewModel()..fetchCategories()),
        ChangeNotifierProvider(
            create: (context) =>
                MovieDetailViewModel()), // Add MovieDetailViewModel
      ],
      child: MaterialApp(
        title: 'Flutter Movie App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: const MovieListScreen(),
        routes: {
          '/detail': (context) => const MovieDetailScreen(
                movieName: '',
              ),
        },
      ),
    );
  }
}

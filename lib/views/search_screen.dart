import 'package:flutter/material.dart';
import 'package:movie_app_3/models/movie.dart';
import 'package:provider/provider.dart';
import '../viewmodels/category_viewmodel.dart';
import '../viewmodels/movie_viewmodel.dart';
import 'movie_detailscreen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _filteredMovies = [];

  void _filterMovies(String query) {
    final movieViewModel = context.read<MovieViewModel>();

    if (query.isEmpty) {
      setState(() {
        _filteredMovies.clear();
      });
      return;
    }

    // Filter movies based on the search query
    setState(() {
      _filteredMovies = movieViewModel.movies
          .where((movie) =>
              movie.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.black),
          autocorrect: true,
          onChanged: (value) {
            _filterMovies(value);
          },
          decoration: const InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                // Clear search field and filtered movies if the action is triggered
                _searchController.clear();
                _filteredMovies.clear();
              });
            },
          ),
        ],
      ),
      body: _searchController.text.isNotEmpty
          ? _filteredMovies.isEmpty
              ? const Center(child: Text('No results found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _filteredMovies.length,
                  itemBuilder: (context, index) {
                    final movie = _filteredMovies[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                            fit: BoxFit.cover,
                            width: 50,
                            height: 75,
                          ),
                        ),
                        title: Text(movie.title),
                        trailing: const Icon(Icons.more_horiz),
                        onTap: () {
                          // Navigate to the detail screen with the selected movie name
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MovieDetailScreen(movieName: movie.title),
                            ),
                          );
                        },
                      ),
                    );
                  },
                )
          : Consumer<CategoryViewModel>(
              builder: (context, categoryViewModel, child) {
                if (categoryViewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (categoryViewModel.categories.isEmpty) {
                  return const Center(child: Text('No categories available'));
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.0,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                    ),
                    itemCount: categoryViewModel.categories.length,
                    itemBuilder: (context, index) {
                      final category = categoryViewModel.categories[index];
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(category.imageUrl ?? ''),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.3),
                              BlendMode.darken,
                            ),
                          ),
                        ),
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          category.name,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 4.0,
                                color: Colors.black,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

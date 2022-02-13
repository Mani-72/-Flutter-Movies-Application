import 'package:flutter_movie_application/models/search_category.dart';

import 'movie.dart';

class MainPageData {
  final List<Movie> movies;
  final int page;
  final String searchCategory;
  final String searchText;

  MainPageData(
      {required this.movies,
      required this.page,
      required this.searchCategory,
      required this.searchText});

  MainPageData.initial()
      : movies = [],
        page = 1,
        searchCategory = SearchCategory.popular,
        searchText = '';

  MainPageData copyWith({List<Movie>? movies, int? page, String? searchCategory,
      String? searchText}) {
    return MainPageData(
        movies: movies ?? this.movies,
        page: page ?? this.page,
        searchCategory: searchCategory ?? this.searchCategory,
        searchText: searchText ?? this.searchText);
  }
}
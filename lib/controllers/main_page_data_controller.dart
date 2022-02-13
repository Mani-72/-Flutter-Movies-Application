import 'package:flutter/foundation.dart';
import 'package:flutter_movie_application/models/main_page_data.dart';
import 'package:flutter_movie_application/models/movie.dart';
import 'package:flutter_movie_application/models/search_category.dart';
import 'package:flutter_movie_application/services/movies_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

class MainPageDataController extends StateNotifier<MainPageData> {
  MainPageDataController([MainPageData? state])
      : super(state ?? MainPageData.initial()) {
    getMovies();
  }

  final MoviesService _moviesService = GetIt.instance.get<MoviesService>();

  Future<void> getMovies() async {
    try {
      List<Movie> _movies = [];

      if (state.searchText.isEmpty) {
        if (state.searchCategory == SearchCategory.popular) {
          _movies = await _moviesService.getPopularMovies(page: state.page);
        } else if (state.searchCategory == SearchCategory.upcoming) {
          _movies = await _moviesService.getUpcomingMovies(page: state.page);
        } else if (state.searchCategory == SearchCategory.upcoming) {
          _movies = [];
        }
      } else {
        _movies = await _moviesService.searchMovies(state.searchText, page: state.page);
      }

      state = state.copyWith(
          movies: [...state.movies, ..._movies], page: state.page + 1);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  void updateSearchCategory(String _category) {
    try {
      state = state.copyWith(
          movies: [], page: 1, searchCategory: _category, searchText: '');
      getMovies();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void updateTextSearch(String _searchText) {
    try {
      state = state.copyWith(movies: [], page: 1, searchCategory: SearchCategory.none, searchText: _searchText );
      getMovies();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}

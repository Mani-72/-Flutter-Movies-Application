import 'package:dio/dio.dart';
import 'package:flutter_movie_application/models/movie.dart';
import 'package:flutter_movie_application/services/http_service.dart';
import 'package:get_it/get_it.dart';

class MoviesService {
  final GetIt getIt = GetIt.instance;
  late HTTPService _httpService;

  MoviesService() {
    _httpService = getIt.get<HTTPService>();
  }

  Future<List<Movie>> getPopularMovies({required int page}) async {
    Response _response = await _httpService.get(path: '/movie/popular', query: {
      'page': page,
    });

    if (_response.statusCode == 200) {
      Map _data = _response.data;
      List<Movie> _movies = _data['results'].map<Movie>((_movieData) {
        return Movie.fromJson(_movieData);
      }).toList();
      return _movies;
    } else {
      throw Exception('Could not load the popular movies');
    }
  }

  Future<List<Movie>> getUpcomingMovies({required int page}) async {
    Response _response =
        await _httpService.get(path: '/movie/upcoming', query: {
      'page': page,
    });

    if (_response.statusCode == 200) {
      Map _data = _response.data;
      List<Movie> _movies = _data['results'].map<Movie>((_movieData) {
        return Movie.fromJson(_movieData);
      }).toList();
      return _movies;
    } else {
      throw Exception('Could not load the upcoming movies');
    }
  }

  Future<List<Movie>> searchMovies(String _searchTerm,
      {required int page}) async {
    Response _response = await _httpService.get(path: '/search/movie', query: {
      'query': _searchTerm,
      'page': page,
    });

    if (_response.statusCode == 200) {
      Map _data = _response.data;
      List<Movie> _movies = _data['results'].map<Movie>((_movieData) {
        return Movie.fromJson(_movieData);
      }).toList();
      return _movies;
    } else {
      throw Exception('Could not load the searched movies');
    }
  }
}

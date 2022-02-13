import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_movie_application/models/app_config.dart';
import 'package:get_it/get_it.dart';

class HTTPService {
  final Dio dio = Dio();
  final GetIt getIt = GetIt.instance;

  late String _base_url;
  late String _api_key;

  HTTPService() {
    AppConfig _config = getIt.get<AppConfig>();
    _base_url = _config.BASE_API_URL;
    _api_key = _config.API_KEY;
  }

  Future<Response> get({required String path, required Map<String, dynamic> query}) async {
    try {
      String _url = '$_base_url$path';
      Map<String, dynamic> _query = {
        'api_key': _api_key,
        'language': 'en-us',
      };
      if (query.isNotEmpty) {
        _query.addAll(query);
      }

      print('Sunny  '+_url);
      print('Sunny  '+_query.toString());

      return await dio.get(_url, queryParameters: _query);
    } on DioError catch (e) {
      if (kDebugMode) {
        print('Unable to perform the get request.');
        print('DioError: $e');
      }
      rethrow;
    }
  }
}

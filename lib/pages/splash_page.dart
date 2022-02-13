import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_movie_application/models/app_config.dart';
import 'package:flutter_movie_application/services/http_service.dart';
import 'package:flutter_movie_application/services/movies_service.dart';
import 'package:get_it/get_it.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback onInitializationComplete;

  const SplashPage({Key? key, required this.onInitializationComplete})
      : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _setUp(context).then(
      (_) => widget.onInitializationComplete(),
    );
  }

  Future<void> _setUp(BuildContext _context) async {
    final getIt = GetIt.instance; // Object creation factory

    final configFile = await rootBundle.loadString('assets/config/main.json');
    final configData = jsonDecode(configFile);
    getIt.registerSingleton<AppConfig>(
      AppConfig(
        API_KEY: configData['API_KEY'],
        BASE_API_URL: configData['BASE_API_URL'],
        BASE_IMAGE_API_URL: configData['BASE_IMAGE_API_URL'],
      ),
    );

    getIt.registerSingleton<HTTPService>(
      HTTPService(),
    );

    getIt.registerSingleton<MoviesService>(
      MoviesService(),
    );

    /*The order of the getIt matters as the these classes are dependent on each other*/
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Movie App",
      color: Colors.blue,
      home: Center(
        child: Container(
          height: 200,
          width: 400,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.contain,
              image: AssetImage('assets/images/logo.jpg'),
            ),
          ),
        ),
      ),
    );
  }
}

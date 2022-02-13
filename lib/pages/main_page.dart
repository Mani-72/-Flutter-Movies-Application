import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_movie_application/controllers/main_page_data_controller.dart';
import 'package:flutter_movie_application/models/main_page_data.dart';
import 'package:flutter_movie_application/models/movie.dart';
import 'package:flutter_movie_application/models/search_category.dart';
import 'package:flutter_movie_application/widgets/movie_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mainPageDataControllerProvider =
    StateNotifierProvider<MainPageDataController, MainPageData>(
  (_) => MainPageDataController(),
);

final selectedMoviePosterURLProvider = StateProvider<String>((ref){
  final _movies = ref.watch(mainPageDataControllerProvider).movies;
  return _movies.length !=0?  _movies[0].posterURL() :  'https://image.tmdb.org/t/p/original/4B7liCxNCZIZGONmAMkCnxVlZQV.jpg';
});

class MainPage extends ConsumerWidget {
  late double _deviceHeight;
  late double _deviceWidth;
  late String  _selectedMoviePosterUrl;

  late MainPageDataController _mainPageDataController;
  late MainPageData _mainPageData;

  late TextEditingController _searchTextFieldController;

  MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    _mainPageDataController =
        ref.watch(mainPageDataControllerProvider.notifier);
    _mainPageData = ref.watch(mainPageDataControllerProvider);
    _selectedMoviePosterUrl = ref.watch(selectedMoviePosterURLProvider);

    _searchTextFieldController = TextEditingController();

    _searchTextFieldController.text = _mainPageData.searchText;

    return _buildUI();
  }

  Widget _buildUI() {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: Container(
          height: _deviceHeight,
          width: _deviceWidth,
          child: Stack(
            // stack use to put the one UI on the top of another
            alignment: Alignment.center,
            children: [_backgroundWidget(), _foregroundWidgets()],
          ),
        ),
      ),
    );
  }

  Widget _backgroundWidget() {
    return Container(
      height: _deviceHeight,
      width: _deviceWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: NetworkImage(
              _selectedMoviePosterUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 15.0,
          sigmaY: 15.0,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
          ),
        ),
      ),
    );
  }

  Widget _foregroundWidgets() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, _deviceHeight * 0.02, 0, 0),
      width: _deviceWidth * 0.88,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _topBarWidget(),
          Container(
            height: _deviceHeight * 0.83,
            padding: EdgeInsets.symmetric(vertical: _deviceHeight * 0.01),
            child: _moviesListViewWidget(),
          ),
        ],
      ),
    );
  }

  Widget _topBarWidget() {
    return Container(
      height: _deviceHeight * 0.08,
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _searchFieldWidget(),
          _categorySelectionWidget(),
        ],
      ),
    );
  }

  Widget _searchFieldWidget() {
    final _border = InputBorder.none;
    return Container(
      width: _deviceWidth * 0.50,
      height: _deviceHeight * 0.05,
      child: TextField(
        controller: _searchTextFieldController,
        onSubmitted: (_input) {
          _input.isNotEmpty
              ? _mainPageDataController.updateTextSearch(_input)
              : {};
        },
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
            focusedBorder: _border,
            border: _border,
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white24,
            ),
            hintStyle: TextStyle(color: Colors.white54),
            filled: false,
            fillColor: Colors.white24,
            hintText: 'Search....'),
      ),
    );
  }

  Widget _categorySelectionWidget() {
    return DropdownButton(
      items: [
        DropdownMenuItem(
          child: Text(
            SearchCategory.popular,
            style: TextStyle(color: Colors.white),
          ),
          value: SearchCategory.popular,
        ),
        DropdownMenuItem(
            child: Text(
              SearchCategory.upcoming,
              style: TextStyle(color: Colors.white),
            ),
            value: SearchCategory.upcoming),
        DropdownMenuItem(
            child: Text(
              SearchCategory.none,
              style: TextStyle(color: Colors.white),
            ),
            value: SearchCategory.none),
      ],
      onChanged: (_value) => _value.toString().isNotEmpty
          ? _mainPageDataController.updateSearchCategory(_value.toString())
          : {},
      dropdownColor: Colors.black38,
      value: _mainPageData.searchCategory,
      icon: Icon(
        Icons.menu,
        color: Colors.white24,
      ),
      underline: Container(
        height: 1,
        color: Colors.white24,
      ),
    );
  }

  Widget _moviesListViewWidget() {
    final List<Movie> _movies = _mainPageData.movies;

    if (_movies.isNotEmpty) {
      return NotificationListener(
        onNotification: (_onScrollNotification) {
          if (_onScrollNotification is ScrollEndNotification) {
            final before = _onScrollNotification.metrics.extentBefore;
            final max= _onScrollNotification.metrics.maxScrollExtent;

            if(before == max){
              _mainPageDataController.getMovies();
              return true;
            }
            return false;
          }
          return false;
        },
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(
                  vertical: _deviceHeight * 0.01, horizontal: 0),
              child: GestureDetector(
                onTap: () {

                  // _selectedMoviePosterUrl= _movies[index].posterURL();
                },
                child: MovieTile(
                  movie: _movies[index],
                  height: _deviceHeight * 0.20,
                  width: _deviceWidth * 0.85,
                ),
              ),
            );
          },
          itemCount: _movies.length,
        ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
      );
    }
  }
}

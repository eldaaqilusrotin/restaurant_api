// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:flutter/foundation.dart';
import '../data/api/api_service.dart';
import '../data/model/search.dart';
import 'package:http/http.dart' as http;

enum SearchResultState { loading, noData, hasData, error }

class SearchRestaurantsProvider extends ChangeNotifier {
  final ApiService apiService;
  String query;

  SearchRestaurantsProvider({
    required this.apiService,
    this.query ='',
  }) {
    searchRestaurants(query);
  }

  late RestaurantSearchModel _restaurantsResult;
  late SearchResultState _state;
  String _message = '';

  String get message => _message;

  RestaurantSearchModel get result => _restaurantsResult;

  SearchResultState get state => _state;

  SearchRestaurants(String newValue) {
    query = newValue;
    searchRestaurants(query);
    notifyListeners();
  }Future searchRestaurants(value) async {
    try {
      _state = SearchResultState.loading;
      notifyListeners();

      final restaurant = await apiService.searchRestaurants(value,http.Client());
      if (restaurant.restaurants.isEmpty) {
        _state = SearchResultState.noData;
        notifyListeners();
        return _message = 'No Data, try again';

      }else {
        _state = SearchResultState.hasData;
        notifyListeners();
        return _restaurantsResult = restaurant;
      }
    } on SocketException {
      _state = SearchResultState.error;
      notifyListeners();
      return _message =
      'No Internet connection';
    }
    catch (e) {
      _state = SearchResultState.error;
      notifyListeners();
      return _message = 'Error => $e';
    }
  }
}

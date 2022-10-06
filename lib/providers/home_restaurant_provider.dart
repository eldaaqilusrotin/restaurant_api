import '../data/api/api_service.dart';
import '../data/model/restaurant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class RestaurantsProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantsProvider({required this.apiService}) {
    _fetchRestaurantsList();
  }

  late RestaurantsList _restaurantsList;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  RestaurantsList get result => _restaurantsList;

  ResultState get state => _state;

  Future<dynamic> _fetchRestaurantsList() async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final restaurant = await apiService.list(http.Client());
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurantsList = restaurant;
      }
    }catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}

enum ResultState { loading, noData, hasData, error }


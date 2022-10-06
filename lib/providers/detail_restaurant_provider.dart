import 'package:flutter/foundation.dart';
import '../data/api/api_service.dart';
import '../data/model/detail_restaurant.dart';
import 'package:http/http.dart' as http;

enum RestaurantState {loading, noData, hasData, error}

class DetailRestaurantProvider extends ChangeNotifier {
  final ApiService apiService;


  DetailRestaurantProvider({
    required this.apiService,
    required String id,
  }) {
    fetchDetailRestaurant(id);
  }

  late RestaurantDetail _detail;
  late RestaurantState _restaurantState;

 String _message = '';

  String get message => _message;
  RestaurantDetail get detail => _detail;

  RestaurantState get restaurantState => _restaurantState;


  Future fetchDetailRestaurant(id) async {
    try {
      _restaurantState = RestaurantState.loading;
      notifyListeners();
      final detail = await apiService.detailRestaurant(id, http.Client());
      if (detail.error) {
        _restaurantState = RestaurantState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _restaurantState = RestaurantState.hasData;
        notifyListeners();
        return _detail = detail;
      }
    } catch (e) {
      _restaurantState = RestaurantState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}

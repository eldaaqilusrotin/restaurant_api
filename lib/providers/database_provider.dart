import 'package:flutter/foundation.dart';
import '../common/result_state.dart';
import '../data/database/database_helper.dart';


class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  DatabaseProvider({required this.databaseHelper}) {
    _getFavorite();
  }

  ResultState? _state;
  String _message = '';
  List<String> _favorited = [];

  ResultState? get state => _state;
  String get message => _message;
  List<String> get favorited => _favorited;

  void _getFavorite() async {
    _favorited = await databaseHelper.getFavorite();
    if (_favorited.isNotEmpty) {
      _state = ResultState.hasData;
    } else {
      _state = ResultState.noData;
      _message = 'Tidak ada data';
    }
    notifyListeners();
  }

  void addFavorite(String favoritedRestaurantId) async {
    try {
      await databaseHelper.addFavorite(favoritedRestaurantId);
      _getFavorite();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  void removeFavorite(String id) async {
    try {
      await databaseHelper.removeFavorited(id);
      _getFavorite();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  Future<bool> isFavorited(String id) async {
    final favoritedRestaurant = await databaseHelper.getFavoriteById(id);
    return favoritedRestaurant.isNotEmpty;
  }
}
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:restaurant_api/data/model/restaurant.dart';
import '../model/detail_restaurant.dart';
import '../model/restaurant_review.dart';
import '../model/search.dart';


class ApiService {

  final String _baseUrl = 'https://restaurant-api.dicoding.dev';
  final String listUrl = '/list';
  final String _detail = '/detail/';
  final String _search = '/search?q=';
  final String _smallImage = '/images/small/';
  final String _mediumImage = '/images/medium/';
  final String _largeImage = '/images/large/';
  final String _review = '/review';
  final String _headers = 'application/x-www-form-urlencoded';


  Future<RestaurantsList> list(http.Client client) async {
    final response = await client.get(Uri.parse('$_baseUrl$listUrl'));
    if (response.statusCode == 200) {
      return RestaurantsList.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load recommendation restaurants');
    }
  }

  Future<RestaurantDetail> detailRestaurant(String id, http.Client client) async {
    final response = await client.get(Uri.parse('$_baseUrl$_detail$id'));
    if (response.statusCode == 200) {
      return RestaurantDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load detail restaurants');
    }
  }

  Future<RestaurantSearchModel> searchRestaurants(String query, http.Client client) async {
    final response = await client.get(Uri.parse('$_baseUrl$_search$query'));
    if (response.statusCode == 200) {
      return RestaurantSearchModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load search restaurants');
    }
  }


  Future<RestaurantReview> addReview(id, name, review) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$_review'),
      headers: {'Content-Type': _headers},
      body: {
        "id": id,
        "name": name,
        "review": review,
      },
    );
    return RestaurantReview.fromJson(json.decode(response.body));
  }


  smallImage(pictureId) {
    String url = "$_baseUrl$_smallImage$pictureId";
    return url;
  }

  mediumImage(pictureId) {
    String url = "$_baseUrl$_mediumImage$pictureId";
    return url;
  }

  largeImage(pictureId) {
    String url = "$_baseUrl$_largeImage$pictureId";
    return url;
  }

}
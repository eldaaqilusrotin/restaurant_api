// ignore_for_file: non_constant_identifier_names

class RestaurantsList{
  bool error;
  String message;
  int count;
  List<Restaurant> restaurants;

  RestaurantsList({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  factory RestaurantsList.fromJson(Map<String, dynamic> json) =>
      RestaurantsList(
        error: json['error'],
        message: json['message'],
        count: json['count'],
        restaurants: List<Restaurant>.from(
          (json['restaurants'] as List).map((e) => Restaurant.fromJson(e)),
        ),
      );
}

class Restaurant {
  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    city: json["city"],
    pictureId: json["pictureId"],
    rating: json["rating"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "pictureId": pictureId,
    "city": city,
    "rating": rating,
  };
}
class SearchResto {
  SearchResto({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  final bool error;
  final int founded;
  final List<Restaurant> restaurants;

  factory SearchResto.fromJson(Map<String, dynamic> json) => SearchResto(
    error: json["error"],
    founded: json["founded"],
    restaurants: List<Restaurant>.from(json["restaurants"].map((x) => Restaurant.fromJson(x))),
  );

}

class Categories {
  late String name;

  Categories({
    required this.name,
  });

  Categories.fromJson(Map<String, dynamic> category) {
    name = category['name'];
  }
}

class Menu {
  late List<Item> foods;
  late List<Item> drinks;

  Menu({
    required this.foods,
    required this.drinks,
  });
}

class Item {
  late String name;

  Item({
    required this.name,
  });

  Item.fromJson(Map<String, dynamic> item) {
    name = item['name'];
  }
}

class Review {
  late String name;
  late String review;
  late String date;

  Review({
    required this.name,
    required this.review,
    required this.date,
  });

  Review.fromJson(Map<String, dynamic> reviews) {
    name = reviews['name'];
    review = reviews['review'];
    date = reviews['date'];
  }
}


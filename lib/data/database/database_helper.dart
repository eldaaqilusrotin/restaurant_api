import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tableFavoritedRestaurant = 'favorited_restaurant';
  final String _columnRestaurantId = 'id';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var database = openDatabase(
      '$path/favorited_restaurant.db',
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE $_tableFavoritedRestaurant ($_columnRestaurantId TEXT PRIMARY KEY NOT NULL)');
      },
      version: 1,
    );

    return database;
  }

  Future<Database?> get database async {
    _database ??= await _initializeDb();

    return _database;
  }

  Future<void> addFavorite(String favoritedRestaurantId) async {
    final db = await database;
    await db!.rawInsert(
        'INSERT INTO $_tableFavoritedRestaurant($_columnRestaurantId) VALUES ("$favoritedRestaurantId")');
  }

  Future<List<String>> getFavorite() async {
    final db = await database;
    List<Map<String, dynamic>> results =
    await db!.query(_tableFavoritedRestaurant);

    return results.map((e) => e['id'] as String).toList();
  }

  Future<Map> getFavoriteById(String id) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db!.query(
      _tableFavoritedRestaurant,
      where: '$_columnRestaurantId = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  Future<void> removeFavorited(String id) async {
    final db = await database;

    await db!.delete(
      _tableFavoritedRestaurant,
      where: '$_columnRestaurantId = ?',
      whereArgs: [id],
    );
  }
}
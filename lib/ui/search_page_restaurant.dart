import 'dart:async';
import 'dart:developer' as developer;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_api/providers/search_provider.dart';
import 'package:restaurant_api/widgets/card_restaurants.dart';


class SearchPageRestaurant extends StatefulWidget {
  static const routeName = 'search';

  const SearchPageRestaurant({Key? key}) : super(key: key);

  @override
  State<SearchPageRestaurant> createState() => _SearchPageRestaurantState();
}

class  _SearchPageRestaurantState extends State<SearchPageRestaurant> {
  late TextEditingController textEditingController;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> subscription;


  Future<void> initConnectivity() async {
    late ConnectivityResult result;

    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('check your connectivity', error: e);
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  void dispose() {
    super.dispose();

    subscription.cancel();
    textEditingController.dispose();
  }


  @override
  void initState() {
    super.initState();
    initConnectivity();

    final SearchRestaurantsProvider searchRestaurantsProvider =
    Provider.of<SearchRestaurantsProvider>(context, listen: false);

    textEditingController =
        TextEditingController(text: searchRestaurantsProvider.query);

    subscription = Connectivity().onConnectivityChanged.listen((event) {
      setState(() {
        _connectionStatus = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_connectionStatus != ConnectivityResult.none){
      return Scaffold(
        appBar: AppBar(
          leading:
          const Icon(
          Icons.search_sharp,
          size: 30,
          ),
          title: Consumer<SearchRestaurantsProvider>(
            builder: (context, state, _) =>
                TextField(
              controller: textEditingController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: Colors.black,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              style: const TextStyle(
                color: Colors.black,
              ),
              cursorColor: Colors.brown.shade100,
              onChanged: (value) {
                Provider.of<SearchRestaurantsProvider>(context, listen: false)
                    .searchRestaurants(value);
              },
            ),
            ),
            elevation: 2,
          ),
            body: Consumer<SearchRestaurantsProvider>(
            builder: (context, state, _) {
            if (state.state == SearchResultState.loading) {
              return Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                    SizedBox(
                  height: 10,
                ),
                  Text('data loading'),

                    ],
                  ),
                );
              } else if (state.state == SearchResultState.hasData) {
                return ListView.builder(
                itemCount: state.result.founded.toInt(),
                itemBuilder: (context, index) {
                final restaurant = state.result.restaurants[index];
                  return Cardrestaurants(
                  restaurant: restaurant);
            },
            );
            } else if (state.state == SearchResultState.noData) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                  Icon(
                  MdiIcons.emoticonNeutral,
                  size: 75,
                  color: Colors.lightBlueAccent,
                  ),
                  SizedBox(
                  height: 10,
                  ),
                  Text(
                  'The Keyword is not found',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlueAccent,
                  ),
                )
              ],
              ),
            );
            } else {
              return Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                  Icon(
                  MdiIcons.textSearch,
                  size: 75,
                  color: Colors.lightBlueAccent,
                ),
                  SizedBox(
                  height: 10,
                ),
                  Text(
                  'Search Restaurants',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlueAccent,
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        )
      );
    } else {
      return Scaffold(
        body: Center(
          child: SizedBox(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.signal_wifi_connected_no_internet_4,
                  size: 50, color: Colors.red,
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Network Disconnected please check your internet',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

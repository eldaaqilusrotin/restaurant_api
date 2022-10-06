import 'dart:async';
import 'dart:developer' as developer;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_api/providers/home_restaurant_provider.dart';
import 'package:restaurant_api/widgets/platform_widget.dart';
import 'package:restaurant_api/widgets/card_restaurants.dart';


class RestaurantListPage extends StatefulWidget {
   const RestaurantListPage({Key? key}) : super(key: key);

  @override
  State<RestaurantListPage > createState() => _RestaurantListPageState();
}

class  _RestaurantListPageState extends State<RestaurantListPage > {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> subscription;

  Future<void> initConnectivity() async {
    late ConnectivityResult result;

    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
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
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();


    subscription = Connectivity().onConnectivityChanged.listen((event) {
      setState(() {
        _connectionStatus = event;
      });
    });
  }


  Widget _buildandroid(BuildContext context) {
    if (_connectionStatus != ConnectivityResult.none) {
      return Scaffold(
          body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [

                  const SliverAppBar(
                    title: Text('Recommendation Restaurant', style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),),

                  ),
                ];
              },
              body: Consumer<RestaurantsProvider>(
                builder: (context, state, _) {
                  if (state.state == ResultState.loading) {
                    return const CircularProgressIndicator(
                      color: Colors.blue,
                    );
                  } else if (state.state == ResultState.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.result.restaurants.length,
                      itemBuilder: (context, index) {
                        var restaurant = state.result.restaurants[index];
                        return Cardrestaurants(restaurant: restaurant);
                      },
                    );
                  } else if (state.state == ResultState.noData) {
                    return Center(
                      child: Text(state.message),
                    );
                    } else {
                    return const Center(
                      child: Text(''),
                    );
                  }
                },
              )
          )
      );
    } else{
      return Scaffold(
        body: Center(
          child: SizedBox(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.signal_wifi_connected_no_internet_4,
                  size: 50,color: Colors.red,
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


  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Restaurant For You'),
        transitionBetweenRoutes: false,
      ),
      child: build(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildandroid,
      iosBuilder: _buildIos,
    );
  }
}
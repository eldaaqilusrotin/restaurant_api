// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_api/data/api/api_service.dart';
import 'package:restaurant_api/providers/detail_restaurant_provider.dart';

import '../widgets/detail_widget.dart';
import '../widgets/review_widget.dart';

class DetailRestaurantPage extends StatelessWidget {
  static const routeName = '/detail_restaurant';

  final String id;

  const DetailRestaurantPage({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DetailRestaurantProvider>(
        create: (context) => DetailRestaurantProvider(
          apiService: ApiService(),
          id: id,
        ),
        child: Consumer<DetailRestaurantProvider>(
            builder: (context, state, _) {
              if (state.restaurantState == RestaurantState.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state.restaurantState  == RestaurantState.hasData) {
                return Scaffold(
                  body: RefreshIndicator(
                    onRefresh: () => Navigator.pushReplacementNamed(
                        context, DetailRestaurantPage.routeName,
                        arguments: state.detail.restaurant.id),

                    child: LayoutBuilder(builder: (context, constraints) {
                      return DetailWidget(
                          listdetail : state.detail.restaurant);
                    }
                    ),
                ),
                    floatingActionButton: FloatingActionButton.extended(
                    onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => ReviewWidget(restaurantId: id),
                    );
                    },
                      label: const Text('Add Review'),
                      icon: const Icon(Icons.edit),
                  ),
                );
              } else if (state.restaurantState  == RestaurantState.noData) {
                return Center(
                  child: Text(state.message),
                );
              }else{
                return Scaffold(
                  body: Center(
                    child: SizedBox(
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.signal_wifi_connected_no_internet_4,
                            size: 50,
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
        )
    );
  }
}
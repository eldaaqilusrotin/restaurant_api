import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_api/ui/home_page.dart';
import '../providers/database_provider.dart';
import '../common/result_state.dart';
import '../widgets/favorite_restaurants_widget.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            elevation: 2,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      MdiIcons.robotLove,
                      size: 75,
                      color: Colors.lightBlueAccent,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Your Restaurant Favorite',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  ],
                ),
              ),
              titlePadding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
            ),
          ),
        ];
      },
      body: Consumer<DatabaseProvider>(
        builder: (context, provider, child) {
          if (provider.state == ResultState.hasData) {
            return RefreshIndicator(
              onRefresh: () {
                return Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ));
              },
              child: MasonryGridView.builder(
                gridDelegate:
                const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                padding: const EdgeInsets.all(5),
                itemCount: provider.favorited.length,
                itemBuilder: (context, index) {
                  var favoritedRestaurantList = provider.favorited[index];
                  return FavoriteRestaurantWidget(
                      favoritedRestaurantId: favoritedRestaurantList);
                },
              ),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  'nothing favorite restaurant',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
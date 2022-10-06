import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_api/common/style.dart';
import 'package:restaurant_api/data/api/api_service.dart';
import 'package:restaurant_api/data/model/restaurant.dart';
import 'package:restaurant_api/providers/database_provider.dart';
import 'package:restaurant_api/ui/detail_restaurant_page.dart';
import 'package:restaurant_api/widgets/add_dialog_favorite.dart';
import '../common/navigation.dart';



class Cardrestaurants extends StatelessWidget {
  final Restaurant restaurant;

  const Cardrestaurants({
    required this.restaurant,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
        builder: (context, provider, child) => FutureBuilder(
        future: provider.isFavorited(restaurant.id),
        builder: (context, snapshot) {
        var isFavorited = snapshot.data ?? false;
          return GestureDetector(
          onLongPress: () async {
          await showDialog(
          context: context,
            builder: (context) => AddToFavoriteDialog(
            provider: provider,
            favoritedRestaurantId: restaurant.id,
            isFavorited: isFavorited,
            ),
            );
            },
            child : Container(
              margin: const EdgeInsets.symmetric(vertical: 12.0),
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child : Material(
                color: primaryColor,
                child : InkWell(
                onTap: () {
                  Navigation.intentWithData(DetailRestaurantPage.routeName,
                      restaurant.id);
                  },
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: Image(
                          image: NetworkImage(
                            ApiService()
                                .mediumImage(restaurant.pictureId),
                          ),

                            fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress){
                            if (loadingProgress ==null) return child;

                            return const Center(child: Text('loading...'));
                          },
                          errorBuilder: (context, eror, stackTrace) => const Center(child: Text('eror data'))
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(25.0),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                            ),
                            boxShadow: [
                              BoxShadow(blurRadius: 1.0,
                                spreadRadius: 1.0,
                                color : Colors.grey,
                              )
                            ]
                        ),

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      restaurant.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 30, fontFamily: "Samantha")
                                  ),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  RichText(
                                    textAlign: TextAlign.start,
                                    text: TextSpan(
                                      children: [
                                        const WidgetSpan(
                                          child: Icon(
                                            Icons.location_on,
                                            size: 16,
                                            color: Colors.lightBlue,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                          ' ${restaurant.city}',
                                        )
                                      ],
                                      style: Theme.of(context).textTheme.caption,

                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                    children: [
                                      const WidgetSpan(
                                        child: Icon(
                                          Icons.star,
                                          size: 18,
                                          color: Colors.amber,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' ${restaurant.rating.toStringAsFixed(2)}',
                                      )
                                    ],
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        ?.copyWith(color: CupertinoColors.systemYellow),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ]
                    )
                  )
                )
              )
            );
          }
        )
    );
  }
}
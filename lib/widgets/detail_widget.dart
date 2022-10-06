
// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_api/data/model/detail_restaurant.dart';
import 'package:restaurant_api/providers/database_provider.dart';
import '../data/api/api_service.dart';

class DetailWidget extends StatefulWidget {
  final Restaurant listdetail;

  const DetailWidget({super.key, required this.listdetail,});

  @override
  State<DetailWidget> createState() => _DetailWidgetState();
}

class _DetailWidgetState extends State<DetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: NestedScrollView(
            headerSliverBuilder: (context, isScrolled) {
              return [
                SliverAppBar(
                    title: Text(widget.listdetail.name!),
                    pinned: true,
                    expandedHeight: 400,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Hero(
                        tag: widget.listdetail.id!,
                          child: Image(
                            image: NetworkImage(
                                ApiService().mediumImage(widget.listdetail.pictureId)
                            ),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null){
                                return child;
                            }else {
                              return SizedBox(
                                height: 250,
                                width: MediaQuery.of(context).size.width,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                );
                              }
                            },
                            errorBuilder: (context, eror, stackTrace) =>
                            const Center(child: Text('eror data'))
                        ),
                      ),

                )
                )
              ];
            },body: ListView(
              children : <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                  Row(
                    children : <Widget>[
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 8.0,
                            ),

                            Text(
                              widget.listdetail.name!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),

                            RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                children: [
                                  const WidgetSpan(
                                    child: Icon(
                                      Icons.location_on,
                                      size: 16,
                                      color: Colors.lightBlue
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                    ' ${widget.listdetail.address!}, ${widget.listdetail.city!}',
                                  )
                                ],
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ),

                            const SizedBox(
                              height: 8.0,
                            ),
                          ],
                        )
                      ),

                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: RichText(
                            textAlign: TextAlign.right,
                            text: TextSpan(
                              children: [
                                const WidgetSpan(
                                  child: Icon(
                                    Icons.star,
                                    size: 25,
                                    color: Colors.orangeAccent,
                                  ),
                                ),
                                TextSpan(
                                  text: ' ${widget.listdetail.rating!.toString()}',
                                )
                              ],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.copyWith(color: Colors.orangeAccent),
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: Align(alignment: Alignment.centerRight,
                        child: Consumer<DatabaseProvider>(
                          builder: (context, provider, child) => FutureBuilder(
                            future:
                            provider.isFavorited(widget.listdetail.id!),
                            builder: (context, snapshot) {
                              var isFavorited = snapshot.data ?? false;
                              if (isFavorited == true) {
                                return IconButton(
                                  onPressed: () {
                                    provider.removeFavorite(
                                        widget.listdetail.id!);
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.favorite, color: Colors.red,),
                                );
                              } else {
                                return IconButton(
                                  onPressed: () {
                                    provider.addFavorite(
                                        widget.listdetail.id!);
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.favorite_border),
                                );
                              }
                            },
                          ),
                        ),
                      )
                      )

                    ]
                  ),
                  const SizedBox(
                  height: 18.0,

                  ),

                            Row(
                              children: widget.listdetail.categories!
                                  .map((category) => Text(category.name, style:
                              const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue
                                  )
                                )
                              )
                                       .toList(),
                            ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      widget.listdetail.description!,textAlign: TextAlign.justify,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    const Text(
                      'Menu : ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),

                    const Text(
                      'Foods',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(8),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: widget.listdetail.menus!.drinks
                            .map((food) => Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child : Container(
                                    height: 100,
                                    width: 200,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.lightBlueAccent
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: <Widget>[
                                        const Icon(Icons.restaurant_menu,),
                                        Text(food.name),
                                      ],
                                    )
                                )
                            )
                          ],
                        )
                        )
                            .toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Drinks',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(8),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: widget.listdetail.menus!.drinks
                            .map((drink) => Column(
                          children: [
                            Padding(
                            padding: const EdgeInsets.all(8.0),
                            child : Container(
                                height: 100,
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.lightBlueAccent
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Icon(Icons.emoji_food_beverage,),
                                    Text(drink.name),
                                  ],
                                )
                            )
                            )
                          ],
                        )
                        ).toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    const Text(
                      'Review : ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  SingleChildScrollView(
                   padding: const EdgeInsets.all(8),
                  scrollDirection: Axis.horizontal,
                    child: Row(
                  children: widget.listdetail.customerReviews!
                  .map((review) => Column(
                  children: [
                  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child : Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20), color: Colors.white
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Row(
                            children: <Widget> [
                              Expanded(child:
                             Text("Name : ${review.name}", maxLines: 5, overflow: TextOverflow.ellipsis,)),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget> [
                              Expanded(child:
                              Text("Comment : ${review.review}",maxLines: 3, overflow: TextOverflow.ellipsis,
                              ))],
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          Row(
                            children: <Widget> [
                             Text(review.date),
                                    ],
                                  ),
                                ],
                              )
                            )
                          )
                        ],
                      )
                    ).toList(),
                  ),
                ),
              ])
            )
          ]
        )
      )
    );
  }
}


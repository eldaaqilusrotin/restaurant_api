import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_api/providers/search_provider.dart';

import '../common/style.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({Key? key}) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  String queries = '';
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchRestaurantsProvider>(
      builder: (context, state, _) {
        return Center(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.search_sharp,
                    size: 30,
                  ),
                  title: TextField(
                    controller: _controller,
                    onChanged: (String query) {
                      if (query.isNotEmpty) {
                        setState(() {
                          queries = query;
                        });
                        state. searchRestaurants(query);
                      }
                    },
                    cursorColor: Colors.grey,
                    decoration: const InputDecoration(
                      hintText: 'input restaurant..',
                      border: InputBorder.none,
                    ),
                  ),
                  trailing: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      if (queries.isNotEmpty) {
                        _controller.clear();
                        setState(() {
                          queries = '';
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

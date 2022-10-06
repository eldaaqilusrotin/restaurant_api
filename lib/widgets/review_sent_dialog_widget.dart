// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:restaurant_api/ui/detail_restaurant_page.dart';
import 'package:flutter/material.dart';

class ReviewSentDialogWidget extends StatefulWidget {
  final restaurantId;

  const ReviewSentDialogWidget({super.key, required this.restaurantId});

  @override
  State<ReviewSentDialogWidget> createState() => _ReviewSentDialogWidgetState();
}

class _ReviewSentDialogWidgetState extends State<ReviewSentDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      content: SizedBox(
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              'Review successfully submitted!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, DetailRestaurantPage.routeName,
                arguments: widget.restaurantId);
          },
          child: Text('OK', style: Theme
              .of(context)
              .textTheme
              .button
              ?.copyWith(color: Colors.blue),),
        ),
      ],
    );
  }
}

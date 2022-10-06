// ignore_for_file: prefer_typing_uninitialized_variables, depend_on_referenced_packages

import 'dart:async';
import 'dart:developer' as developer;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:restaurant_api/data/api/api_service.dart';
import 'package:restaurant_api/widgets/review_sent_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ReviewWidget extends StatefulWidget {
  final restaurantId;

  const ReviewWidget({super.key, required this.restaurantId});

  @override
  State<ReviewWidget> createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> subscription;

  TextEditingController nameController = TextEditingController();
  TextEditingController reviewController = TextEditingController();

  ApiService apiService = ApiService();

  String userName = '';
  String review = '';

  late FToast fToast;

  Future<void> initConnectivity() async {
    late ConnectivityResult result;

    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log("Couldn't check connectivity status", error: e);
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

  _showMyCustomToast(Color color, Icon icon, String text, ToastGravity gravity,
      Duration duration) {
    Widget toast = Container(
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: color,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: gravity,
      toastDuration: duration,
    );
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    fToast = FToast();
    fToast.init(context);

    subscription = Connectivity().onConnectivityChanged.listen((event) {
      setState(() {
        _connectionStatus = event;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
    nameController.dispose();
    reviewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('share your experience'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      content: SizedBox(
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Name :'),
            TextField(
              autofocus: true,
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Your Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onChanged: (value) {
                userName = value;
              },
            ),
            const SizedBox(
              height: 25,
            ),
            const Text('Review :'),
            Expanded(
              child: TextField(
                controller: reviewController,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: 'share your experience about this restaurant',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onChanged: (value) {
                  review = value;
                },
              ),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancelled', style: Theme
              .of(context)
              .textTheme
              .button
              ?.copyWith(color: Colors.blue),),
        ),
        TextButton(
          onPressed: () async {
            if (userName != '') {
              if (review != '') {
                ApiService()
                    .addReview(widget.restaurantId, userName, review)
                    .then((value) {
                  apiService = value as ApiService;
                });

                if (_connectionStatus != ConnectivityResult.none) {
                  Navigator.pop(context);
                  await showDialog(
                    context: context,
                    builder: (context) => ReviewSentDialogWidget(
                      restaurantId: widget.restaurantId,
                    ),
                  );
                } else {
                  _showMyCustomToast(
                    Colors.redAccent,
                    const Icon(Icons.error, color: Colors.black),
                    'Review failed\nCheck your internet connection',
                    ToastGravity.CENTER,
                    const Duration(seconds: 5),
                  );
                }
              } else {
                _showMyCustomToast(
                  Colors.redAccent,
                  const Icon(
                    Icons.warning_rounded,
                    color: Colors.black,
                  ),
                  'the review column cannot be empty',
                  ToastGravity.CENTER,
                  const Duration(seconds: 5),
                );
              }
            } else {
              _showMyCustomToast(
                Colors.redAccent,
                const Icon(
                  Icons.warning_rounded,
                  color: Colors.black,
                ),
                'The name and review fields cannot be empty',
                ToastGravity.CENTER,
                const Duration(seconds: 5),
              );
            }
          },
          child: Text('Send Review', style: Theme
              .of(context)
              .textTheme
              .button
              ?.copyWith(color: Colors.blue),),
        ),
      ],
    );
  }
}

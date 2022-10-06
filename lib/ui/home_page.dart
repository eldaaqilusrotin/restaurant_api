// ignore_for_file: non_constant_identifier_names
import 'dart:async';
import 'dart:io';
import 'dart:developer' as developer;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:restaurant_api/main.dart';
import 'package:restaurant_api/ui/detail_restaurant_page.dart';
import 'package:restaurant_api/ui/favorite_page.dart';
import 'package:restaurant_api/ui/restaurant_list_page.dart';
import 'package:restaurant_api/ui/search_page_restaurant.dart';
import 'package:restaurant_api/ui/settings_page.dart';
import 'package:restaurant_api/utils/notification_helper.dart';
import 'package:restaurant_api/widgets/platform_widget.dart';



class HomePage extends StatefulWidget {
  static const routeName = '/home_page';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NotificationHelper _notificationHelper = NotificationHelper();

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> subscription;

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

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);
    _notificationHelper.configureSelectNotificationSubject(
        context, DetailRestaurantPage.routeName);
    subscription = Connectivity().onConnectivityChanged.listen((event) {
      setState(() {
        _connectionStatus = event;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    selectNotificationSubject.close();
    subscription.cancel();
  }

  int _selectedIndex = 0;
  static const String _headlineText = 'Home';

  final List<Widget> _listWidget = const [
    RestaurantListPage(),
    FavoritePage(),
    SearchPageRestaurant(),
    SettingsPage(),
  ];

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      body: _listWidget[_selectedIndex],
      bottomNavigationBar: GNav(
        tabs: [
          GButton(icon: Platform.isIOS ? CupertinoIcons.home :
          Icons.home_outlined,
            text: _headlineText,
          ),
          GButton(icon: Platform.isIOS ? CupertinoIcons.heart :
          Icons.favorite_border,
            text: "favorite",
          ),
          GButton(icon: Platform.isIOS ? CupertinoIcons.search :
          Icons.search,
            text: SearchPageRestaurant.routeName,
          ),
          GButton(icon: Platform.isIOS ? CupertinoIcons.settings :
          Icons.settings_outlined,
            text: SettingsPage.settingsTitle,
          )
        ],
        selectedIndex: _selectedIndex,

        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return Scaffold(
      body: _listWidget[_selectedIndex],
      bottomNavigationBar: GNav(
        tabs: [
          GButton(icon: Platform.isIOS ? CupertinoIcons.home :
          Icons.home_outlined,
            text: _headlineText,
          ),
          GButton(icon: Platform.isIOS ? CupertinoIcons.heart :
          Icons.favorite_border,
            text: _headlineText,
          ),
          GButton(icon: Platform.isIOS ? CupertinoIcons.search :
          Icons.search,
            text: SearchPageRestaurant.routeName,
          ),
          GButton(icon: Platform.isIOS ? CupertinoIcons.settings :
          Icons.settings_outlined,
            text: SettingsPage.settingsTitle,
          )
        ],
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_connectionStatus != ConnectivityResult.none) {
      return PlatformWidget(
        androidBuilder: _buildAndroid,
        iosBuilder: _buildIos,
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
                  size: 50,
                  color: Colors.red,
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Anda tidak terhubung ke internet\nPeriksa koneksi internet Anda!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
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
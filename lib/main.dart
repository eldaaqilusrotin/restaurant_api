import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_api/providers/database_provider.dart';
import 'package:restaurant_api/providers/scheduling_provider.dart';
import 'package:restaurant_api/providers/settings_provider.dart';
import 'package:restaurant_api/ui/detail_restaurant_page.dart';
import 'package:restaurant_api/ui/home_page.dart';
import 'package:restaurant_api/utils/background_service.dart';
import 'package:restaurant_api/utils/notification_helper.dart';
import 'common/navigation.dart';
import 'common/style.dart';
import 'data/api/api_service.dart';
import 'data/database/database_helper.dart';
import 'providers/home_restaurant_provider.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'providers/search_provider.dart';
import 'ui/search_page_restaurant.dart';
import 'ui/splash_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();

  service.initializeIsolate();

  await AndroidAlarmManager.initialize();
  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
        ChangeNotifierProvider(
        create: (_) => RestaurantsProvider(apiService: ApiService()),
    ),

      ChangeNotifierProvider<SearchRestaurantsProvider>(
    create: (_) => SearchRestaurantsProvider(apiService: ApiService()),
    ),
          ChangeNotifierProvider<DatabaseProvider>(
            create: (context) =>
                DatabaseProvider(databaseHelper: DatabaseHelper()),
          ),
          ChangeNotifierProvider<SettingsProvider>(
            create: (context) => SettingsProvider(),
          ),
          ChangeNotifierProvider<SchedulingProvider>(
            create: (context) => SchedulingProvider(),
          ),
    ],
      child : MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant',
      theme:  ThemeData(
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: primaryColor,
              onPrimary: Colors.black,
              secondary: secondaryColor,
            ),
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: myTextTheme,
        appBarTheme: const AppBarTheme(elevation: 0),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: secondaryColor,
          unselectedItemColor: Colors.grey,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: secondaryColor,
            textStyle: const TextStyle(),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(0),
              ),
            ),
          ),
        ),
      ),
      navigatorKey: navigatorKey,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        HomePage.routeName: (context) => const HomePage(),
        DetailRestaurantPage.routeName: (context) => DetailRestaurantPage(
            id: ModalRoute.of(context)?.settings.arguments as String,
          ),
        SearchPageRestaurant.routeName: (context) => const SearchPageRestaurant(),
      }
      )
    );
  }
}

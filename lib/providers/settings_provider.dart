import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider() {
    loadNotificationSwitchCondition();
  }

  bool notificationSwitchCondition = false;
  static const String notificationSwitchKey = 'notification_switch';

  void loadNotificationSwitchCondition() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    notificationSwitchCondition =
        preferences.getBool(notificationSwitchKey) ?? false;
    notifyListeners();
  }

  void changeNotificationSwitchCondition(value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(notificationSwitchKey, value);
    loadNotificationSwitchCondition();
  }
}

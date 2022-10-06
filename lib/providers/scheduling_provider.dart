import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:restaurant_api/utils/background_service.dart';
import 'package:restaurant_api/utils/date_time_helper.dart';

class SchedulingProvider extends ChangeNotifier {
  bool _isScheduled = false;
  bool get isScheduled => _isScheduled;

  Future<bool> scheduledNotification(bool value) async {
    _isScheduled = value;
    if (_isScheduled) {
      print('Notification for restaurant recommendation is active');
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      print('Notification for restaurant recommendation is nonactive');
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}

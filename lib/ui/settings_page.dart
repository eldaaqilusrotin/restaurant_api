import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_api/providers/scheduling_provider.dart';
import 'package:restaurant_api/widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../providers/settings_provider.dart';

class SettingsPage extends StatelessWidget {
  static const String settingsTitle = 'Settings';

  const SettingsPage({Key? key}) : super(key: key);

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(settingsTitle),
      ),
      body: _buildList(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(settingsTitle),
      ),
      child: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView(
      children: [
        Material(
          child: ListTile(
            title: const Text('Dark Theme'),
            trailing: Switch.adaptive(
              value: false,
              onChanged: (value) {
                defaultTargetPlatform == TargetPlatform.iOS
                    ? showCupertinoDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: const Text('Coming Soon!'),
                      content:
                      const Text('This feature will be coming soon!'),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text('Ok'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                )
                    : showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Coming Soon!'),
                      content:
                      const Text('This feature will be coming soon!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Ok'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
        Consumer<SettingsProvider>(
          builder: (context, provider, child) {
            return ListTile(
              leading: const Icon(
                Icons.notifications,
                color: Colors.brown,
                size: 30,
              ),
              title: const Text(
                'Notifikasi rekomendasi restoran',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              trailing: Consumer<SchedulingProvider>(
                builder: (context, scheduled, child) {
                  return Switch.adaptive(
                    value: provider.notificationSwitchCondition,
                    onChanged: (value) async {
                      scheduled.scheduledNotification(value);
                      provider.changeNotificationSwitchCondition(value);
                      if (value == true) {
                        Fluttertoast.showToast(
                          msg: 'Rekomendasi diaktifkan',
                          gravity: ToastGravity.SNACKBAR,
                          backgroundColor: Colors.brown,
                          textColor: Colors.white,
                        );
                      }
                    },
                  );
                },
              ),
            );
          },
        ),
      ],

    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
import 'dart:async';
import 'dart:io';

import 'package:mixin_logger/mixin_logger.dart' as log;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationService {
  int id = 0;
  bool isEnabled = false;

  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  void init() {
    log.i('NotificationService.init');
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    isEnabled = true;
  }

  void disable() {
    log.i('NotificationService.disable');
    isEnabled = false;
  }

  Future<void> requestPermissions() async {
    log.i('NotificationService.requestPermissions');
    if (Platform.isMacOS) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  Future<void> showNotification(String body) async {
    log.i('NotificationService.showNotification isEnabled: $isEnabled');
    if (!isEnabled) {
      return;
    }
    const NotificationDetails notificationDetails = NotificationDetails(
      macOS: DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
      ),
    );
    await _flutterLocalNotificationsPlugin.show(
      id++,
      null,
      body,
      notificationDetails,
    );
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

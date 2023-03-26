import 'dart:async';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mixin_logger/mixin_logger.dart' as log;

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
    const notificationDetails = NotificationDetails(
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

/*
osascript -e 'tell application "Messages" to send "YOUR MESSAGE HERE" to buddy "RECIPIENT PHONE NUMBER OR EMAIL ADDRESS"
end tell'
*/

  Future<int> sendIMessage(String body, String recipient) async {
    final process = await Process.run(
      'osascript',
      [
        '-e',
        'tell application "Messages" to send "$body" to buddy "$recipient"'
      ],
    );
    if (process.exitCode != 0) {
      log.i('sendIMessage failed:');
    }
    return process.exitCode;
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

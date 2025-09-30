import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String notificationChannelId = '20_20_20_timer';
const String notificationChannelName = '20-20-20 Rule Timer';
const int timerNotificationId = 888;

class BackgroundServiceManager {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('launch_background'),
        iOS: DarwinInitializationSettings(),
      ),
    );

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: false,
        isForegroundMode: true,
        notificationChannelId: notificationChannelId,
        initialNotificationTitle: 'Eye Health Service',
        initialNotificationContent: 'Monitoring your screen time.',
        foregroundServiceNotificationId: timerNotificationId,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );
  }

  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    return true;
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("hello", "world");

    Timer.periodic(const Duration(minutes: 20), (timer) async {
      await _showBreakNotification();
    });
  }

  static Future<void> _showBreakNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      notificationChannelId,
      notificationChannelName,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      timerNotificationId,
      'Time for a 20-second eye break!',
      'Look at something 20 feet away to relax your eyes.',
      platformChannelSpecifics,
    );
  }

  static void startService() {
    final service = FlutterBackgroundService();
    service.startService();
  }

  static void stopService() {
    final service = FlutterBackgroundService();
    service.invoke("stopService");
  }
}

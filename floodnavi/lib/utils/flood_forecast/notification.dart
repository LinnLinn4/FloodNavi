import 'dart:typed_data';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'forecast_model.dart' as forecast;
import 'package:flutter/foundation.dart';

enum RiskLevel { low, medium, high, severe }

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();

  // Android channel IDs must be stable strings
  static const _channelId = 'flood_risk_alerts';
  static const _channelName = 'Flood Risk Alerts';
  static const _channelDesc = 'Notifications for high/severe flood risk';

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    // Android settings
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    final settings = InitializationSettings(android: android);
    await _plugin.initialize(settings);

    // Android 8+ channels
    const androidChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDesc,
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);

    // Android 13+ runtime permission (if you want to request it here)
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    _initialized = true;
  }

  Future<void> showRiskAlert({
    required forecast.RiskLevel level,
    required String title,
    required String body,
  }) async {
    // Choose sound + vibration based on level
    final isSevere = level == RiskLevel.severe;
    final androidSoundName = isSevere ? 'alert_severe' : 'alert_high';

    final vibration = isSevere
        ? Int64List.fromList([0, 800, 300, 1000, 300, 1200]) // buzzier
        : Int64List.fromList([0, 500, 250, 700]);

    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(androidSoundName),
      enableVibration: true,
      vibrationPattern: vibration,
      category: AndroidNotificationCategory.alarm,
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'alert.mp3',
    );

    final nDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      // use a random or timestamp-based id to avoid replacing old alerts
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      nDetails,
    );
  }
}

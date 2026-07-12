import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static const _morningId = 1001;
  static const _eveningId = 1002;

  static const _channelId = 'athkar_reminders';
  static const _channelName = 'AthkarReminders';
  static const _channelDesc = 'Daily morning and evening dhikr reminders';

  // ──────────────────────────────────────────────────
  // Initialisation
  // ──────────────────────────────────────────────────
  static Future<void> init() async {
    if (_initialized) return;

    // Timezone database must be initialised before scheduling
    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false, // we request manually below
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );

    _initialized = true;
  }

  // ──────────────────────────────────────────────────
  // Permission request  (call once, e.g. from Settings screen)
  // ──────────────────────────────────────────────────
  static Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.request();
      return status.isGranted;
    }
    if (Platform.isIOS) {
      final granted = await _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return granted ?? false;
    }
    return true;
  }

  // ──────────────────────────────────────────────────
  // Schedule / cancel reminders
  // ──────────────────────────────────────────────────
  static Future<void> scheduleReminders({
    required bool enabled,
    required String morningTime,
    required String eveningTime,
  }) async {
    if (!_initialized) await init();

    // Always cancel existing reminders first
    await _plugin.cancel(_morningId);
    await _plugin.cancel(_eveningId);

    if (!enabled) return;

    await _scheduleDailyNotification(
      id: _morningId,
      title: 'صباح الذكر 🌅',
      body: 'أصبحنا وأصبح الملك لله — ابدأ يومك بذكر الله',
      timeStr: morningTime,
    );

    await _scheduleDailyNotification(
      id: _eveningId,
      title: 'مساء الذكر 🌙',
      body: 'أمسينا وأمسى الملك لله — اختم يومك بذكر الله',
      timeStr: eveningTime,
    );
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  // ──────────────────────────────────────────────────
  // Internal helpers
  // ──────────────────────────────────────────────────
  static Future<void> _scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required String timeStr,
  }) async {
    final parsed = _parseTime(timeStr);
    if (parsed == null) return;

    final now = DateTime.now();
    var scheduled = DateTime(
      now.year,
      now.month,
      now.day,
      parsed.$1, // hour
      parsed.$2, // minute
    );

    // If the time has already passed today, start tomorrow
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    final tzScheduled = tz.TZDateTime.from(scheduled, tz.local);

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const notifDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        tzScheduled,
        notifDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      debugPrint('NotificationService: failed to schedule id=$id — $e');
    }
  }

  /// Parses "05:00 AM" / "08:30 PM" → (hour24, minute)
  static (int, int)? _parseTime(String timeStr) {
    try {
      final parts = timeStr.trim().split(' ');
      final timeParts = parts[0].split(':');
      var hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      final isPm = parts[1].toUpperCase() == 'PM';
      if (isPm && hour < 12) hour += 12;
      if (!isPm && hour == 12) hour = 0;
      return (hour, minute);
    } catch (_) {
      return null;
    }
  }
}

import 'dart:convert';

import 'package:athkar/core/constants/app_theme.dart';
import 'package:athkar/core/service/notification_service.dart';
import 'package:athkar/core/service/settings_storage.dart';
import 'package:athkar/core/service/statistics_storage.dart';
import 'package:athkar/fauther/statistics/controller/statistics_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  // Load once at field initialisation — no redundant reload in onInit()
  final settings = SettingsStorage.load().obs;

  // ──────────────────────────────────────────────────
  // Lifecycle
  // ──────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    // Sync any pending notifications to reflect stored settings on cold start
    _syncNotifications();
  }

  // ──────────────────────────────────────────────────
  // Theme
  // ──────────────────────────────────────────────────
  ThemeMode get materialThemeMode {
    switch (settings.value.themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }

  void setThemeMode(AppThemeMode mode) {
    settings.value = settings.value.copyWith(themeMode: mode);
    SettingsStorage.save(settings.value);
  }

  // ──────────────────────────────────────────────────
  // Interaction toggles
  // ──────────────────────────────────────────────────
  void toggleHaptic(bool value) {
    settings.value = settings.value.copyWith(hapticEnabled: value);
    SettingsStorage.save(settings.value);
    if (value) HapticFeedback.lightImpact();
  }

  void toggleSound(bool value) {
    settings.value = settings.value.copyWith(soundEnabled: value);
    SettingsStorage.save(settings.value);
  }

  void toggleBubbleEffect(bool value) {
    settings.value = settings.value.copyWith(bubbleEffectEnabled: value);
    SettingsStorage.save(settings.value);
  }

  // ──────────────────────────────────────────────────
  // Reminders (real notifications)
  // ──────────────────────────────────────────────────
  Future<void> toggleReminder(bool value) async {
    // استخدام SchedulerBinding لتأخير عرض Snackbar
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _showSnackbarIfPossible(
        title: value ? 'Reminders Enabled' : 'Reminders Disabled',
        message: value
            ? 'You will receive morning & evening dhikr reminders.'
            : 'Daily reminders have been turned off.',
        isError: false,
      );
    });

    // طلب الإذن أولاً
    if (value) {
      final granted = await NotificationService.requestPermission();
      if (!granted) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _showSnackbarIfPossible(
            title: 'Permission Denied',
            message:
                'Please allow notifications in your device settings to enable reminders.',
            isError: true,
          );
        });
        return; // don't toggle if permission was denied
      }
    }

    // تحديث الإعدادات
    settings.value = settings.value.copyWith(reminderEnabled: value);
    SettingsStorage.save(settings.value);

    // مزامنة الإشعارات
    await _syncNotifications();
  }

  Future<void> updateMorningTime(String time) async {
    settings.value = settings.value.copyWith(morningReminderTime: time);
    SettingsStorage.save(settings.value);
    await _syncNotifications();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _showSnackbarIfPossible(
        title: 'Updated',
        message: 'Morning reminder time updated to $time',
        isError: false,
      );
    });
  }

  Future<void> updateEveningTime(String time) async {
    settings.value = settings.value.copyWith(eveningReminderTime: time);
    SettingsStorage.save(settings.value);
    await _syncNotifications();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _showSnackbarIfPossible(
        title: 'Updated',
        message: 'Evening reminder time updated to $time',
        isError: false,
      );
    });
  }

  /// Pushes current settings into [NotificationService] so scheduled alarms
  /// always reflect what is stored on disk.
  Future<void> _syncNotifications() async {
    await NotificationService.scheduleReminders(
      enabled: settings.value.reminderEnabled,
      morningTime: settings.value.morningReminderTime,
      eveningTime: settings.value.eveningReminderTime,
    );
  }

  // ──────────────────────────────────────────────────
  // Data actions
  // ──────────────────────────────────────────────────

  /// Copies all statistics as pretty-printed JSON to the clipboard.
  Future<void> exportHistory() async {
    try {
      // استخدام SchedulerBinding لتأخير عرض Snackbar
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _showSnackbarIfPossible(
          title: 'Exporting...',
          message: 'Your statistics are being prepared for export.',
          isError: false,
        );
      });

      // جلب البيانات
      final stats = StatisticsStorage.load();
      final json = const JsonEncoder.withIndent('  ').convert(stats.toJson());

      // نسخ إلى الحافظة
      await Clipboard.setData(ClipboardData(text: json));

      // عرض رسالة نجاح
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _showSnackbarIfPossible(
          title: 'Exported ✓',
          message: 'Your statistics have been copied to the clipboard as JSON.',
          isError: false,
        );
      });
    } catch (e) {
      // عرض رسالة خطأ
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _showSnackbarIfPossible(
          title: 'Export Failed',
          message: 'An error occurred: ${e.toString()}',
          isError: true,
        );
      });
    }
  }

  void resetStatistics() {
    // التحقق من وجود سياق قبل عرض الحوار
    if (Get.context == null) {
      print('Cannot show dialog: No context available');
      return;
    }

    Get.dialog(
      AlertDialog(
        backgroundColor: AppTheme.surfaceContainerHigh,
        title: const Text(
          'Reset Statistics?',
          style: TextStyle(color: AppTheme.onSurface),
        ),
        content: const Text(
          'This will permanently delete all your dhikr statistics. Your dhikr library will not be affected.',
          style: TextStyle(color: AppTheme.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.find<StatisticsController>().resetStatistics();
              Get.back();

              // عرض رسالة نجاح بعد تأخير
              SchedulerBinding.instance.addPostFrameCallback((_) {
                _showSnackbarIfPossible(
                  title: 'Done',
                  message: 'Statistics have been reset.',
                  isError: false,
                );
              });
            },
            child: const Text(
              'Reset',
              style: TextStyle(color: AppTheme.error),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────
  // Helper method to safely show Snackbar
  // ──────────────────────────────────────────────────
  void _showSnackbarIfPossible({
    required String title,
    required String message,
    bool isError = false,
  }) {
    // التحقق من وجود السياق
    if (Get.context == null) {
      print('Cannot show snackbar: No context available');
      print('Title: $title, Message: $message');
      return;
    }

    // try {
    //   Get.snackbar(
    //     title,
    //     message,
    //     snackPosition: SnackPosition.BOTTOM,
    //     backgroundColor: isError
    //         ? Colors.red.withValues(alpha: 0.9)
    //         : AppTheme.surfaceContainerHigh,
    //     colorText: isError ? Colors.white : AppTheme.onSurface,
    //     margin: const EdgeInsets.all(16),
    //     duration: const Duration(seconds: 3),
    //     borderRadius: 12,
    //     icon: isError
    //         ? const Icon(Icons.error_outline, color: Colors.white)
    //         : const Icon(Icons.check_circle_outline, color: AppTheme.primary),
    //     shouldIconPulse: false,
    //     maxWidth: 400,
    //   );
    // } catch (e) {
    //   print('Error showing snackbar: $e');
    // }
  }

  // ──────────────────────────────────────────────────
  // Optional: Add a dispose method
  // ──────────────────────────────────────────────────
  @override
  void onClose() {
    // Clean up any resources if needed
    super.onClose();
  }
}

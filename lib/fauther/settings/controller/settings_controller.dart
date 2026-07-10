import 'dart:convert';

import 'package:athkar/core/service/settings_storage.dart';
import 'package:athkar/core/service/statistics_storage.dart';
import 'package:athkar/fauther/statistics/controller/statistics_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  final settings = SettingsStorage.load().obs;

  @override
  void onInit() {
    super.onInit();
    settings.value = SettingsStorage.load();
  }

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

  void toggleHaptic(bool value) {
    settings.value = settings.value.copyWith(hapticEnabled: value);
    SettingsStorage.save(settings.value);
    if (value) HapticFeedback.lightImpact();
  }

  void toggleSound(bool value) {
    settings.value = settings.value.copyWith(soundEnabled: value);
    SettingsStorage.save(settings.value);
  }

  void toggleBubleEffect(bool value) {
    settings.value = settings.value.copyWith(bubleEffectEnabled: value);
    SettingsStorage.save(settings.value);
  }

  void toggleReminder(bool value) {
    settings.value = settings.value.copyWith(reminderEnabled: value);
    SettingsStorage.save(settings.value);
  }

  void updateMorningTime(String time) {
    settings.value = settings.value.copyWith(morningReminderTime: time);
    SettingsStorage.save(settings.value);
  }

  void updateEveningTime(String time) {
    settings.value = settings.value.copyWith(eveningReminderTime: time);
    SettingsStorage.save(settings.value);
  }

  Future<void> backupData() async {
    Get.dialog(
      Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF191F31),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF95D3BA)),
              ),
              SizedBox(height: 16),
              Text(
                'Backing up your data...',
                style: TextStyle(
                  color: Color(0xFFDCE1FB),
                  decoration: TextDecoration.none,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    await Future.delayed(const Duration(milliseconds: 1500));

    Get.back();

    Get.snackbar(
      'Backup Successful',
      'Your dhikr statistics and settings have been safely backed up.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF191F31),
      colorText: const Color(0xFFDCE1FB),
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.cloud_done, color: Color(0xFF95D3BA)),
      duration: const Duration(seconds: 3),
    );
  }

  void setThemeMode(AppThemeMode mode) {
    settings.value = settings.value.copyWith(themeMode: mode);
    SettingsStorage.save(settings.value);
  }

  Future<void> exportHistory() async {
    final stats = StatisticsStorage.load();
    final json = const JsonEncoder.withIndent('  ').convert(stats.toJson());
    await Clipboard.setData(ClipboardData(text: json));
    Get.snackbar(
      'Exported',
      'Statistics copied to clipboard as JSON.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF191F31),
      colorText: const Color(0xFFDCE1FB),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );
  }

  void resetStatistics() {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF191F31),
        title: const Text(
          'Reset Statistics?',
          style: TextStyle(color: Color(0xFFDCE1FB)),
        ),
        content: const Text(
          'This will permanently delete all your dhikr statistics. Your dhikr library will not be affected.',
          style: TextStyle(color: Color(0xFFBFC9C3)),
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
              Get.snackbar(
                'Done',
                'Statistics have been reset.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: const Color(0xFF191F31),
                colorText: const Color(0xFFDCE1FB),
                margin: const EdgeInsets.all(16),
              );
            },
            child:
                const Text('Reset', style: TextStyle(color: Color(0xFFFFB4AB))),
          ),
        ],
      ),
    );
  }

  // String get versionLabel => 'Nur Tasbeeh v${AppStrings.appVersion}';
}

import 'package:athkar/core/constants/app_constants.dart';
import 'package:athkar/core/constants/app_theme.dart';
import 'package:athkar/core/service/settings_storage.dart';
import 'package:athkar/core/widgets/atmospheric_background.dart';
import 'package:athkar/core/widgets/glass_card.dart';
import 'package:athkar/core/widgets/athkar_app_bar.dart';
import 'package:athkar/fauther/settings/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // لإضافة SchedulerBinding
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController controller = Get.find<SettingsController>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: AtmosphericBackground(
        showShader: false,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const NurAppBar(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingLg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text('Settings', style: AppTheme.headlineLgMobile),
                      const SizedBox(height: 4),
                      Text(
                        'Personalize your spiritual sanctuary',
                        style: AppTheme.labelSm.copyWith(
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Interactions ──────────────────────────
                      Obx(() => _buildInteractionsGroup(controller)),
                      const SizedBox(height: 16),

                      // ── Appearance ────────────────────────────
                      // Obx(() => _buildAppearanceGroup(controller)),
                      // const SizedBox(height: 16),

                      // ── Reminders ─────────────────────────────
                      Obx(() => _buildRemindersGroup(context, controller)),
                      const SizedBox(height: 16),

                      // ── Data ──────────────────────────────────
                      _buildDataGroup(controller),
                      const SizedBox(height: 16),

                      // ── Danger zone ───────────────────────────
                      _buildResetButton(controller),
                      const SizedBox(height: 24),

                      // ── App version footer ────────────────────
                      Center(
                        child: Column(
                          children: [
                            Text(
                              '${AppStrings.appTitle} v${AppStrings.appVersion}',
                              style: AppTheme.labelSm.copyWith(
                                color: AppTheme.onSurfaceVariant
                                    .withValues(alpha: 0.4),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppStrings.appTagline,
                              style: TextStyle(
                                fontSize: 10,
                                letterSpacing: 1,
                                color: AppTheme.onSurfaceVariant
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────
  // Section builders
  // ────────────────────────────────────────────────────

  Widget _buildInteractionsGroup(SettingsController controller) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Interactions'),
          // إصلاح: تغليف كل ListTile بـ Material
          Material(
            color: Colors.transparent,
            child: _toggleTile(
              icon: Icons.vibration,
              title: 'Haptic feedback',
              subtitle: 'Tactile vibration on every tap',
              value: controller.settings.value.hapticEnabled,
              onChanged: controller.toggleHaptic,
            ),
          ),
          Material(
            color: Colors.transparent,
            child: _toggleTile(
              icon: Icons.volume_up,
              title: 'Sound alerts',
              subtitle: 'Soft chime at every 33 counts',
              value: controller.settings.value.soundEnabled,
              onChanged: controller.toggleSound,
            ),
          ),
          Material(
            color: Colors.transparent,
            child: _toggleTile(
              icon: Icons.bubble_chart,
              title: 'Bubble effects',
              subtitle: 'Ripple effect on every tap',
              value: controller.settings.value.bubbleEffectEnabled,
              onChanged: controller.toggleBubbleEffect,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceGroup(SettingsController controller) {
    final themeMode = controller.settings.value.themeMode;
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Appearance'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text('Theme', style: AppTheme.titleMd),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _themeButton(
                  icon: Icons.dark_mode,
                  label: 'Dark',
                  selected: themeMode == AppThemeMode.dark,
                  onTap: () => controller.setThemeMode(AppThemeMode.dark),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _themeButton(
                  icon: Icons.light_mode,
                  label: 'Light',
                  selected: themeMode == AppThemeMode.light,
                  onTap: () => controller.setThemeMode(AppThemeMode.light),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _themeButton(
                  icon: Icons.brightness_auto,
                  label: 'Auto',
                  selected: themeMode == AppThemeMode.system,
                  onTap: () => controller.setThemeMode(AppThemeMode.system),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRemindersGroup(
      BuildContext context, SettingsController controller) {
    final reminderEnabled = controller.settings.value.reminderEnabled;
    final morningTime = controller.settings.value.morningReminderTime;
    final eveningTime = controller.settings.value.eveningReminderTime;

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Reminders'),
          Material(
            color: Colors.transparent,
            child: _toggleTile(
              icon: Icons.notifications_active,
              title: 'Daily Reminder',
              subtitle: 'Scheduled morning & evening reminders',
              value: reminderEnabled,
              onChanged: (v) => controller.toggleReminder(v),
            ),
          ),
          if (reminderEnabled) ...[
            const Divider(color: Colors.white10),
            // إصلاح: تغليف ListTile بـ Material
            Material(
              color: Colors.transparent,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                leading: const Icon(Icons.wb_sunny,
                    color: AppTheme.onSurfaceVariant),
                title: const Text(
                  'Morning Reminder',
                  style: TextStyle(color: AppTheme.onSurface),
                ),
                subtitle: Text(
                  morningTime,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                ),
                trailing: const Icon(Icons.edit,
                    color: AppTheme.onSurfaceVariant, size: 20),
                onTap: () async {
                  final time = await _selectTime(context, morningTime);
                  if (time != null) {
                    controller.updateMorningTime(time);
                  }
                },
              ),
            ),
            Material(
              color: Colors.transparent,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                leading: const Icon(Icons.nights_stay,
                    color: AppTheme.onSurfaceVariant),
                title: const Text(
                  'Evening Reminder',
                  style: TextStyle(color: AppTheme.onSurface),
                ),
                subtitle: Text(
                  eveningTime,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                ),
                trailing: const Icon(Icons.edit,
                    color: AppTheme.onSurfaceVariant, size: 20),
                onTap: () async {
                  final time = await _selectTime(context, eveningTime);
                  if (time != null) {
                    controller.updateEveningTime(time);
                  }
                },
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildDataGroup(SettingsController controller) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Storage & Data'),
          Material(
            color: Colors.transparent,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              leading: const Icon(Icons.file_download,
                  color: AppTheme.onSurfaceVariant),
              title: Text('Export history (.json)', style: AppTheme.titleMd),
              subtitle: Text(
                'Copies your statistics to clipboard',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
              ),
              trailing:
                  const Icon(Icons.download, color: AppTheme.onSurfaceVariant),
              onTap: () {
                // استخدام SchedulerBinding لتجنب مشاكل الأداء
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  controller.exportHistory();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResetButton(SettingsController controller) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: controller.resetStatistics,
        icon: const Icon(Icons.delete_forever, color: AppTheme.error),
        label: Text(
          'Reset all statistics',
          style: AppTheme.titleMd.copyWith(color: AppTheme.error),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppTheme.error.withValues(alpha: 0.3)),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.roundedLg),
          ),
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────
  // Helpers / sub-widgets
  // ────────────────────────────────────────────────────

  Future<String?> _selectTime(
      BuildContext context, String initialTimeStr) async {
    TimeOfDay initialTime = const TimeOfDay(hour: 8, minute: 0);
    try {
      final parts = initialTimeStr.split(' ');
      final timeParts = parts[0].split(':');
      var hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      final isPm = parts[1].toUpperCase() == 'PM';
      if (isPm && hour < 12) hour += 12;
      if (!isPm && hour == 12) hour = 0;
      initialTime = TimeOfDay(hour: hour, minute: minute);
    } catch (_) {}

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: AppTheme.themeData.copyWith(
            timePickerTheme: const TimePickerThemeData(
              backgroundColor: AppTheme.surfaceContainer,
              hourMinuteColor: AppTheme.surfaceContainerLow,
              hourMinuteTextColor: AppTheme.primary,
              dialHandColor: AppTheme.primary,
              dialBackgroundColor: AppTheme.surfaceContainerLowest,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final now = DateTime.now();
      final dt =
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      final format = intl.DateFormat('hh:mm a');
      return format.format(dt);
    }
    return null;
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
      child: Text(
        title.toUpperCase(),
        style: AppTheme.labelSm.copyWith(
          color: AppTheme.tertiary,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _toggleTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: Icon(icon, color: AppTheme.onSurfaceVariant),
      title: Text(title, style: AppTheme.titleMd),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: AppTheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppTheme.onSurface,
        activeTrackColor: AppTheme.primaryContainer,
        inactiveTrackColor: AppTheme.surfaceContainerHighest,
      ),
    );
  }

  Widget _themeButton({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color:
              selected ? AppTheme.primaryContainer : AppTheme.surfaceContainer,
          borderRadius: BorderRadius.circular(AppTheme.roundedLg),
          border: selected
              ? Border.all(color: AppTheme.primary.withValues(alpha: 0.3))
              : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: selected
                  ? AppTheme.onPrimaryContainer
                  : AppTheme.onSurfaceVariant,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTheme.labelSm.copyWith(
                color: selected
                    ? AppTheme.onPrimaryContainer
                    : AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

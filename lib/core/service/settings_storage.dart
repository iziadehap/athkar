import 'package:get_storage/get_storage.dart';

enum AppThemeMode { dark, light, system }

class AppSettings {
  final bool hapticEnabled;
  final bool soundEnabled;
  final bool bubleEffectEnabled;
  final AppThemeMode themeMode;
  final bool reminderEnabled;
  final String morningReminderTime;
  final String eveningReminderTime;

  const AppSettings({
    this.hapticEnabled = true,
    this.soundEnabled = false,
    this.bubleEffectEnabled = false,
    this.themeMode = AppThemeMode.dark,
    this.reminderEnabled = true,
    this.morningReminderTime = '05:00 AM',
    this.eveningReminderTime = '08:00 PM',
  });

  AppSettings copyWith({
    bool? hapticEnabled,
    bool? soundEnabled,
    bool? bubleEffectEnabled,
    AppThemeMode? themeMode,
    bool? reminderEnabled,
    String? morningReminderTime,
    String? eveningReminderTime,
  }) {
    return AppSettings(
      hapticEnabled: hapticEnabled ?? this.hapticEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      bubleEffectEnabled: bubleEffectEnabled ?? this.bubleEffectEnabled,
      themeMode: themeMode ?? this.themeMode,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      morningReminderTime: morningReminderTime ?? this.morningReminderTime,
      eveningReminderTime: eveningReminderTime ?? this.eveningReminderTime,
    );
  }
}

class SettingsStorage {
  static final _box = GetStorage();
  static const _hapticKey = 'settings_haptic';
  static const _soundKey = 'settings_sound';
  static const _bubleEffectKey = 'settings_buble_effect';
  static const _themeKey = 'settings_theme';
  static const _reminderEnabledKey = 'settings_reminder_enabled';
  static const _morningReminderKey = 'settings_morning_reminder';
  static const _eveningReminderKey = 'settings_evening_reminder';

  static AppSettings load() {
    return AppSettings(
      hapticEnabled: _box.read<bool>(_hapticKey) ?? true,
      soundEnabled: _box.read<bool>(_soundKey) ?? false,
      bubleEffectEnabled: _box.read<bool>(_bubleEffectKey) ?? false,
      themeMode: AppThemeMode.values[
          (_box.read<int>(_themeKey) ?? AppThemeMode.dark.index)
              .clamp(0, AppThemeMode.values.length - 1)],
      reminderEnabled: _box.read<bool>(_reminderEnabledKey) ?? true,
      morningReminderTime: _box.read<String>(_morningReminderKey) ?? '05:00 AM',
      eveningReminderTime: _box.read<String>(_eveningReminderKey) ?? '08:00 PM',
    );
  }

  static void save(AppSettings settings) {
    _box.write(_hapticKey, settings.hapticEnabled);
    _box.write(_soundKey, settings.soundEnabled);
    _box.write(_bubleEffectKey, settings.bubleEffectEnabled);
    _box.write(_themeKey, settings.themeMode.index);
    _box.write(_reminderEnabledKey, settings.reminderEnabled);
    _box.write(_morningReminderKey, settings.morningReminderTime);
    _box.write(_eveningReminderKey, settings.eveningReminderTime);
  }
}

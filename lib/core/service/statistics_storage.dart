import 'dart:convert';

import 'package:get_storage/get_storage.dart';

class DailyStats {
  final int lifetimeTotal;
  final int currentStreak;
  final int bestStreak;
  final String? lastActiveDate;
  final Map<String, int> dailyCounts;

  const DailyStats({
    this.lifetimeTotal = 0,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.lastActiveDate,
    this.dailyCounts = const {},
  });

  factory DailyStats.fromJson(Map<String, dynamic> json) {
    final rawDaily = json['dailyCounts'];
    return DailyStats(
      lifetimeTotal: json['lifetimeTotal'] as int? ?? 0,
      currentStreak: json['currentStreak'] as int? ?? 0,
      bestStreak: json['bestStreak'] as int? ?? 0,
      lastActiveDate: json['lastActiveDate'] as String?,
      dailyCounts: rawDaily is Map
          ? rawDaily.map((k, v) => MapEntry(k.toString(), v as int? ?? 0))
          : {},
    );
  }

  Map<String, dynamic> toJson() => {
        'lifetimeTotal': lifetimeTotal,
        'currentStreak': currentStreak,
        'bestStreak': bestStreak,
        'lastActiveDate': lastActiveDate,
        'dailyCounts': dailyCounts,
      };

  DailyStats copyWith({
    int? lifetimeTotal,
    int? currentStreak,
    int? bestStreak,
    String? lastActiveDate,
    Map<String, int>? dailyCounts,
  }) {
    return DailyStats(
      lifetimeTotal: lifetimeTotal ?? this.lifetimeTotal,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      dailyCounts: dailyCounts ?? this.dailyCounts,
    );
  }
}

class StatisticsStorage {
  static final _box = GetStorage();
  static const _key = 'user_statistics';

  static DailyStats load() {
    final raw = _box.read<String>(_key);
    if (raw == null) return const DailyStats();
    return DailyStats.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  static void save(DailyStats stats) {
    _box.write(_key, jsonEncode(stats.toJson()));
  }

  static void reset() {
    _box.remove(_key);
  }
}

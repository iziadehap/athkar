import 'package:athkar/core/service/statistics_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StatisticsController extends GetxController {
  final stats = const DailyStats().obs;

  static const _weekdayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  void onInit() {
    super.onInit();
    stats.value = StatisticsStorage.load();
  }

  void recordTap() {
    final today = _todayKey();
    final current = stats.value;
    final updatedDaily = Map<String, int>.from(current.dailyCounts);
    updatedDaily[today] = (updatedDaily[today] ?? 0) + 1;

    final streak = _calculateStreak(updatedDaily, today);
    final best = streak > current.bestStreak ? streak : current.bestStreak;

    final updated = current.copyWith(
      lifetimeTotal: current.lifetimeTotal + 1,
      dailyCounts: updatedDaily,
      lastActiveDate: today,
      currentStreak: streak,
      bestStreak: best,
    );

    stats.value = updated;
    StatisticsStorage.save(updated);
  }

  void resetStatistics() {
    StatisticsStorage.reset();
    stats.value = const DailyStats();
  }

  String _todayKey() => DateFormat('yyyy-MM-dd').format(DateTime.now());

  int _calculateStreak(Map<String, int> daily, String today) {
    if ((daily[today] ?? 0) <= 0) return 0;

    var streak = 0;
    var date = DateTime.now();
    while (true) {
      final key = DateFormat('yyyy-MM-dd').format(date);
      if ((daily[key] ?? 0) > 0) {
        streak++;
        date = date.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  List<double> get weeklyActivityNormalized {
    final now = DateTime.now();
    final counts = List<int>.generate(7, (i) {
      final day = now.subtract(Duration(days: 6 - i));
      final key = DateFormat('yyyy-MM-dd').format(day);
      return stats.value.dailyCounts[key] ?? 0;
    });

    final maxCount = counts.fold<int>(0, (a, b) => a > b ? a : b);
    if (maxCount == 0) return List.filled(7, 0.0);

    return counts.map((c) => c / maxCount).toList();
  }

  /// The bar at index 6 is always today. todayIndex is therefore always 6.
  int get todayIndex => 6;

  /// Dynamic labels that match the actual dates shown in the bar chart.
  /// Index 0 = 6 days ago, index 6 = today.
  List<String> get dayLabels {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final day = now.subtract(Duration(days: 6 - i));
      return _weekdayLabels[day.weekday - 1];
    });
  }

  bool isAchievementUnlocked(String id) {
    final s = stats.value;
    switch (id) {
      case 'first_10k':
        return s.lifetimeTotal >= 10000;
      case 'weekly_pillar':
        return s.currentStreak >= 7;
      case '100_day_habit':
        return s.bestStreak >= 100;
      default:
        return false;
    }
  }

  String formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M'.replaceAll('.0M', 'M');
    }
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k'.replaceAll('.0k', 'k');
    }
    return '$count';
  }
}

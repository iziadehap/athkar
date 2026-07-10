import 'package:athkar/core/constants/app_theme.dart';
import 'package:athkar/core/widgets/atmospheric_background.dart';
import 'package:athkar/core/widgets/glass_card.dart';
import 'package:athkar/core/widgets/nur_app_bar.dart';
import 'package:athkar/fauther/statistics/controller/statistics_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final StatisticsController controller = Get.find<StatisticsController>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: AtmosphericBackground(
        showShader: false,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 120),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingLg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const NurAppBar(),
                  const SizedBox(height: 12),
                  Text('Your Journey', style: AppTheme.headlineLgMobile),
                  const SizedBox(height: 4),
                  Text(
                    'Consistent remembrance brings peace to the heart.',
                    style: AppTheme.labelSm.copyWith(
                      color: AppTheme.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Obx(() => _buildStreakCard(controller)),
                  const SizedBox(height: 16),
                  Obx(() => _buildMetricsRow(controller)),
                  const SizedBox(height: 32),
                  _buildWeeklySection(controller),
                  const SizedBox(height: 32),
                  _buildAchievements(controller),
                  const SizedBox(height: 32),
                  _buildQuoteCard(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStreakCard(StatisticsController controller) {
    final streak = controller.stats.value.currentStreak;
    return GlassCard(
      boxShadow: [
        BoxShadow(
          color: AppTheme.primaryContainer.withValues(alpha: 0.3),
          blurRadius: 40,
        ),
      ],
      child: Stack(
        children: [
          Positioned(
            right: -24,
            bottom: -24,
            child: Icon(
              Icons.local_fire_department,
              size: 120,
              color: AppTheme.primary.withValues(alpha: 0.1),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CURRENT STREAK',
                    style: AppTheme.labelSm.copyWith(
                      color: AppTheme.onSurfaceVariant,
                      letterSpacing: 1.5,
                    ),
                  ),
                  if (streak > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryContainer,
                        borderRadius:
                            BorderRadius.circular(AppTheme.roundedFull),
                      ),
                      child: Text(
                        'Active',
                        style: AppTheme.labelSm.copyWith(
                          color: AppTheme.onSurface,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                streak == 1 ? '1 Day Streak' : '$streak Day Streak',
                style: AppTheme.headlineLg.copyWith(color: AppTheme.primary),
              ),
              const SizedBox(height: 16),
              Row(
                children: List.generate(7, (index) {
                  final filled = index < streak.clamp(0, 7);
                  return Expanded(
                    child: Container(
                      height: 6,
                      margin: EdgeInsets.only(right: index < 6 ? 6 : 0),
                      decoration: BoxDecoration(
                        color: filled
                            ? AppTheme.primary
                            : AppTheme.surfaceContainerHighest
                                .withValues(alpha: 0.5),
                        borderRadius:
                            BorderRadius.circular(AppTheme.roundedFull),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsRow(StatisticsController controller) {
    final stats = controller.stats.value;
    return Row(
      children: [
        Expanded(
          child: GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lifetime Total',
                  style: AppTheme.labelSm.copyWith(
                    color: AppTheme.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  controller.formatCount(stats.lifetimeTotal),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.tertiary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Dhikr count',
                  style: AppTheme.labelSm.copyWith(
                    color: AppTheme.onSurfaceVariant.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Best Streak',
                  style: AppTheme.labelSm.copyWith(
                    color: AppTheme.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stats.bestStreak == 1
                      ? '1 Day'
                      : '${stats.bestStreak} Days',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Personal record',
                  style: AppTheme.labelSm.copyWith(
                    color: AppTheme.onSurfaceVariant.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklySection(StatisticsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Weekly Activity',
              style: AppTheme.titleMd.copyWith(color: AppTheme.onSurface),
            ),
            Text(
              'Last 7 days',
              style: AppTheme.labelSm.copyWith(
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          final activity = controller.weeklyActivityNormalized;
          final todayIdx = controller.todayIndex;
          return GlassCard(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              height: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (index) {
                  return _buildBarChartColumn(
                    controller.dayLabels[index],
                    activity[index],
                    index == todayIdx,
                  );
                }),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildAchievements(StatisticsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Achievements',
          style: AppTheme.titleMd.copyWith(color: AppTheme.onSurface),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              Obx(() => _buildAchievementBadge(
                    Icons.workspace_premium,
                    'First 10k',
                    AppTheme.tertiaryContainer,
                    AppTheme.onTertiaryContainer,
                    controller.isAchievementUnlocked('first_10k') ? 1.0 : 0.4,
                  )),
              Obx(() => _buildAchievementBadge(
                    Icons.calendar_month,
                    'Weekly Pillar',
                    AppTheme.primaryContainer,
                    AppTheme.primary,
                    controller.isAchievementUnlocked('weekly_pillar')
                        ? 1.0
                        : 0.4,
                  )),
              Obx(() => _buildAchievementBadge(
                    Icons.auto_awesome,
                    '100 Day Habit',
                    AppTheme.surfaceContainerHighest,
                    AppTheme.outline,
                    controller.isAchievementUnlocked('100_day_habit')
                        ? 1.0
                        : 0.4,
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuoteCard() {
    return GlassCard(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ',
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: AppTheme.fontAmiri,
                fontSize: 22,
                color: AppTheme.tertiary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '"Verily, in the remembrance of Allah do hearts find rest."',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTheme.fontInter,
                fontSize: 16,
                color: AppTheme.onSurfaceVariant.withValues(alpha: 0.8),
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "— Surah Ar-Ra'd [13:28]",
              style: AppTheme.labelSm.copyWith(
                color: AppTheme.onSurfaceVariant.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChartColumn(String label, double scaleHeight, bool isToday) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 14,
                    height: (constraints.maxHeight * scaleHeight).clamp(4.0, constraints.maxHeight),
                    decoration: BoxDecoration(
                      color: isToday
                          ? AppTheme.primary
                          : AppTheme.primary.withValues(alpha: 0.4),
                      borderRadius:
                          BorderRadius.circular(AppTheme.roundedFull),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: AppTheme.labelSm.copyWith(
              color: isToday
                  ? AppTheme.primary
                  : AppTheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementBadge(
    IconData icon,
    String title,
    Color bgColor,
    Color iconColor,
    double opacity,
  ) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: 110,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLow.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(AppTheme.roundedLg * 1.5),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: bgColor),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.labelSm.copyWith(
                color: AppTheme.onSurface,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

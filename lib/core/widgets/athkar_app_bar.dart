import 'package:athkar/core/constants/app_constants.dart';
import 'package:athkar/core/constants/app_theme.dart';
import 'package:athkar/fauther/statistics/controller/statistics_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NurAppBar extends StatelessWidget {
  final VoidCallback? onStreakTap;
  // final bool showStreakCount;

  const NurAppBar({
    super.key,
    this.onStreakTap,
    // this.showStreakCount = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingLg,
        vertical: AppTheme.spacingSm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              // Container(
              //   width: 40,
              //   height: 40,
              //   decoration: BoxDecoration(
              //     shape: BoxShape.circle,
              //     border: Border.all(
              //       color: AppTheme.primary.withValues(alpha: 0.3),
              //       width: 2,
              //     ),
              //     color: AppTheme.surfaceContainer,
              //   ),
              //   child: ClipRRect(
              //     borderRadius: BorderRadius.circular(20),
              //     child: Image.network(
              //       'https://lh3.googleusercontent.com/aida-public/AB6AXuBAN27Z0qJ1w2YrY7AAxfiMBSYFWq0M91FxgyU-LqGDRr2IUyGOmrQxEE_xVtXF24db53SIn-PCs94k4m5U0f6PLTt1h3pWFiMjn0dIxQZDLaNcqHlaFCLzPXECMfwsIN8dxfVqmf__ofFTktNVq2W-ElqSS4-ECuzpv-91E7LY8PAsXTyXHQwJ25E2pSnTiL3a6rRu-UuoCmnzutgFU-rYzj_qVEEGihRyeirwOfY81bxCfh9P4H4nw4vXfPb45QAij5mvN7wCJc0',
              //       fit: BoxFit.cover,
              //       errorBuilder: (context, error, stackTrace) => const Icon(
              //         Icons.spa_outlined,
              //         color: AppTheme.primary,
              //         size: 22,
              //       ),
              //     ),
              //   ),
              // ),
              // const SizedBox(width: 12),
              Text(
                AppStrings.appTitle,
                style: TextStyle(
                  // fontFamily: AppTheme.fontAmiri,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.tertiary,
                ),
              ),
            ],
          ),
          // if (showStreakCount)
          Obx(() {
            final streak =
                Get.find<StatisticsController>().stats.value.currentStreak;
            return Row(
              children: [
                const Icon(
                  Icons.local_fire_department,
                  color: AppTheme.tertiary,
                ),
                const SizedBox(width: 4),
                Text(
                  '$streak',
                  style: AppTheme.headlineLgMobile.copyWith(
                    color: AppTheme.tertiary,
                  ),
                ),
              ],
            );
          })
          // else
          //   IconButton(
          //     icon: const Icon(
          //       Icons.local_fire_department,
          //       color: AppTheme.primary,
          //     ),
          //     onPressed: onStreakTap,
          //   ),
        ],
      ),
    );
  }
}

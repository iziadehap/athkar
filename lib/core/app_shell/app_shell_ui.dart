import 'package:athkar/core/app_shell/app_shell_controller.dart';
import 'package:athkar/core/constants/app_theme.dart';
import 'package:athkar/fauther/home/ui/home_screen.dart';
import 'package:athkar/fauther/library/ui/dhikr_library_screen.dart';
import 'package:athkar/fauther/statistics/ui/statistics_screen.dart';
import 'package:athkar/fauther/settings/ui/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppShell extends StatelessWidget {
  const AppShell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NavigationController controller = Get.put(NavigationController());
    final List<IconData> navigationIcons = [
      Icons.fingerprint,
      Icons.menu_book,
      Icons.leaderboard,
      Icons.settings,
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      // Extend body to allow content to elegantly layer underneath the glass navbar
      extendBody: true,
      body: PageView(
        controller: controller.pageController,
        onPageChanged: controller.onPageChanged,
        physics: const BouncingScrollPhysics(),
        children: const [
          TasbeehHomeScreen(),
          // Center(
          //     child: Text('Select',
          //         style: TextStyle(color: Colors.white, fontSize: 24))),
          DhikrLibraryScreen(),
          StatisticsScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: Obx(() {
        final activeIndex = controller.currentIndex.value;

        return SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: Container(
              height: 76,
              decoration: BoxDecoration(
                color: AppTheme.glassBackground.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(AppTheme.roundedFull),
                border: Border.all(
                    color: AppTheme.glassBorder.withValues(alpha: 0.5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final totalWidth = constraints.maxWidth;
                  final itemWidth = totalWidth / navigationIcons.length;

                  return Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      // Sliding Active Background Indicator Pill
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOutBack, // Playful springy effect
                        left: activeIndex * itemWidth + (itemWidth - 56) / 2,
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: activeIndex == 0
                                ? AppTheme.primaryFixed
                                : AppTheme.primaryContainer,
                            boxShadow: [
                              BoxShadow(
                                color: activeIndex == 0
                                    ? const Color(0x6695D3BA)
                                    : AppTheme.primary.withValues(alpha: 0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Navigation Interactive Icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children:
                            List.generate(navigationIcons.length, (index) {
                          final isSelected = activeIndex == index;
                          final isHomeButton = index == 0;

                          return SizedBox(
                            width: itemWidth,
                            height: 76,
                            child: _buildBottomIcon(
                              icon: navigationIcons[index],
                              isSelected: isSelected,
                              isHomeButton: isHomeButton,
                              onTap: () => controller.animateToPage(index),
                            ),
                          );
                        }),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBottomIcon({
    required IconData icon,
    required bool isSelected,
    required bool isHomeButton,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: AnimatedScale(
          scale: isSelected ? 1.15 : 1.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutBack,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(
                scale: animation,
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: Icon(
              icon,
              key: ValueKey<String>('${icon.codePoint}_$isSelected'),
              size: 26,
              color: isSelected
                  ? (isHomeButton
                      ? AppTheme.onPrimaryFixed
                      : AppTheme.onSurface)
                  : AppTheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
          ),
        ),
      ),
    );
  }
}

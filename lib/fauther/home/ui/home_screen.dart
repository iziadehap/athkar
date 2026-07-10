import 'package:athkar/core/constants/app_constants.dart';
import 'package:athkar/core/constants/app_theme.dart';
import 'package:athkar/core/widgets/atmospheric_background.dart';
import 'package:athkar/core/widgets/nur_app_bar.dart';
import 'package:athkar/fauther/home/controller/tasbeeh_controller.dart';
import 'package:athkar/fauther/settings/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import 'package:get/get.dart';

class TasbeehHomeScreen extends StatefulWidget {
  const TasbeehHomeScreen({super.key});

  @override
  State<TasbeehHomeScreen> createState() => _TasbeehHomeScreenState();
}

class _TasbeehHomeScreenState extends State<TasbeehHomeScreen> {
  final TasbeehController controller = Get.find<TasbeehController>();
  late final ConfettiController _confettiController;
  late final Worker _completionWorker;
  @override
  void initState() {
    super.initState();

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));

    _completionWorker = ever(
      controller.completionEvent,
      (_) => _confettiController.play(),
    );
  }

  @override
  void dispose() {
    _completionWorker.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: AtmosphericBackground(
        child: SafeArea(
          child: Stack(
            children: [
              NurAppBar(onStreakTap: controller.resetAll),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingLg,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Container(
                      //   padding: const EdgeInsets.symmetric(
                      //     horizontal: AppTheme.spacingMd,
                      //     vertical: 4,
                      //   ),
                      //   decoration: BoxDecoration(
                      //     color:
                      //         AppTheme.primaryContainer.withValues(alpha: 0.4),
                      //     borderRadius:
                      //         BorderRadius.circular(AppTheme.roundedFull),
                      //     border: Border.all(
                      //       color: AppTheme.primary.withValues(alpha: 0.2),
                      //     ),
                      //   ),
                      //   child: Text(
                      //     AppStrings.activeSession,
                      //     style: AppTheme.labelSm.copyWith(
                      //       letterSpacing: 2,
                      //       color: AppTheme.primary,
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: AppTheme.spacingLg),
                      Obx(() {
                        final activeItem = controller.selectedAthkar.value ??
                            (controller.athkarList.isNotEmpty
                                ? controller.athkarList[0]
                                : null);

                        if (activeItem == null) {
                          return Text(
                            'No Athkar Available',
                            style: AppTheme.bodyLg.copyWith(
                              color: AppTheme.onSurfaceVariant,
                            ),
                          );
                        }

                        return Column(
                          children: [
                            Text(
                              activeItem.arThekr,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              style: AppTheme.displayArabic.copyWith(
                                fontSize: 36,
                                shadows: const [
                                  Shadow(
                                    color: Color(0x3395D3BA),
                                    blurRadius: 12,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacingSm),
                            Text(
                              activeItem.enThekr,
                              style: AppTheme.titleMd.copyWith(
                                color: AppTheme.secondary,
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacingXs),
                            Text(
                              activeItem.enThekrMean.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: AppTheme.labelSm.copyWith(
                                color: AppTheme.onSurfaceVariant
                                    .withValues(alpha: 0.7),
                                fontStyle: FontStyle.italic,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        );
                      }),

                      const SizedBox(height: AppTheme.spacingXxl),
                      const GesturefulTapZone(
                          // enableFeedback: false,
                          ),
                      const SizedBox(height: AppTheme.spacingXxl),
                      Obx(() {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              controller.athkarList.length,
                              (index) {
                                final currentItem =
                                    controller.athkarList[index];
                                final isSelected = controller
                                            .selectedAthkar.value ==
                                        currentItem ||
                                    (controller.selectedAthkar.value == null &&
                                        index == 0);

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  child: ChoiceChip(
                                    label: Text(currentItem.enThekr),
                                    selected: isSelected,
                                    onSelected: (_) =>
                                        controller.selectThekr(index),
                                    selectedColor: AppTheme.primaryContainer,
                                    backgroundColor: Colors.transparent,
                                    labelStyle: AppTheme.labelSm.copyWith(
                                      color: isSelected
                                          ? AppTheme.primaryFixed
                                          : AppTheme.onSurfaceVariant
                                              .withValues(alpha: 0.7),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          AppTheme.roundedFull),
                                      side: BorderSide(
                                        color: isSelected
                                            ? AppTheme.primary
                                                .withValues(alpha: 0.3)
                                            : Colors.white10,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: IgnorePointer(
                  child: ConfettiWidget(
                    canvas: MediaQuery.of(context).size,
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    emissionFrequency: 0.05,
                    numberOfParticles: 25,
                    gravity: 0.15,
                    shouldLoop: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GesturefulTapZone extends StatefulWidget {
  // final bool enableFeedback;

  const GesturefulTapZone({
    super.key,
    // this.enableFeedback = true,
  });

  @override
  State<GesturefulTapZone> createState() => _GesturefulTapZoneState();
}

class _GesturefulTapZoneState extends State<GesturefulTapZone> {
  final List<_RippleData> _ripples = [];
  final SettingsController settingsController = Get.find<SettingsController>();
  bool get enableFeedback =>
      settingsController.settings.value.bubleEffectEnabled;

  void _onTap(TapDownDetails details, TasbeehController controller) {
    if (settingsController.settings.value.bubleEffectEnabled) {
      final box = context.findRenderObject() as RenderBox?;
      if (box == null) return;

      final local = box.globalToLocal(details.globalPosition);

      setState(() {
        _ripples.add(
          _RippleData(
            offset: local,
            key: UniqueKey(),
          ),
        );
      });
    }

    controller.tap();
  }

  void _removeRipple(Key key) {
    if (!mounted) return;
    setState(() => _ripples.removeWhere((r) => r.key == key));
  }

  @override
  Widget build(BuildContext context) {
    final TasbeehController controller = Get.find<TasbeehController>();

    return Column(
      children: [
        GestureDetector(
          onTapDown: (d) => _onTap(d, controller),
          behavior: HitTestBehavior.opaque,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              /// Progress Ring
              Obx(() {
                final activeItem = controller.selectedAthkar.value ??
                    (controller.athkarList.isNotEmpty
                        ? controller.athkarList.first
                        : null);

                double fraction = 0.0;

                if (activeItem != null && activeItem.reps > 0) {
                  fraction = controller.currentCount.value / activeItem.reps;
                }

                return SizedBox(
                  width: 280,
                  height: 280,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(
                      end: fraction.clamp(0.0, 1.0),
                    ),
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return CustomPaint(
                        painter: ProgressRingPainter(
                          progressPercentage: value,
                          activeColor: AppTheme.tertiary,
                        ),
                      );
                    },
                  ),
                );
              }),

              /// Center Circle
              Container(
                width: 224,
                height: 224,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.surfaceContainerLow.withValues(alpha: 0.4),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// Animated Counter
                    Obx(() {
                      final count = controller.currentCount.value;

                      return AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 150),
                        style: AppTheme.headlineLg.copyWith(
                          fontSize: 64,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.onSurface,
                        ),
                        child: Text(
                          '$count',
                          key: ValueKey(count),
                        )
                            .animate(
                              key: ValueKey(
                                count,
                              ), // Restart animation on every count change
                            )
                            .scale(
                              begin: const Offset(0.85, 0.85),
                              end: const Offset(1.12, 1.12),
                              duration: 120.ms,
                              curve: Curves.easeOutBack,
                            )
                            .then(duration: 80.ms)
                            .scale(
                              begin: const Offset(1.12, 1.12),
                              end: const Offset(1.0, 1.0),
                              curve: Curves.easeInOut,
                            ),
                      );
                    }),

                    Obx(() {
                      final activeItem = controller.selectedAthkar.value ??
                          (controller.athkarList.isNotEmpty
                              ? controller.athkarList.first
                              : null);

                      return Text(
                        '/ ${activeItem?.reps ?? 33}',
                        style: AppTheme.labelSm.copyWith(
                          color: AppTheme.onSurfaceVariant,
                        ),
                      );
                    }),
                  ],
                ),
              ),

              /// Ripple Effect
              ..._ripples.map(
                (ripple) => _TapRipple(
                  key: ripple.key,
                  offset: ripple.offset,
                  onComplete: () => _removeRipple(ripple.key),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.touch_app,
              size: 16,
              color: AppTheme.onSurfaceVariant.withValues(alpha: 0.4),
            ),
            const SizedBox(width: 8),
            Text(
              AppStrings.tapToCount,
              style: AppTheme.labelSm.copyWith(
                color: AppTheme.onSurfaceVariant.withValues(alpha: 0.4),
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RippleData {
  final Offset offset;
  final Key key;

  _RippleData({required this.offset, required this.key});
}

class _TapRipple extends StatefulWidget {
  final Offset offset;
  final VoidCallback onComplete;

  const _TapRipple({
    super.key,
    required this.offset,
    required this.onComplete,
  });

  @override
  State<_TapRipple> createState() => _TapRippleState();
}

class _TapRippleState extends State<_TapRipple>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = _controller.value * 4;
        final opacity = 1.0 - _controller.value;
        return Positioned(
          left: widget.offset.dx - 70,
          top: widget.offset.dy - 70,
          child: Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: opacity.clamp(0.0, 1.0),
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primary.withValues(alpha: 0.4),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ProgressRingPainter extends CustomPainter {
  final double progressPercentage;
  final Color activeColor;

  const ProgressRingPainter({
    required this.progressPercentage,
    required this.activeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 10;

    final backgroundPaint = Paint()
      ..color = AppTheme.surfaceContainerHighest.withValues(alpha: 0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final foregroundPaint = Paint()
      ..color = activeColor
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, backgroundPaint);

    const startAngle = -3.141592653589793 / 2;
    final sweepAngle = 2 * 3.141592653589793 * progressPercentage;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant ProgressRingPainter oldDelegate) {
    return oldDelegate.progressPercentage != progressPercentage ||
        oldDelegate.activeColor != activeColor;
  }
}

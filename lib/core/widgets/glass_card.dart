import 'package:athkar/core/constants/app_theme.dart';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Border? border;
  final List<BoxShadow>? boxShadow;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.border,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppTheme.roundedLg * 1.5),
        border: border ??
            Border.all(color: Colors.white.withValues(alpha: 0.05)),
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }
}

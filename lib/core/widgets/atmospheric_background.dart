import 'package:athkar/core/constants/app_theme.dart';
import 'package:flutter/material.dart';

class AtmosphericBackground extends StatelessWidget {
  final Widget child;
  final bool showShader;

  const AtmosphericBackground({
    super.key,
    required this.child,
    this.showShader = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (showShader)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.3, -0.2),
                  radius: 1.5,
                  colors: [
                    Color(0xFF02261E),
                    Color(0xFF01141A),
                    AppTheme.background,
                  ],
                ),
              ),
            ),
          ),
        Positioned(
          top: -50,
          right: -50,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryContainer.withValues(alpha: 0.15),
            ),
          ),
        ),
        Positioned(
          bottom: 100,
          left: -50,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.tertiary.withValues(alpha: 0.08),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

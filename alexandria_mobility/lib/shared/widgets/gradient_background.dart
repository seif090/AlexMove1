import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final LinearGradient? gradient;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;

  const GradientBackground({
    super.key,
    required this.child,
    this.gradient,
    this.padding,
    this.alignment,
  });

  const GradientBackground.primary({
    super.key,
    required this.child,
    this.padding,
    this.alignment,
  }) : gradient = AppColors.primaryGradient;

  const GradientBackground.dark({
    super.key,
    required this.child,
    this.padding,
    this.alignment,
  }) : gradient = AppColors.darkGradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      alignment: alignment,
      decoration: BoxDecoration(
        gradient: gradient ?? AppColors.primaryGradient,
      ),
      child: child,
    );
  }
}

class GradientCard extends StatelessWidget {
  final Widget child;
  final LinearGradient? gradient;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final VoidCallback? onTap;

  const GradientCard({
    super.key,
    required this.child,
    this.gradient,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 16,
    this.onTap,
  });

  const GradientCard.primary({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 16,
    this.onTap,
  }) : gradient = AppColors.primaryGradient;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: gradient ?? AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }

    return card;
  }
}

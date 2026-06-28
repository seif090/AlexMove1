import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';

class AppCard extends ConsumerWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final double? elevation;
  final Color? backgroundColor;
  final Border? border;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = 16,
    this.elevation,
    this.backgroundColor,
    this.border,
    this.onTap,
    this.width,
    this.height,
  });

  const AppCard.elevated({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = 16,
    this.backgroundColor,
    this.onTap,
    this.width,
    this.height,
  })  : elevation = 2,
        border = null;

  const AppCard.bordered({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = 16,
    this.backgroundColor,
    this.onTap,
    this.width,
    this.height,
  })  : elevation = 0,
        border = const Border.fromBorderSide(
          BorderSide(color: AppColors.lightBorder, width: 1),
        );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final card = Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.lightSurface,
        borderRadius: BorderRadius.circular(borderRadius ?? 16),
        border: border ??
            Border.all(
              color: AppColors.lightBorder,
              width: 1,
            ),
        boxShadow: elevation != null && elevation! > 0
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: (elevation ?? 2) * 4,
                  offset: Offset(0, (elevation ?? 2) * 2),
                ),
              ]
            : null,
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }

    return card;
  }
}

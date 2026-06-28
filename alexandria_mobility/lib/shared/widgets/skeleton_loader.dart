import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final bool isCircular;

  const SkeletonLoader({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = 8,
    this.isCircular = false,
  });

  const SkeletonLoader.circle({
    super.key,
    required double size,
  })  : width = size,
        height = size,
        borderRadius = 999,
        isCircular = true;

  const SkeletonLoader.avatar({
    super.key,
    double size = 48,
  })  : width = size,
        height = size,
        borderRadius = 999,
        isCircular = true;

  const SkeletonLoader.text({
    super.key,
    double? width,
    this.height = 16,
  })  : width = width ?? double.infinity,
        borderRadius = 8,
        isCircular = false;

  const SkeletonLoader.card({
    super.key,
    this.width = double.infinity,
    this.height = 120,
  })  : borderRadius = 16,
        isCircular = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(isCircular ? 999 : borderRadius),
      ),
    );
  }
}

class SkeletonBookingCard extends StatelessWidget {
  const SkeletonBookingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.lightBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SkeletonLoader.circle(size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SkeletonLoader.text(width: 120),
                      const SizedBox(height: 6),
                      const SkeletonLoader.text(width: 80, height: 12),
                    ],
                  ),
                ),
                const SkeletonLoader(width: 60, height: 24, borderRadius: 12),
              ],
            ),
            const SizedBox(height: 16),
            const SkeletonLoader(height: 2, borderRadius: 4),
            const SizedBox(height: 16),
            Row(
              children: [
                const SkeletonLoader(width: 80, height: 16),
                const Spacer(),
                const SkeletonLoader(width: 60, height: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SkeletonGroupCard extends StatelessWidget {
  const SkeletonGroupCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.lightBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SkeletonLoader.text(width: 140),
                      const SizedBox(height: 6),
                      const SkeletonLoader.text(width: 100, height: 12),
                    ],
                  ),
                ),
                const SkeletonLoader(width: 50, height: 24, borderRadius: 12),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const SkeletonLoader(width: 80, height: 28, borderRadius: 8),
                const SizedBox(width: 8),
                const SkeletonLoader(width: 80, height: 28, borderRadius: 8),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const SkeletonLoader(width: 80, height: 28, borderRadius: 8),
                const SizedBox(width: 8),
                const SkeletonLoader(width: 80, height: 28, borderRadius: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

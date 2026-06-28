import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final double topPadding;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.topPadding = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding, left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.local_taxi_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
              color: AppColors.lightOnSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 15,
              fontFamily: 'Cairo',
              color: AppColors.lightOnSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

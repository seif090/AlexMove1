import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

enum BadgeVariant { success, warning, danger, info, primary, neutral }

class StatusBadge extends StatelessWidget {
  final String label;
  final BadgeVariant variant;
  final bool showDot;
  final double? fontSize;

  const StatusBadge({
    super.key,
    required this.label,
    this.variant = BadgeVariant.primary,
    this.showDot = true,
    this.fontSize = 12,
  });

  const StatusBadge.success({
    super.key,
    required this.label,
    this.showDot = true,
    this.fontSize = 12,
  }) : variant = BadgeVariant.success;

  const StatusBadge.warning({
    super.key,
    required this.label,
    this.showDot = true,
    this.fontSize = 12,
  }) : variant = BadgeVariant.warning;

  const StatusBadge.danger({
    super.key,
    required this.label,
    this.showDot = true,
    this.fontSize = 12,
  }) : variant = BadgeVariant.danger;

  const StatusBadge.info({
    super.key,
    required this.label,
    this.showDot = true,
    this.fontSize = 12,
  }) : variant = BadgeVariant.info;

  Color get _backgroundColor {
    switch (variant) {
      case BadgeVariant.success:
        return AppColors.successLight;
      case BadgeVariant.warning:
        return AppColors.warningLight;
      case BadgeVariant.danger:
        return AppColors.dangerLight;
      case BadgeVariant.info:
        return AppColors.infoLight;
      case BadgeVariant.primary:
        return AppColors.primaryLight;
      case BadgeVariant.neutral:
        return AppColors.surfaceContainerLow;
    }
  }

  Color get _textColor {
    switch (variant) {
      case BadgeVariant.success:
        return AppColors.success;
      case BadgeVariant.warning:
        return AppColors.warning;
      case BadgeVariant.danger:
        return AppColors.danger;
      case BadgeVariant.info:
        return AppColors.info;
      case BadgeVariant.primary:
        return AppColors.primary;
      case BadgeVariant.neutral:
        return AppColors.lightOnSurfaceVariant;
    }
  }

  Color get _dotColor {
    switch (variant) {
      case BadgeVariant.success:
        return AppColors.success;
      case BadgeVariant.warning:
        return AppColors.warning;
      case BadgeVariant.danger:
        return AppColors.danger;
      case BadgeVariant.info:
        return AppColors.info;
      case BadgeVariant.primary:
        return AppColors.primary;
      case BadgeVariant.neutral:
        return AppColors.lightOnSurfaceVariant;
    }
  }

  static BadgeVariant fromStatus(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'completed':
      case 'confirmed':
      case 'paid':
      case 'approved':
        return BadgeVariant.success;
      case 'pending':
      case 'scheduled':
      case 'inprogress':
      case 'in_progress':
      case 'waiting':
        return BadgeVariant.warning;
      case 'cancelled':
      case 'failed':
      case 'rejected':
      case 'expired':
        return BadgeVariant.danger;
      case 'full':
      case 'limited':
        return BadgeVariant.info;
      default:
        return BadgeVariant.neutral;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: _dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              fontFamily: 'Cairo',
              color: _textColor,
            ),
          ),
        ],
      ),
    );
  }
}

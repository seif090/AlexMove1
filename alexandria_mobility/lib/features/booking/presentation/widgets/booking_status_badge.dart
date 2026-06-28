import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';

class BookingStatusBadge extends ConsumerWidget {
  final String status;
  final bool isPayment;

  const BookingStatusBadge({
    super.key,
    required this.status,
    this.isPayment = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = _getStatusConfig(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: config.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            config.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Cairo',
              color: config.color,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getStatusConfig(String status) {
    if (isPayment) {
      switch (status.toLowerCase()) {
        case 'paid':
          return _StatusConfig(
            label: 'Paid',
            color: AppColors.success,
          );
        case 'pending':
          return _StatusConfig(
            label: 'Pending',
            color: AppColors.warning,
          );
        case 'failed':
          return _StatusConfig(
            label: 'Failed',
            color: AppColors.danger,
          );
        case 'refunded':
          return _StatusConfig(
            label: 'Refunded',
            color: AppColors.info,
          );
        default:
          return _StatusConfig(
            label: status[0].toUpperCase() + status.substring(1),
            color: AppColors.lightOnSurfaceVariant,
          );
      }
    }

    switch (status.toLowerCase()) {
      case 'confirmed':
        return _StatusConfig(
          label: 'Confirmed',
          color: AppColors.warning,
        );
      case 'pending':
        return _StatusConfig(
          label: 'Pending',
          color: AppColors.warning,
        );
      case 'active':
        return _StatusConfig(
          label: 'Active',
          color: AppColors.info,
        );
      case 'completed':
        return _StatusConfig(
          label: 'Completed',
          color: AppColors.success,
        );
      case 'cancelled':
        return _StatusConfig(
          label: 'Cancelled',
          color: AppColors.danger,
        );
      default:
        return _StatusConfig(
          label: status[0].toUpperCase() + status.substring(1),
          color: AppColors.lightOnSurfaceVariant,
        );
    }
  }
}

class _StatusConfig {
  final String label;
  final Color color;

  const _StatusConfig({required this.label, required this.color});
}

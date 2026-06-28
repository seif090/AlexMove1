import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/status_badge.dart';

class DriverTripCard extends ConsumerWidget {
  final int tripId;
  final String routeName;
  final String departureTime;
  final int passengerCount;
  final String status;
  final VoidCallback? onTap;

  const DriverTripCard({
    super.key,
    required this.tripId,
    required this.routeName,
    required this.departureTime,
    required this.passengerCount,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: AppCard(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: _getStatusColor().withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.route_rounded,
                color: _getStatusColor(),
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    routeName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Cairo',
                      color: AppColors.lightOnSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: AppColors.lightOnSurfaceVariant.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        departureTime,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Cairo',
                          color: AppColors.lightOnSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.people_rounded,
                        size: 14,
                        color: AppColors.lightOnSurfaceVariant.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$passengerCount passengers',
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Cairo',
                          color: AppColors.lightOnSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            StatusBadge(
              label: status,
              variant: StatusBadge.fromStatus(status),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'inprogress':
      case 'in_progress':
        return AppColors.success;
      case 'completed':
        return AppColors.primary;
      case 'scheduled':
        return AppColors.warning;
      case 'cancelled':
        return AppColors.danger;
      default:
        return AppColors.lightOnSurfaceVariant;
    }
  }
}

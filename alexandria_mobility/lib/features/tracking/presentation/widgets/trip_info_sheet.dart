import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/trip.dart';
import '../../domain/entities/trip_stop.dart';

class TripInfoSheet extends StatelessWidget {
  final Trip trip;

  const TripInfoSheet({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final eta = _calculateEta(trip);
    final pickedUpCount =
        trip.passengers.where((p) => p.isPickedUp).length;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.person,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.driverName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Cairo',
                        color: AppColors.lightOnSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      trip.vehiclePlate,
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: 'Cairo',
                        color: AppColors.lightOnSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(trip.status),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _buildInfoItem(
                  Icons.access_time,
                  'ETA',
                  eta,
                ),
                Container(
                  width: 1,
                  height: 32,
                  color: AppColors.lightBorder,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                ),
                _buildInfoItem(
                  Icons.people,
                  'Passengers',
                  '$pickedUpCount/${trip.passengers.length}',
                ),
                Container(
                  width: 1,
                  height: 32,
                  color: AppColors.lightBorder,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                ),
                _buildInfoItem(
                  Icons.route,
                  'Stops',
                  '${trip.routeStops.where((s) => s.isVisited).length}/${trip.routeStops.length}',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildArrivalCountdown(trip),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontFamily: 'Cairo',
              color: AppColors.lightOnSurface,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'Cairo',
              color: AppColors.lightOnSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(TripStatus status) {
    Color bgColor;
    Color textColor;
    String text;

    switch (status) {
      case TripStatus.scheduled:
        bgColor = AppColors.warningLight;
        textColor = AppColors.warning;
        text = 'Scheduled';
        break;
      case TripStatus.inProgress:
        bgColor = AppColors.successLight;
        textColor = AppColors.success;
        text = 'In Progress';
        break;
      case TripStatus.completed:
        bgColor = AppColors.infoLight;
        textColor = AppColors.info;
        text = 'Completed';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFamily: 'Cairo',
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildArrivalCountdown(Trip trip) {
    if (trip.status != TripStatus.inProgress) return const SizedBox.shrink();

    final nextStop = trip.routeStops
        .where((s) => !s.isVisited)
        .fold<TripStop?>(
          null,
          (prev, stop) =>
              prev == null || stop.order < prev.order ? stop : prev,
        );

    if (nextStop == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.flag, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Next Stop',
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: 'Cairo',
                    color: AppColors.lightOnSurfaceVariant,
                  ),
                ),
                Text(
                  nextStop.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo',
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          if (nextStop.estimatedArrival != null)
            Text(
              DateFormat('hh:mm a').format(nextStop.estimatedArrival!),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: 'Cairo',
                color: AppColors.primary,
              ),
            ),
        ],
      ),
    );
  }

  String _calculateEta(Trip trip) {
    if (trip.status == TripStatus.completed) return 'Arrived';

    final nextStop = trip.routeStops
        .where((s) => !s.isVisited)
        .fold<TripStop?>(
          null,
          (prev, stop) =>
              prev == null || stop.order < prev.order ? stop : prev,
        );

    if (nextStop?.estimatedArrival == null) return '--:--';

    final now = DateTime.now();
    final diff = nextStop!.estimatedArrival!.difference(now);
    if (diff.isNegative) return 'Arriving';

    final minutes = diff.inMinutes;
    if (minutes < 60) return '${minutes}m';

    final hours = diff.inHours;
    final remainingMinutes = minutes % 60;
    return '${hours}h ${remainingMinutes}m';
  }
}

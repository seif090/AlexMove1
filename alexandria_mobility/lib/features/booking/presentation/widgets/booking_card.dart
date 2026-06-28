import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/booking.dart';
import 'booking_status_badge.dart';

class BookingCard extends ConsumerWidget {
  final Booking booking;
  final VoidCallback? onTap;

  const BookingCard({
    super.key,
    required this.booking,
    this.onTap,
  });

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('EEE, MMM d, yyyy').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  String _formatCurrency(double? amount) {
    if (amount == null) return '--';
    return '${amount.toStringAsFixed(0)} EGP';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCancelled = booking.status.toLowerCase() == 'cancelled';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCancelled
                ? AppColors.danger.withValues(alpha: 0.2)
                : AppColors.lightBorder,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.lightOnSurface.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    booking.groupName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Cairo',
                      color: AppColors.lightOnSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                BookingStatusBadge(status: booking.status),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 16,
                  color: AppColors.lightOnSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  _formatDate(booking.bookingDate),
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: 'Cairo',
                    color: AppColors.lightOnSurfaceVariant,
                  ),
                ),
              ],
            ),
            if (booking.pickupLocation != null ||
                booking.dropoffLocation != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.route_rounded,
                    size: 16,
                    color: AppColors.primary.withValues(alpha: 0.8),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _buildRouteText(),
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: 'Cairo',
                        color: AppColors.lightOnSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                if (booking.seats != null) ...[
                  _buildInfoChip(
                    icon: Icons.event_seat_rounded,
                    label: '${booking.seats} seat${booking.seats! > 1 ? 's' : ''}',
                  ),
                  const SizedBox(width: 8),
                ],
                _buildInfoChip(
                  icon: Icons.attach_money_rounded,
                  label: _formatCurrency(booking.totalAmount),
                  color: AppColors.primary,
                ),
                const Spacer(),
                BookingStatusBadge(
                  status: booking.paymentStatus,
                  isPayment: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _buildRouteText() {
    final parts = <String>[];
    if (booking.pickupLocation != null) parts.add(booking.pickupLocation!);
    if (booking.dropoffLocation != null) parts.add(booking.dropoffLocation!);
    return parts.join(' → ');
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    Color? color,
  }) {
    final chipColor = color ?? AppColors.lightOnSurfaceVariant;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: chipColor, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Cairo',
              color: chipColor,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/group.dart';
import '../providers/group_provider.dart';

class GroupDetailScreen extends ConsumerWidget {
  final int groupId;

  const GroupDetailScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupAsync = ref.watch(groupDetailProvider(groupId));

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: groupAsync.when(
        loading: () => _buildSkeleton(),
        error: (error, _) => _buildErrorState(ref),
        data: (asyncData) => asyncData.when(
          loading: () => _buildSkeleton(),
          error: (error, _) => _buildErrorState(ref),
          data: (group) => _buildContent(context, ref, group),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, Group group) {
    final isFull = group.availableSeats == 0;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 180,
          pinned: true,
          backgroundColor: AppColors.primary,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.directions_bus_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      group.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Cairo',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRouteInfo(group),
                const SizedBox(height: 20),
                _buildScheduleSection(group),
                const SizedBox(height: 20),
                _buildSeatsInfo(group, isFull),
                const SizedBox(height: 20),
                _buildDriverInfo(group),
                const SizedBox(height: 20),
                if (group.workingDays.isNotEmpty) ...[
                  _buildWorkingDays(group),
                  const SizedBox(height: 20),
                ],
                _buildPriceSection(group, isFull),
                const SizedBox(height: 24),
                _buildSubscribeButton(ref, group, isFull),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRouteInfo(Group group) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.route_rounded,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Route',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Cairo',
                    color: AppColors.lightOnSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  group.routeName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Cairo',
                    color: AppColors.lightOnSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleSection(Group group) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTimeCard(
              label: 'Departure',
              time: group.departureTime,
              icon: Icons.wb_sunny_rounded,
              color: AppColors.warning,
            ),
          ),
          Container(
            width: 1,
            height: 50,
            color: AppColors.lightBorder,
          ),
          Expanded(
            child: _buildTimeCard(
              label: 'Return',
              time: group.returnTime,
              icon: Icons.nights_stay_rounded,
              color: AppColors.info,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeCard({
    required String label,
    required String time,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontFamily: 'Cairo',
            color: AppColors.lightOnSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          time,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'Cairo',
            color: AppColors.lightOnSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildSeatsInfo(Group group, bool isFull) {
    final percentage = group.capacity > 0
        ? (group.availableSeats / group.capacity * 100).round()
        : 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.event_seat_rounded,
                color: isFull ? AppColors.warning : AppColors.success,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Seat Availability',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo',
                  color: AppColors.lightOnSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: group.capacity > 0
                  ? group.availableSeats / group.capacity
                  : 0,
              backgroundColor: AppColors.lightBorder,
              valueColor: AlwaysStoppedAnimation<Color>(
                isFull ? AppColors.warning : AppColors.success,
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${group.availableSeats} seats available',
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Cairo',
                  color: isFull ? AppColors.warning : AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$percentage% free',
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'Cairo',
                  color: AppColors.lightOnSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDriverInfo(Group group) {
    if (group.driverName == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primaryLight,
            child: Text(
              group.driverName![0].toUpperCase(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: 'Cairo',
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Driver',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Cairo',
                    color: AppColors.lightOnSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  group.driverName!,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo',
                    color: AppColors.lightOnSurface,
                  ),
                ),
              ],
            ),
          ),
          if (group.vehiclePlate != null)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppColors.lightSurfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                group.vehiclePlate!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo',
                  color: AppColors.lightOnSurface,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWorkingDays(Group group) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_month_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Working Days',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo',
                  color: AppColors.lightOnSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: group.workingDays.map((day) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  day,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo',
                    color: AppColors.primary,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(Group group, bool isFull) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Monthly Price',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Cairo',
              color: Colors.white70,
            ),
          ),
          Text(
            '${group.price.toStringAsFixed(0)} EGP',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              fontFamily: 'Cairo',
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscribeButton(WidgetRef ref, Group group, bool isFull) {
    if (group.isSubscribed) {
      return Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.successLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: AppColors.success,
              size: 22,
            ),
            SizedBox(width: 8),
            Text(
              'Subscribed',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'Cairo',
                color: AppColors.success,
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: isFull
            ? null
            : () {
                _showBookingSheet(ref, group);
              },
        icon: Icon(
          isFull ? Icons.hourglass_top_rounded : Icons.bookmark_add_rounded,
          size: 20,
        ),
        label: Text(
          isFull ? 'Group Full' : 'Subscribe Now',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'Cairo',
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isFull ? AppColors.lightOnSurfaceVariant : AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.lightOnSurfaceVariant.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  void _showBookingSheet(WidgetRef ref, Group group) {
    showModalBottomSheet(
      context: ref.context,
      isScrollControlled: true,
      builder: (context) => _BookingBottomSheet(group: group),
    );
  }

  Widget _buildSkeleton() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 180,
          pinned: true,
          backgroundColor: AppColors.lightBorder,
          leading: const SizedBox(),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: AppColors.lightBorder.withValues(alpha: 0.5),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: List.generate(
                4,
                (_) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.lightBorder.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.dangerLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: AppColors.danger,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: 'Cairo',
                color: AppColors.lightOnSurface,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Unable to load group details.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Cairo',
                color: AppColors.lightOnSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(groupDetailProvider(groupId));
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text(
                'Retry',
                style: TextStyle(fontFamily: 'Cairo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingBottomSheet extends ConsumerStatefulWidget {
  final Group group;

  const _BookingBottomSheet({required this.group});

  @override
  ConsumerState<_BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends ConsumerState<_BookingBottomSheet> {
  int _selectedSeats = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
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
          const SizedBox(height: 20),
          Text(
            'Book ${widget.group.name}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontFamily: 'Cairo',
              color: AppColors.lightOnSurface,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Number of seats',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Cairo',
              color: AppColors.lightOnSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildSeatButton(
                icon: Icons.remove,
                onPressed: _selectedSeats > 1
                    ? () => setState(() => _selectedSeats--)
                    : null,
              ),
              const SizedBox(width: 20),
              Text(
                '$_selectedSeats',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Cairo',
                  color: AppColors.lightOnSurface,
                ),
              ),
              const SizedBox(width: 20),
              _buildSeatButton(
                icon: Icons.add,
                onPressed: _selectedSeats < widget.group.availableSeats
                    ? () => setState(() => _selectedSeats++)
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo',
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  '${(widget.group.price * _selectedSeats).toStringAsFixed(0)} EGP',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Cairo',
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Confirm Booking',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).viewInsets.bottom,
          ),
        ],
      ),
    );
  }

  Widget _buildSeatButton({
    required IconData icon,
    VoidCallback? onPressed,
  }) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: onPressed != null ? AppColors.primary : AppColors.lightSurfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: onPressed != null ? Colors.white : AppColors.lightOnSurfaceVariant,
          size: 22,
        ),
      ),
    );
  }
}

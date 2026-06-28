import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../widgets/passenger_list_tile.dart';

class DriverTripDetailScreen extends ConsumerStatefulWidget {
  final int tripId;

  const DriverTripDetailScreen({
    super.key,
    required this.tripId,
  });

  @override
  ConsumerState<DriverTripDetailScreen> createState() =>
      _DriverTripDetailScreenState();
}

class _DriverTripDetailScreenState
    extends ConsumerState<DriverTripDetailScreen> {
  bool _isTripStarted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: CustomAppBar(
        title: 'Trip #${widget.tripId}',
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTripHeader(),
            _buildRouteInfo(),
            _buildPassengerList(),
            _buildActionButtons(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTripHeader() {
    return GradientBackground.primary(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.route_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Smouha - El Mamoura',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Cairo',
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '7:30 AM - Departure',
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Cairo',
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              StatusBadge(
                label: _isTripStarted ? 'In Progress' : 'Scheduled',
                variant: _isTripStarted
                    ? BadgeVariant.success
                    : BadgeVariant.warning,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildStatItem(
                icon: Icons.people_rounded,
                value: '8',
                label: 'Passengers',
              ),
              const SizedBox(width: 24),
              _buildStatItem(
                icon: Icons.directions_bus_rounded,
                value: 'ABC 123',
                label: 'Vehicle',
              ),
              const SizedBox(width: 24),
              _buildStatItem(
                icon: Icons.star_rounded,
                value: '4.8',
                label: 'Rating',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontFamily: 'Cairo',
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontFamily: 'Cairo',
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Route Stops',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'Cairo',
                color: AppColors.lightOnSurface,
              ),
            ),
            const SizedBox(height: 16),
            _buildStopItem('Smouha Station', '7:30 AM', true),
            _buildStopItem('El Mamoura', '7:50 AM', false),
            _buildStopItem('Final Stop', '8:10 AM', false),
          ],
        ),
      ),
    );
  }

  Widget _buildStopItem(String name, String time, bool isFirst) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isFirst ? AppColors.primary : AppColors.lightBorder,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isFirst ? AppColors.primary : AppColors.lightBorder,
                  width: 2,
                ),
              ),
            ),
            if (!isFirst)
              Container(
                width: 2,
                height: 24,
                color: AppColors.lightBorder,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isFirst ? FontWeight.w600 : FontWeight.w500,
                  fontFamily: 'Cairo',
                  color: isFirst
                      ? AppColors.lightOnSurface
                      : AppColors.lightOnSurfaceVariant,
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'Cairo',
                  color: AppColors.lightOnSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPassengerList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Passengers (8)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: 'Cairo',
              color: AppColors.lightOnSurface,
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                PassengerListTile(
                  name: 'Ahmed Hassan',
                  pickupLocation: 'Smouha Station',
                  isPickedUp: true,
                  onChanged: (value) {},
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                PassengerListTile(
                  name: 'Sara Mohamed',
                  pickupLocation: 'Smouha Roundabout',
                  isPickedUp: true,
                  onChanged: (value) {},
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                PassengerListTile(
                  name: 'Omar Ali',
                  pickupLocation: 'El Mamoura',
                  isPickedUp: false,
                  onChanged: (value) {},
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                PassengerListTile(
                  name: 'Fatma Khalid',
                  pickupLocation: 'El Mamoura',
                  isPickedUp: false,
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (!_isTripStarted)
            AppButton.primary(
              label: 'Start Trip',
              icon: Icons.play_arrow_rounded,
              isFullWidth: true,
              onPressed: () {
                setState(() {
                  _isTripStarted = true;
                });
              },
            )
          else ...[
            AppButton.primary(
              label: 'Complete Trip',
              icon: Icons.check_circle_rounded,
              isFullWidth: true,
              onPressed: () {
                context.pop();
              },
            ),
            const SizedBox(height: 12),
            AppButton.outlined(
              label: 'Report Issue',
              icon: Icons.warning_amber_rounded,
              isFullWidth: true,
              onPressed: () {},
            ),
          ],
        ],
      ),
    );
  }
}

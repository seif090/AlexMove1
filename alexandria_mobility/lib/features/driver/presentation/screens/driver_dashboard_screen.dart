import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/status_badge.dart';

class DriverDashboardScreen extends ConsumerStatefulWidget {
  const DriverDashboardScreen({super.key});

  @override
  ConsumerState<DriverDashboardScreen> createState() =>
      _DriverDashboardScreenState();
}

class _DriverDashboardScreenState extends ConsumerState<DriverDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {},
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(
                child: _buildGreetingHeader(),
              ),
              SliverToBoxAdapter(
                child: _buildStatsSection(),
              ),
              SliverToBoxAdapter(
                child: SectionHeader(
                  title: 'Quick Actions',
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                ),
              ),
              SliverToBoxAdapter(
                child: _buildQuickActions(),
              ),
              SliverToBoxAdapter(
                child: SectionHeader(
                  title: "Today's Schedule",
                  actionLabel: 'See All',
                  onAction: () => context.push('/driver/trips'),
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildScheduleItem(index),
                  childCount: 3,
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingHeader() {
    return GradientBackground.primary(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.directions_car_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getGreeting(),
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Cairo',
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    const Text(
                      'Driver Hub',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Cairo',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                    SizedBox(width: 4),
                    Text(
                      '4.8',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Cairo',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Transform.translate(
        offset: const Offset(0, -16),
        child: Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.directions_bus_rounded,
                value: '3',
                label: 'Active Trips',
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.people_rounded,
                value: '12',
                label: 'Passengers',
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.star_rounded,
                value: '4.8',
                label: 'Rating',
                color: AppColors.warning,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBorder),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontFamily: 'Cairo',
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'Cairo',
              color: AppColors.lightOnSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickAction(
              icon: Icons.add_road_rounded,
              label: 'Start Trip',
              color: AppColors.success,
              onTap: () {},
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildQuickAction(
              icon: Icons.map_rounded,
              label: 'View Map',
              color: AppColors.info,
              onTap: () {},
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildQuickAction(
              icon: Icons.history_rounded,
              label: 'History',
              color: AppColors.warning,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.lightBorder),
        ),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
                color: AppColors.lightOnSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(int index) {
    final trips = [
      {
        'route': 'Smouha - El Mamoura',
        'time': '7:30 AM',
        'passengers': 8,
        'status': 'scheduled',
      },
      {
        'route': 'El Mamoura - Smouha',
        'time': '4:00 PM',
        'passengers': 6,
        'status': 'scheduled',
      },
      {
        'route': 'Smouha - Borg Arab',
        'time': '6:30 PM',
        'passengers': 10,
        'status': 'scheduled',
      },
    ];

    final trip = trips[index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: AppCard(
        onTap: () => context.push('/driver/trips/${index + 1}'),
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
                  Text(
                    trip['route'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Cairo',
                      color: AppColors.lightOnSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: AppColors.lightOnSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        trip['time'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Cairo',
                          color: AppColors.lightOnSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.people_rounded,
                        size: 14,
                        color: AppColors.lightOnSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${trip['passengers']} passengers',
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
            (trip['status'] as String) == 'scheduled'
                ? const StatusBadge.warning(label: 'Scheduled')
                : const StatusBadge.success(label: 'Active'),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}

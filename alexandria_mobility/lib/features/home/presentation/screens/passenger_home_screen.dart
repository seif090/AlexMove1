import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../../shared/widgets/section_header.dart';

class PassengerHomeScreen extends ConsumerStatefulWidget {
  const PassengerHomeScreen({super.key});

  @override
  ConsumerState<PassengerHomeScreen> createState() =>
      _PassengerHomeScreenState();
}

class _PassengerHomeScreenState extends ConsumerState<PassengerHomeScreen> {
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
                child: _buildQuickActions(),
              ),
              SliverToBoxAdapter(
                child: SectionHeader(
                  title: 'Upcoming Trips',
                  actionLabel: 'See All',
                  onAction: () => context.push('/bookings'),
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                ),
              ),
              SliverToBoxAdapter(
                child: _buildUpcomingTrips(),
              ),
              SliverToBoxAdapter(
                child: SectionHeader(
                  title: 'Available Groups',
                  actionLabel: 'See All',
                  onAction: () => context.push('/groups'),
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildGroupItem(index),
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
                  Icons.person_rounded,
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
                      'Ahmed!',
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
              IconButton(
                onPressed: () => context.push('/notifications'),
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Iconsax.notification,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Transform.translate(
        offset: const Offset(0, -16),
        child: Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                icon: Iconsax.bus,
                label: 'Book',
                color: AppColors.primary,
                onTap: () => context.push('/groups'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                icon: Iconsax.ticket,
                label: 'My Trips',
                color: AppColors.secondary,
                onTap: () => context.push('/bookings'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                icon: Iconsax.people,
                label: 'Communities',
                color: AppColors.success,
                onTap: () => context.push('/communities'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                icon: Iconsax.notification,
                label: 'Alerts',
                color: AppColors.warning,
                onTap: () => context.push('/notifications'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.lightBorder),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.06),
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
              label,
              style: const TextStyle(
                fontSize: 11,
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

  Widget _buildUpcomingTrips() {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 3,
        itemBuilder: (context, index) => _buildUpcomingTripCard(index),
      ),
    );
  }

  Widget _buildUpcomingTripCard(int index) {
    final trips = [
      {
        'route': 'Smouha - El Mamoura',
        'date': 'Today',
        'time': '7:30 AM',
        'group': 'Smouha Commuters',
      },
      {
        'route': 'El Mamoura - Smouha',
        'date': 'Tomorrow',
        'time': '4:00 PM',
        'group': 'Smouha Commuters',
      },
      {
        'route': 'Smouha - Borg Arab',
        'date': 'Wed, Jun 30',
        'time': '6:30 PM',
        'group': 'University Group',
      },
    ];

    final trip = trips[index];
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      child: AppCard(
        onTap: () => context.push('/bookings'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    trip['date'] as String,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Cairo',
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppColors.lightOnSurfaceVariant.withValues(alpha: 0.5),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              trip['route'] as String,
              style: const TextStyle(
                fontSize: 14,
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
                  trip['time'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Cairo',
                    color: AppColors.lightOnSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.group_rounded,
                  size: 14,
                  color: AppColors.lightOnSurfaceVariant.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    trip['group'] as String,
                    style: const TextStyle(
                      fontSize: 12,
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
        ),
      ),
    );
  }

  Widget _buildGroupItem(int index) {
    final groups = [
      {
        'name': 'Smouha Commuters',
        'route': 'Smouha - El Mamoura',
        'seats': '8/12',
        'price': '150 EGP',
      },
      {
        'name': 'University Group',
        'route': 'Smouha - Borg Arab',
        'seats': '5/10',
        'price': '200 EGP',
      },
      {
        'name': 'Downtown Express',
        'route': 'Smouha - Downtown',
        'seats': '10/15',
        'price': '120 EGP',
      },
    ];

    final group = groups[index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: AppCard(
        onTap: () => context.push('/groups/${index + 1}'),
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
                Icons.group_rounded,
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
                    group['name'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Cairo',
                      color: AppColors.lightOnSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    group['route'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'Cairo',
                      color: AppColors.lightOnSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  group['price'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Cairo',
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${group['seats']} seats',
                  style: const TextStyle(
                    fontSize: 11,
                    fontFamily: 'Cairo',
                    color: AppColors.lightOnSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }
}

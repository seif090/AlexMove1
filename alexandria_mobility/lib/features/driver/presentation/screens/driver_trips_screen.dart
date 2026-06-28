import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/driver_trip_card.dart';

class DriverTripsScreen extends ConsumerStatefulWidget {
  const DriverTripsScreen({super.key});

  @override
  ConsumerState<DriverTripsScreen> createState() => _DriverTripsScreenState();
}

class _DriverTripsScreenState extends ConsumerState<DriverTripsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text(
          'My Trips',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo',
            color: AppColors.lightOnSurface,
          ),
        ),
        backgroundColor: AppColors.lightSurface,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.lightOnSurfaceVariant,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo',
            fontSize: 14,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontFamily: 'Cairo',
            fontSize: 14,
          ),
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.label,
          dividerHeight: 0,
          tabs: const [
            Tab(text: 'Today'),
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTripList('today'),
          _buildTripList('upcoming'),
          _buildTripList('completed'),
        ],
      ),
    );
  }

  Widget _buildTripList(String filter) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: filter == 'completed' ? 5 : 3,
      itemBuilder: (context, index) {
        return DriverTripCard(
          tripId: index + 1,
          routeName: _getRouteName(index),
          departureTime: _getTime(index, filter),
          passengerCount: _getPassengerCount(index),
          status: _getStatus(index, filter),
          onTap: () => context.push('/driver/trips/${index + 1}'),
        );
      },
    );
  }

  String _getRouteName(int index) {
    final routes = [
      'Smouha - El Mamoura',
      'El Mamoura - Smouha',
      'Smouha - Borg Arab',
      'Borg Arab - Smouha',
      'Smouha - Stanley',
    ];
    return routes[index % routes.length];
  }

  String _getTime(int index, String filter) {
    final times = ['7:30 AM', '4:00 PM', '6:30 PM', '8:00 AM', '5:00 PM'];
    return times[index % times.length];
  }

  int _getPassengerCount(int index) {
    return [8, 6, 10, 4, 7][index % 5];
  }

  String _getStatus(int index, String filter) {
    switch (filter) {
      case 'today':
        return index == 0 ? 'inprogress' : 'scheduled';
      case 'upcoming':
        return 'scheduled';
      case 'completed':
        return 'completed';
      default:
        return 'scheduled';
    }
  }
}

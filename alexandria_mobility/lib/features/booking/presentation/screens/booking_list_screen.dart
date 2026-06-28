import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/booking_provider.dart';
import '../widgets/booking_card.dart';

class BookingListScreen extends ConsumerStatefulWidget {
  const BookingListScreen({super.key});

  @override
  ConsumerState<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends ConsumerState<BookingListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _scrollController = ScrollController();

  static const _tabs = ['Upcoming', 'Completed', 'Cancelled'];
  static const _statusMap = {
    'Upcoming': 'confirmed',
    'Completed': 'completed',
    'Cancelled': 'cancelled',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_onTabChanged);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) return;
    final status = _statusMap[_tabs[_tabController.index]];
    ref.read(bookingStatusFilterProvider.notifier).state = status;
    ref.read(bookingPageProvider.notifier).state = 1;
    ref.invalidate(bookingListProvider);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final currentPage = ref.read(bookingPageProvider);
      final bookingsAsync = ref.read(bookingListProvider);
      bookingsAsync.whenData((asyncData) {
        asyncData.whenData((paginatedData) {
          if (paginatedData.hasNextPage) {
            ref.read(bookingPageProvider.notifier).state = currentPage + 1;
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(bookingListProvider);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text(
          'My Bookings',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontFamily: 'Cairo',
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.lightSurface,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.lightOnSurfaceVariant,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w700,
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
              dividerColor: AppColors.lightBorder,
              tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
            ),
          ),
          Expanded(
            child: bookingsAsync.when(
              loading: () => _buildSkeletonList(),
              error: (error, _) => _buildErrorState(),
              data: (asyncData) => asyncData.when(
                loading: () => _buildSkeletonList(),
                error: (error, _) => _buildErrorState(),
                data: (paginatedData) {
                  if (paginatedData.items.isEmpty) {
                    return _buildEmptyState();
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      ref.read(bookingPageProvider.notifier).state = 1;
                      ref.invalidate(bookingListProvider);
                    },
                    color: AppColors.primary,
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      itemCount: paginatedData.items.length,
                      itemBuilder: (context, index) {
                        final booking = paginatedData.items[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: BookingCard(
                            booking: booking,
                            onTap: () => context.push(
                              '/bookings/${booking.id}',
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return _SkeletonBookingCard(key: ValueKey('skeleton_$index'));
      },
    );
  }

  Widget _buildErrorState() {
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
              'Unable to load bookings. Please try again.',
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
                ref.read(bookingPageProvider.notifier).state = 1;
                ref.invalidate(bookingListProvider);
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

  Widget _buildEmptyState() {
    final currentTab = _tabs[_tabController.index];
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.event_busy_rounded,
                color: AppColors.primary,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No $currentTab bookings',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: 'Cairo',
                color: AppColors.lightOnSurface,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your bookings will appear here once you make a reservation.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Cairo',
                color: AppColors.lightOnSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonBookingCard extends StatelessWidget {
  const _SkeletonBookingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightSurfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 16,
                  width: 120,
                  decoration: BoxDecoration(
                    color: AppColors.lightBorder.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Container(
                width: 80,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.lightBorder.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 14,
            width: 160,
            decoration: BoxDecoration(
              color: AppColors.lightBorder.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 14,
            width: 200,
            decoration: BoxDecoration(
              color: AppColors.lightBorder.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 70,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.lightBorder.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 80,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.lightBorder.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

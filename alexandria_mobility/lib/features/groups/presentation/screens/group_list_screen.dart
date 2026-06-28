import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/group_provider.dart';
import '../widgets/group_card.dart';

class GroupListScreen extends ConsumerStatefulWidget {
  const GroupListScreen({super.key});

  @override
  ConsumerState<GroupListScreen> createState() => _GroupListScreenState();
}

class _GroupListScreenState extends ConsumerState<GroupListScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final currentPage = ref.read(groupsPageProvider);
      final groupsAsync = ref.read(groupsProvider);
      groupsAsync.whenData((asyncData) {
        asyncData.whenData((data) {
          if (data.hasNextPage) {
            ref.read(groupsPageProvider.notifier).state = currentPage + 1;
          }
        });
      });
    }
  }

  void _onSearch(String value) {
    ref.read(groupsSearchProvider.notifier).state = value;
    ref.read(groupsPageProvider.notifier).state = 1;
    ref.invalidate(groupsProvider);
  }

  void _onFilterChanged(String? status) {
    ref.read(groupsStatusFilterProvider.notifier).state = status;
    ref.read(groupsPageProvider.notifier).state = 1;
    ref.invalidate(groupsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final groupsAsync = ref.watch(groupsProvider);
    final currentFilter = ref.watch(groupsStatusFilterProvider);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text(
          'Groups',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontFamily: 'Cairo',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => context.push('/my-groups'),
            icon: const Icon(Icons.groups_rounded),
            tooltip: 'My Groups',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: 'Search groups...',
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.lightOnSurfaceVariant,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          _onSearch('');
                        },
                        icon: const Icon(
                          Icons.clear_rounded,
                          color: AppColors.lightOnSurfaceVariant,
                        ),
                      )
                    : null,
              ),
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildFilterChip(
                  label: 'All',
                  isSelected: currentFilter == null,
                  onTap: () => _onFilterChanged(null),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'Active',
                  isSelected: currentFilter == 'active',
                  onTap: () => _onFilterChanged('active'),
                  color: AppColors.success,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'Full',
                  isSelected: currentFilter == 'full',
                  onTap: () => _onFilterChanged('full'),
                  color: AppColors.warning,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'Inactive',
                  isSelected: currentFilter == 'inactive',
                  onTap: () => _onFilterChanged('inactive'),
                  color: AppColors.lightOnSurfaceVariant,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: groupsAsync.when(
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
                      ref.read(groupsPageProvider.notifier).state = 1;
                      ref.invalidate(groupsProvider);
                    },
                    color: AppColors.primary,
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: paginatedData.items.length,
                      itemBuilder: (context, index) {
                        final group = paginatedData.items[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GroupCard(
                            group: group,
                            onTap: () => context.push(
                              '/groups/${group.id}',
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

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color? color,
  }) {
    final chipColor = color ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? chipColor.withValues(alpha: 0.15)
              : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? chipColor : AppColors.lightBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontFamily: 'Cairo',
            color: isSelected ? chipColor : AppColors.lightOnSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return _SkeletonCard(key: ValueKey('skeleton_$index'));
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
              'Unable to load groups. Please try again.',
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
                ref.read(groupsPageProvider.notifier).state = 1;
                ref.invalidate(groupsProvider);
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
                Icons.directions_bus_outlined,
                color: AppColors.primary,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No groups found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: 'Cairo',
                color: AppColors.lightOnSurface,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try adjusting your search or filters.',
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

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({super.key});

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
                width: 60,
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
            width: 180,
            decoration: BoxDecoration(
              color: AppColors.lightBorder.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 16),
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
                width: 70,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.lightBorder.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
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

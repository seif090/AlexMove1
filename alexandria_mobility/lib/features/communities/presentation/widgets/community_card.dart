import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/community.dart';

class CommunityCard extends ConsumerWidget {
  final Community community;
  final VoidCallback? onTap;

  const CommunityCard({
    super.key,
    required this.community,
    this.onTap,
  });

  List<Color> _getGradientColors(String type) {
    switch (type.toLowerCase()) {
      case 'neighborhood':
        return [AppColors.primary, AppColors.primaryDark];
      case 'workplace':
        return [AppColors.secondary, AppColors.secondaryDark];
      case 'university':
        return [AppColors.info, AppColors.primary];
      default:
        return [AppColors.primaryGradientStart, AppColors.primaryGradientEnd];
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'neighborhood':
        return Icons.location_city_rounded;
      case 'workplace':
        return Icons.work_rounded;
      case 'university':
        return Icons.school_rounded;
      default:
        return Icons.groups_rounded;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gradientColors = _getGradientColors(community.type);
    final typeIcon = _getTypeIcon(community.type);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.lightBorder,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
              ),
              child: Center(
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    typeIcon,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    community.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Cairo',
                      color: AppColors.lightOnSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.place_rounded,
                        size: 14,
                        color: AppColors.lightOnSurfaceVariant.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          community.area,
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
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.people_rounded,
                        size: 14,
                        color: AppColors.primary.withValues(alpha: 0.8),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${community.memberCount} ${community.memberCount == 1 ? 'member' : 'members'}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Cairo',
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

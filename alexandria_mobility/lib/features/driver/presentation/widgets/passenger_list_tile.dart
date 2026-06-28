import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';

class PassengerListTile extends ConsumerWidget {
  final String name;
  final String pickupLocation;
  final bool isPickedUp;
  final ValueChanged<bool>? onChanged;

  const PassengerListTile({
    super.key,
    required this.name,
    required this.pickupLocation,
    this.isPickedUp = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isPickedUp
              ? AppColors.successLight
              : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : '?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontFamily: 'Cairo',
              color: isPickedUp ? AppColors.success : AppColors.lightOnSurfaceVariant,
            ),
          ),
        ),
      ),
      title: Text(
        name,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontFamily: 'Cairo',
          color: isPickedUp
              ? AppColors.lightOnSurfaceVariant
              : AppColors.lightOnSurface,
        ),
      ),
      subtitle: Row(
        children: [
          Icon(
            Icons.place_rounded,
            size: 14,
            color: AppColors.lightOnSurfaceVariant.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              pickupLocation,
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
      trailing: Transform.scale(
        scale: 0.8,
        child: Switch(
          value: isPickedUp,
          onChanged: onChanged,
          activeThumbColor: AppColors.success,
          activeTrackColor: AppColors.successLight,
          inactiveTrackColor: AppColors.surfaceContainerLow,
        ),
      ),
    );
  }
}

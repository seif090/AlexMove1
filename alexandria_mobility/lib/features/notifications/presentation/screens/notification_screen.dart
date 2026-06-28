import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/notification.dart';
import '../providers/notification_provider.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await ref.read(markAllAsReadProvider.notifier).markAllAsRead();
            },
            child: const Text(
              'Mark all read',
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Cairo',
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, _) => _buildErrorState(ref, error.toString()),
        data: (notificationsValue) => notificationsValue.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (error, _) => _buildErrorState(ref, error.toString()),
          data: (notifications) {
            if (notifications.isEmpty) {
              return _buildEmptyState();
            }
            return _buildNotificationList(context, ref, notifications);
          },
        ),
      ),
    );
  }

  Widget _buildNotificationList(
    BuildContext context,
    WidgetRef ref,
    List<AppNotification> notifications,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(notificationsProvider);
        ref.invalidate(unreadCountProvider);
      },
      color: AppColors.primary,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Dismissible(
            key: Key('notification_${notification.id}'),
            direction: DismissDirection.endToStart,
            onDismissed: (_) async {
              await ref
                  .read(deleteNotificationProvider.notifier)
                  .deleteNotification(notification.id);
            },
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                color: AppColors.danger,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.delete, color: Colors.white, size: 24),
            ),
            child: _buildNotificationItem(context, ref, notification),
          );
        },
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    WidgetRef ref,
    AppNotification notification,
  ) {
    return GestureDetector(
      onTap: () async {
        if (!notification.isRead) {
          await ref
              .read(markAsReadProvider.notifier)
              .markAsRead(notification.id);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: notification.isRead
              ? AppColors.lightSurface
              : AppColors.primaryLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: notification.isRead
                ? AppColors.lightBorder
                : AppColors.primary.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNotificationIcon(notification.type),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: notification.isRead
                                ? FontWeight.w600
                                : FontWeight.w700,
                            fontFamily: 'Cairo',
                            color: AppColors.lightOnSurface,
                          ),
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontFamily: 'Cairo',
                      color: AppColors.lightOnSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatTime(notification.createdAt),
                    style: const TextStyle(
                      fontSize: 11,
                      fontFamily: 'Cairo',
                      color: AppColors.lightOnSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(NotificationType type) {
    IconData icon;
    Color bgColor;
    Color iconColor;

    switch (type) {
      case NotificationType.booking:
        icon = Icons.calendar_today;
        bgColor = AppColors.infoLight;
        iconColor = AppColors.info;
        break;
      case NotificationType.trip:
        icon = Icons.directions_car;
        bgColor = AppColors.primaryLight;
        iconColor = AppColors.primary;
        break;
      case NotificationType.payment:
        icon = Icons.payment;
        bgColor = AppColors.successLight;
        iconColor = AppColors.success;
        break;
      case NotificationType.promotion:
        icon = Icons.local_offer;
        bgColor = AppColors.warningLight;
        iconColor = AppColors.warning;
        break;
      case NotificationType.system:
        icon = Icons.info_outline;
        bgColor = AppColors.lightSurfaceVariant;
        iconColor = AppColors.lightOnSurfaceVariant;
        break;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 20, color: iconColor),
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
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Notifications',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: 'Cairo',
                color: AppColors.lightOnSurface,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'You\'re all caught up!\nWe\'ll notify you when there\'s something new.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Cairo',
                color: AppColors.lightOnSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(WidgetRef ref, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.dangerLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 40,
                color: AppColors.danger,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to load notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: 'Cairo',
                color: AppColors.lightOnSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Cairo',
                color: AppColors.lightOnSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(notificationsProvider);
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Retry', style: TextStyle(fontFamily: 'Cairo')),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM d, yyyy').format(dateTime);
  }
}

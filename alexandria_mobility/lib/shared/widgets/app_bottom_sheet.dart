import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';

class AppBottomSheet extends ConsumerWidget {
  final Widget child;
  final String? title;
  final bool isDismissible;
  final bool showDragHandle;
  final bool useSafeArea;
  final double? maxHeight;

  const AppBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.isDismissible = true,
    this.showDragHandle = true,
    this.useSafeArea = true,
    this.maxHeight,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    bool isDismissible = true,
    bool showDragHandle = true,
    bool useSafeArea = true,
    double? maxHeight,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      isScrollControlled: true,
      useSafeArea: useSafeArea,
      backgroundColor: Colors.transparent,
      builder: (context) => AppBottomSheet(
        title: title,
        isDismissible: isDismissible,
        showDragHandle: showDragHandle,
        useSafeArea: useSafeArea,
        maxHeight: maxHeight,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: maxHeight != null
          ? BoxConstraints(maxHeight: maxHeight!)
          : BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
      decoration: const BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDragHandle) ...[
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
          if (title != null) ...[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                title!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Cairo',
                  color: AppColors.lightOnSurface,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.lightBorder),
          ],
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

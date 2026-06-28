import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';

enum AppButtonVariant { primary, secondary, outlined, text }

enum AppButtonSize { small, medium, large }

class AppButton extends ConsumerWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  const AppButton.primary({
    super.key,
    required this.label,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.backgroundColor,
    this.foregroundColor,
  })  : variant = AppButtonVariant.primary;

  const AppButton.secondary({
    super.key,
    required this.label,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.backgroundColor,
    this.foregroundColor,
  })  : variant = AppButtonVariant.secondary;

  const AppButton.outlined({
    super.key,
    required this.label,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.backgroundColor,
    this.foregroundColor,
  })  : variant = AppButtonVariant.outlined;

  const AppButton.text({
    super.key,
    required this.label,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.backgroundColor,
    this.foregroundColor,
  })  : variant = AppButtonVariant.text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final effectiveOnPressed = isLoading ? null : onPressed;

    switch (variant) {
      case AppButtonVariant.primary:
        return _buildElevated(context, effectiveOnPressed);
      case AppButtonVariant.secondary:
        return _buildFilled(context, effectiveOnPressed);
      case AppButtonVariant.outlined:
        return _buildOutlined(context, effectiveOnPressed);
      case AppButtonVariant.text:
        return _buildText(context, effectiveOnPressed);
    }
  }

  Widget _buildElevated(BuildContext context, VoidCallback? onPressed) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: foregroundColor ?? Colors.white,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
          disabledForegroundColor: Colors.white70,
          padding: _padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _buildChild(),
      ),
    );
  }

  Widget _buildFilled(BuildContext context, VoidCallback? onPressed) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.secondary,
          foregroundColor: foregroundColor ?? Colors.white,
          disabledBackgroundColor: AppColors.secondary.withValues(alpha: 0.5),
          disabledForegroundColor: Colors.white70,
          padding: _padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _buildChild(),
      ),
    );
  }

  Widget _buildOutlined(BuildContext context, VoidCallback? onPressed) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: foregroundColor ?? AppColors.primary,
          disabledForegroundColor: AppColors.primary.withValues(alpha: 0.5),
          padding: _padding,
          side: BorderSide(
            color: backgroundColor ?? AppColors.primary,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _buildChild(),
      ),
    );
  }

  Widget _buildText(BuildContext context, VoidCallback? onPressed) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: foregroundColor ?? AppColors.primary,
          disabledForegroundColor: AppColors.primary.withValues(alpha: 0.5),
          padding: _padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _buildChild(),
      ),
    );
  }

  Widget _buildChild() {
    if (isLoading) {
      return SizedBox(
        width: _iconSize,
        height: _iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            foregroundColor ?? Colors.white,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: _iconSize),
          SizedBox(width: size == AppButtonSize.small ? 4 : 8),
          Text(label),
        ],
      );
    }

    return Text(label);
  }

  EdgeInsets get _padding {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 14);
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 18);
    }
  }

  double get _iconSize {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 20;
      case AppButtonSize.large:
        return 22;
    }
  }
}

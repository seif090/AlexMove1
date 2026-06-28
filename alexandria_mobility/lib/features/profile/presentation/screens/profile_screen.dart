import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/profile_provider.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: profileAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, _) => _buildErrorState(ref, error.toString()),
        data: (profileValue) => profileValue.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (error, _) => _buildErrorState(ref, error.toString()),
          data: (profile) => CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildProfileHeader(context, profile)),
              SliverToBoxAdapter(child: _buildSettingsList(context, ref, profile)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, dynamic profile) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        bottom: 32,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryGradientStart, AppColors.primaryGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 45,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              backgroundImage: profile.profileImageUrl != null
                  ? NetworkImage(profile.profileImageUrl!)
                  : null,
              child: profile.profileImageUrl == null
                  ? Text(
                      profile.fullName.isNotEmpty
                          ? profile.fullName[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Cairo',
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            profile.fullName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              fontFamily: 'Cairo',
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            profile.email,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Cairo',
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              profile.role.toUpperCase(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                fontFamily: 'Cairo',
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context, WidgetRef ref, dynamic profile) {
    final settingsItems = [
      _SettingsItem(
        icon: Icons.edit_outlined,
        title: 'Edit Profile',
        subtitle: 'Update your personal information',
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const EditProfileScreen()),
          );
        },
      ),
      _SettingsItem(
        icon: Icons.language_outlined,
        title: 'Language',
        subtitle: 'English',
        onTap: () {},
      ),
      _SettingsItem(
        icon: Icons.dark_mode_outlined,
        title: 'Theme',
        subtitle: 'Light',
        onTap: () {},
      ),
      _SettingsItem(
        icon: Icons.info_outline,
        title: 'About',
        subtitle: 'App version 1.0.0',
        onTap: () {},
      ),
      _SettingsItem(
        icon: Icons.logout,
        title: 'Logout',
        subtitle: 'Sign out of your account',
        onTap: () => _showLogoutDialog(context, ref),
        isDestructive: true,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: 'Cairo',
                color: AppColors.lightOnSurface,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.lightSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.lightBorder),
            ),
            child: Column(
              children: settingsItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isLast = index == settingsItems.length - 1;

                return Column(
                  children: [
                    ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: item.isDestructive
                              ? AppColors.dangerLight
                              : AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          item.icon,
                          size: 20,
                          color: item.isDestructive
                              ? AppColors.danger
                              : AppColors.primary,
                        ),
                      ),
                      title: Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Cairo',
                          color: item.isDestructive
                              ? AppColors.danger
                              : AppColors.lightOnSurface,
                        ),
                      ),
                      subtitle: Text(
                        item.subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Cairo',
                          color: AppColors.lightOnSurfaceVariant,
                        ),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: item.isDestructive
                            ? AppColors.danger
                            : AppColors.lightOnSurfaceVariant,
                      ),
                      onTap: item.onTap,
                    ),
                    if (!isLast)
                      const Divider(
                        height: 1,
                        indent: 68,
                        color: AppColors.lightBorder,
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
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
              'Failed to load profile',
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
              onPressed: () => ref.invalidate(profileProvider),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Retry', style: TextStyle(fontFamily: 'Cairo')),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Logout',
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(fontFamily: 'Cairo')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text(
              'Logout',
              style: TextStyle(fontFamily: 'Cairo', color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });
}

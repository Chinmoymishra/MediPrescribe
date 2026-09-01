import '../../widgets/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/cupertino.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_avatar.dart';
import '../../widgets/profile_menu_tile.dart';
import '../../widgets/app_button.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: authState.when(
          data: (user) {
            if (user == null) {
              return const Center(child: Text('Not logged in'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppAvatar(
                    initials: user.name[0].toUpperCase(),
                    size: 100,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(user.name, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: AppSpacing.md),
                  Text(user.email, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: AppSpacing.lg),
                  ProfileMenuTile(
                    icon: CupertinoIcons.person,
                    title: 'Personal Information',
                    onTap: () {},
                  ),
                  ProfileMenuTile(
                    icon: CupertinoIcons.bell,
                    title: 'Notifications',
                    onTap: () {},
                  ),
                  ProfileMenuTile(
                    icon: CupertinoIcons.settings,
                    title: 'Settings',
                    onTap: () {},
                  ),
                  ProfileMenuTile(
                    icon: CupertinoIcons.info_circle,
                    title: 'About MediPrescribe',
                    onTap: () {},
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                    text: 'Logout',
                    width: double.infinity,
                    onPressed: () {
                      ref.read(authProvider.notifier).logout();
                      context.go('/welcome');
                    },
                  ),
                ],
              ),
            );
          },
          loading: () => const AppLoadingIndicator(fullScreen: true),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }
}

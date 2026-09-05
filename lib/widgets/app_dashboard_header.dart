import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/theme/app_radius.dart';
import 'app_logo.dart';
import 'app_avatar.dart';

class AppDashboardHeader extends StatelessWidget {
  final String subtitle;
  final String avatarInitials;
  final String? avatarImageUrl;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onAvatarTap;
  final bool hasNotification;

  const AppDashboardHeader({
    Key? key,
    required this.subtitle,
    required this.avatarInitials,
    this.avatarImageUrl,
    this.onNotificationTap,
    this.onAvatarTap,
    this.hasNotification = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const AppLogo(size: 36),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('MediPrescribe', style: AppTextStyles.titleMedium),
              Text(
                subtitle.toUpperCase(),
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.secondaryText,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onNotificationTap,
          child: Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(Icons.notifications_none_rounded, color: AppColors.primaryText, size: 20),
                ),
                if (hasNotification)
                  Positioned(
                    top: 9,
                    right: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: onAvatarTap,
          child: AppAvatar(
            initials: avatarInitials,
            imageUrl: avatarImageUrl,
            size: 40,
          ),
        ),
      ],
    );
  }
}

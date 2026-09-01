import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/theme/app_spacing.dart';
import '../models/patient.dart';
import 'app_avatar.dart';
import 'app_card.dart';

class PatientListTile extends StatelessWidget {
  final Patient patient;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const PatientListTile({
    Key? key,
    required this.patient,
    this.onTap,
    this.onDelete,
  }) : super(key: key);

  String get initials {
    final names = patient.name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return patient.name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      onTap: onTap,
      child: Row(
        children: [
          AppAvatar(
            initials: initials,
            size: 56,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient.name,
                  style: AppTextStyles.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xs4),
                Text(
                  '${patient.age} years • ${patient.gender.name}',
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: AppSpacing.xs4),
                Text(
                  patient.phone,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          if (onDelete != null)
            PopupMenuButton<String>(
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'delete',
                  child: const Text('Delete'),
                  onTap: onDelete,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

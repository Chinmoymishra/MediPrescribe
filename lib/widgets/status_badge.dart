import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/theme/app_radius.dart';
import '../core/theme/app_spacing.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final Color? backgroundColor;
  final Color? textColor;

  const StatusBadge({
    Key? key,
    required this.status,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  factory StatusBadge.prescription(String status) {
    Color bgColor;
    Color textColor = Colors.white;

    switch (status.toLowerCase()) {
      case 'draft':
        bgColor = Colors.grey[400]!;
        break;
      case 'sent':
        bgColor = AppColors.secondaryBlue;
        break;
      case 'completed':
        bgColor = AppColors.success;
        break;
      default:
        bgColor = AppColors.primaryBlue;
    }

    return StatusBadge(
      status: status,
      backgroundColor: bgColor,
      textColor: textColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primaryBlue,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Text(
        status,
        style: AppTextStyles.labelSmall.copyWith(
          color: textColor ?? Colors.white,
        ),
      ),
    );
  }
}

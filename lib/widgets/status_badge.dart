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
    Color textColor;

    switch (status.toLowerCase()) {
      case 'draft':
        bgColor = const Color(0xFFEEF2F1);
        textColor = AppColors.secondaryText;
        break;
      case 'sent':
        bgColor = AppColors.accentLight;
        textColor = const Color(0xFF0369A1);
        break;
      case 'completed':
        bgColor = AppColors.successLight;
        textColor = const Color(0xFF15803D);
        break;
      default:
        bgColor = AppColors.lightBlue;
        textColor = AppColors.primaryBlue;
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
        vertical: AppSpacing.xs6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.lightBlue,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        status,
        style: AppTextStyles.labelSmall.copyWith(
          color: textColor ?? AppColors.primaryBlue,
        ),
      ),
    );
  }
}

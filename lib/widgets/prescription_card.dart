import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/theme/app_spacing.dart';
import '../models/prescription.dart';
import 'app_card.dart';
import 'status_badge.dart';

class PrescriptionCard extends StatelessWidget {
  final Prescription prescription;
  final String? subtitle; // Patient name for doctor, Doctor name for patient
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const PrescriptionCard({
    Key? key,
    required this.prescription,
    this.subtitle,
    this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('dd MMM yyyy');
    
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: AppTextStyles.titleMedium,
                      ),
                    if (subtitle != null)
                      const SizedBox(height: AppSpacing.xs4),
                    Text(
                      prescription.diagnosis,
                      style: AppTextStyles.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              StatusBadge.prescription(prescription.statusDisplay),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Divider(color: AppColors.divider),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date',
                    style: AppTextStyles.labelMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs4),
                  Text(
                    dateFormatter.format(prescription.date),
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Medicines',
                    style: AppTextStyles.labelMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs4),
                  Text(
                    '${prescription.medicines.length} medicine(s)',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
              if (onEdit != null || onDelete != null)
                PopupMenuButton<String>(
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    if (onEdit != null)
                      PopupMenuItem<String>(
                        value: 'edit',
                        child: const Text('Edit'),
                        onTap: onEdit,
                      ),
                    if (onDelete != null)
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: const Text('Delete'),
                        onTap: onDelete,
                      ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

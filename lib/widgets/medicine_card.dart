import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/theme/app_spacing.dart';
import '../models/prescribed_medicine.dart';
import 'app_card.dart';

class MedicineCard extends StatelessWidget {
  final PrescribedMedicine prescribedMedicine;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MedicineCard({
    Key? key,
    required this.prescribedMedicine,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
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
                    Text(
                      prescribedMedicine.medicine.name,
                      style: AppTextStyles.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.xs4),
                    Text(
                      prescribedMedicine.medicine.strength,
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
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
          const SizedBox(height: AppSpacing.md),
          Divider(color: AppColors.divider),
          const SizedBox(height: AppSpacing.md),
          _buildDetailRow(
            'Dose',
            prescribedMedicine.dose,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildDetailRow(
            'Frequency',
            prescribedMedicine.frequencyDisplay,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildDetailRow(
            'Duration',
            prescribedMedicine.duration,
          ),
          if (prescribedMedicine.instructions.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            _buildDetailRow(
              'Instructions',
              prescribedMedicine.instructionsDisplay.join(', '),
            ),
          ],
          if (prescribedMedicine.additionalNotes != null &&
              prescribedMedicine.additionalNotes!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            _buildDetailRow(
              'Notes',
              prescribedMedicine.additionalNotes!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelMedium,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodyMedium,
          ),
        ),
      ],
    );
  }
}

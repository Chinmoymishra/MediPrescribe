import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_radius.dart';
import '../models/medicine.dart';
import 'app_loading_indicator.dart';

class MedicineSuggestionList extends StatelessWidget {
  final List<Medicine> medicines;
  final Function(Medicine) onMedicineSelected;
  final bool isLoading;

  const MedicineSuggestionList({
    Key? key,
    required this.medicines,
    required this.onMedicineSelected,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppRadius.input),
        ),
        child: const Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: SizedBox(
            height: 40,
            child: AppLoadingIndicator(size: 24),
          ),
        ),
      );
    }

    if (medicines.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppRadius.input),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Text(
            'No medicines found',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.input),
      ),
      constraints: const BoxConstraints(maxHeight: 300),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: medicines.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: AppColors.divider,
        ),
        itemBuilder: (context, index) {
          final medicine = medicines[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            title: Text(
              medicine.name,
              style: AppTextStyles.bodyMedium,
            ),
            subtitle: Text(
              '${medicine.strength} - ${medicine.form.name}',
              style: AppTextStyles.bodySmall,
            ),
            onTap: () => onMedicineSelected(medicine),
          );
        },
      ),
    );
  }
}

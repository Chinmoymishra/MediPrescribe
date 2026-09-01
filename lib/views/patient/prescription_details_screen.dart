import '../../widgets/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/prescription_provider.dart';
import '../../providers/patient_provider.dart';
import '../../widgets/app_custom_app_bar.dart';
import '../../widgets/app_card.dart';
import '../../widgets/medicine_card.dart';

class PrescriptionDetailsScreen extends ConsumerWidget {
  final String prescriptionId;

  const PrescriptionDetailsScreen({
    Key? key,
    required this.prescriptionId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prescriptionAsync = ref.watch(getPrescriptionByIdProvider(prescriptionId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppCustomAppBar(
        title: 'Prescription Details',
        showBackButton: true,
      ),
      body: SafeArea(
        child: prescriptionAsync.when(
          data: (prescription) {
            if (prescription == null) {
              return const Center(child: Text('Prescription not found'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Medical Information', style: AppTextStyles.headlineSmall),
                  const SizedBox(height: AppSpacing.md),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow('Date', DateFormat('dd MMM yyyy').format(prescription.date)),
                        const SizedBox(height: AppSpacing.md),
                        _buildDetailRow('Diagnosis', prescription.diagnosis),
                        const SizedBox(height: AppSpacing.md),
                        _buildDetailRow('Symptoms', prescription.symptoms),
                        if (prescription.notes != null && prescription.notes!.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.md),
                          _buildDetailRow('Notes', prescription.notes!),
                        ],
                        if (prescription.followUpDate != null) ...[
                          const SizedBox(height: AppSpacing.md),
                          _buildDetailRow('Follow-up Date', DateFormat('dd MMM yyyy').format(prescription.followUpDate!)),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Medicines (${prescription.medicines.length})', style: AppTextStyles.headlineSmall),
                  const SizedBox(height: AppSpacing.md),
                  ...prescription.medicines.map((medicine) => MedicineCard(prescribedMedicine: medicine)),
                  const SizedBox(height: AppSpacing.lg),
                  AppCard(
                    child: Center(
                      child: Text(
                        'Status: ${prescription.statusDisplay}',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
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

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelMedium),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(value, style: AppTextStyles.bodyMedium),
        ),
      ],
    );
  }
}

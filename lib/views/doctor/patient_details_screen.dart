import '../../widgets/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_spacing.dart';
import '../../providers/patient_provider.dart';
import '../../providers/prescription_form_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_avatar.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_custom_app_bar.dart';

class PatientDetailsScreen extends ConsumerWidget {
  final String patientId;

  const PatientDetailsScreen({
    Key? key,
    required this.patientId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientAsync = ref.watch(getPatientByIdProvider(patientId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppCustomAppBar(
        title: 'Patient Details',
        showBackButton: true,
      ),
      body: SafeArea(
        child: patientAsync.when(
          data: (patient) {
            if (patient == null) {
              return const Center(child: Text('Patient not found'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        AppAvatar(
                          initials: patient.name[0].toUpperCase(),
                          size: 100,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(patient.name, style: AppTextStyles.headlineMedium),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Personal Information', style: AppTextStyles.headlineSmall),
                  const SizedBox(height: AppSpacing.md),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Age', '${patient.age} years'),
                        const SizedBox(height: AppSpacing.md),
                        _buildInfoRow('Gender', patient.gender.name),
                        const SizedBox(height: AppSpacing.md),
                        _buildInfoRow('Blood Group', patient.bloodGroup ?? 'Not specified'),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Contact Information', style: AppTextStyles.headlineSmall),
                  const SizedBox(height: AppSpacing.md),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Phone', patient.phone),
                        const SizedBox(height: AppSpacing.md),
                        _buildInfoRow('Email', patient.email),
                        if (patient.address != null) ...[
                          const SizedBox(height: AppSpacing.md),
                          _buildInfoRow('Address', patient.address!),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                    text: 'Create Prescription',
                    width: double.infinity,
                    onPressed: () {
                      ref.read(prescriptionFormProvider.notifier).setPatientId(patientId);
                      context.push('/prescription/create');
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

  Widget _buildInfoRow(String label, String value) {
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

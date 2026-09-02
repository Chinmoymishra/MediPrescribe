import '../../widgets/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/prescription.dart';
import '../../models/doctor.dart';
import '../../providers/prescription_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/patient_provider.dart';
import '../../utils/prescription_pdf_generator.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_custom_app_bar.dart';
import '../../widgets/app_card.dart';
import '../../widgets/medicine_card.dart';

class PrescriptionPreviewScreen extends ConsumerStatefulWidget {
  final String prescriptionId;

  const PrescriptionPreviewScreen({
    Key? key,
    required this.prescriptionId,
  }) : super(key: key);

  @override
  ConsumerState<PrescriptionPreviewScreen> createState() => _PrescriptionPreviewScreenState();
}

class _PrescriptionPreviewScreenState extends ConsumerState<PrescriptionPreviewScreen> {
  bool _isPrinting = false;

  Future<void> _handlePrint(Prescription prescription) async {
    if (_isPrinting) return;
    setState(() => _isPrinting = true);

    try {
      final doctor = ref.read(authProvider).value;
      final patient = await ref.read(getPatientByIdProvider(prescription.patientId).future);

      if (doctor is! Doctor || patient == null) {
        throw Exception('Missing doctor or patient information');
      }

      final pdfDoc = await PrescriptionPdfGenerator.generate(
        prescription: prescription,
        doctor: doctor,
        patient: patient,
      );

      await Printing.layoutPdf(
        onLayout: (format) => pdfDoc.save(),
        name: 'Prescription_${prescription.id}',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open print dialog: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isPrinting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final prescriptionAsync = ref.watch(getPrescriptionByIdProvider(widget.prescriptionId));
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppCustomAppBar(
        title: 'Prescription Preview',
        showBackButton: true,
      ),
      body: prescriptionAsync.when(
        data: (prescription) {
          if (prescription == null) {
            return const Center(child: Text('Prescription not found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with logo and title
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Rx',
                            style: AppTextStyles.displayMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text('MediPrescribe', style: AppTextStyles.headlineLarge),
                      Text('Digital Prescription', style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Divider(color: AppColors.divider),
                const SizedBox(height: AppSpacing.lg),

                // Doctor Information
                Text('Doctor Information', style: AppTextStyles.headlineSmall),
                const SizedBox(height: AppSpacing.md),
                Consumer(
                  builder: (context, ref, _) {
                    final doctorAsync = ref.watch(authProvider);
                    return doctorAsync.when(
                      data: (doctor) => AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(doctor?.name ?? 'Doctor', style: AppTextStyles.titleMedium),
                            const SizedBox(height: AppSpacing.xs4),
                            Text((doctor is Doctor ? doctor.specialization : null) ?? '', style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                      loading: () => const AppLoadingIndicator(size: 24),
                      error: (err, stack) => Text('Error: $err'),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.lg),

                // Patient Information
                Text('Patient Information', style: AppTextStyles.headlineSmall),
                const SizedBox(height: AppSpacing.md),
                Consumer(
                  builder: (context, ref, _) {
                    final patientAsync = ref.watch(getPatientByIdProvider(prescription.patientId));
                    return patientAsync.when(
                      data: (patient) => AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(patient?.name ?? 'Patient', style: AppTextStyles.titleMedium),
                            const SizedBox(height: AppSpacing.xs4),
                            Text('Age: ${patient?.age ?? 0} | Gender: ${patient?.gender.name ?? ''}', style: AppTextStyles.bodySmall),
                            const SizedBox(height: AppSpacing.xs4),
                            Text('Phone: ${patient?.phone ?? ''}', style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                      loading: () => const AppLoadingIndicator(size: 24),
                      error: (err, stack) => Text('Error: $err'),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.lg),

                // Medical Details
                Text('Medical Details', style: AppTextStyles.headlineSmall),
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

                // Medicines
                Text('Medicines (${prescription.medicines.length})', style: AppTextStyles.headlineSmall),
                const SizedBox(height: AppSpacing.md),
                ...prescription.medicines.map((medicine) => MedicineCard(prescribedMedicine: medicine)),
                const SizedBox(height: AppSpacing.lg),

                // Action Buttons
                AppButton(
                  text: 'Print',
                  width: double.infinity,
                  isLoading: _isPrinting,
                  icon: const Icon(Icons.print, color: Colors.white, size: 18),
                  onPressed: () => _handlePrint(prescription),
                ),
                if (prescription.status == PrescriptionStatus.draft) ...[
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    text: 'Send Prescription',
                    width: double.infinity,
                    onPressed: () {
                      final updatedPrescription = prescription.copyWith(
                        status: PrescriptionStatus.sent,
                      );
                      ref.read(prescriptionsNotifierProvider.notifier).updatePrescription(updatedPrescription);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Prescription sent successfully!')),
                      );
                      Future.delayed(const Duration(seconds: 1), () {
                        context.go('/doctor/prescriptions');
                      });
                    },
                  ),
                ] else ...[
                  const SizedBox(height: AppSpacing.md),
                  AppCard(
                    child: Center(
                      child: Text(
                        'Prescription ${prescription.statusDisplay}',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        loading: () => const AppLoadingIndicator(fullScreen: true),
        error: (err, stack) => Center(child: Text('Error: $err')),
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

import '../../widgets/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../models/prescription.dart';
import '../../providers/prescription_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_custom_app_bar.dart';
import '../../widgets/prescription_card.dart';
import '../../widgets/app_button.dart';

class PrescriptionHistoryScreen extends ConsumerStatefulWidget {
  const PrescriptionHistoryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PrescriptionHistoryScreen> createState() => _PrescriptionHistoryScreenState();
}

class _PrescriptionHistoryScreenState extends ConsumerState<PrescriptionHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final filteredPrescriptionsAsync = ref.watch(filteredPrescriptionsByDateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppCustomAppBar(
        title: 'Prescription History',
        showBackButton: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('All'),
                    const SizedBox(width: AppSpacing.md),
                    _buildFilterChip('Today'),
                    const SizedBox(width: AppSpacing.md),
                    _buildFilterChip('This Week'),
                    const SizedBox(width: AppSpacing.md),
                    _buildFilterChip('This Month'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: filteredPrescriptionsAsync.when(
                  data: (prescriptions) {
                    final doctorPrescriptions = authState.whenData((user) {
                      return prescriptions.where((p) => p.doctorId == user?.id).toList();
                    }).value ?? [];

                    return doctorPrescriptions.isNotEmpty
                        ? ListView.builder(
                            itemCount: doctorPrescriptions.length,
                            itemBuilder: (context, index) {
                              final prescription = doctorPrescriptions[index];
                              return PrescriptionCard(
                                prescription: prescription,
                                onTap: () => context.push('/prescription/${prescription.id}/preview'),
                              );
                            },
                          )
                        : Center(
                            child: Text('No prescriptions found'),
                          );
                  },
                  loading: () => const AppLoadingIndicator(fullScreen: true),
                  error: (err, stack) => Center(child: Text('Error: $err')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final filterValue = label == 'All'
        ? PrescriptionFilter.all
        : label == 'Today'
            ? PrescriptionFilter.today
            : label == 'This Week'
                ? PrescriptionFilter.thisWeek
                : PrescriptionFilter.thisMonth;

    return FilterChip(
      label: Text(label),
      onSelected: (selected) {
        ref.read(prescriptionFilterProvider.notifier).state = filterValue;
      },
    );
  }
}

import '../../widgets/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_spacing.dart';
import '../../providers/patient_provider.dart';
import '../../widgets/app_custom_app_bar.dart';
import '../../widgets/app_search_field.dart';
import '../../widgets/patient_list_tile.dart';
import '../../widgets/app_button.dart';

class PatientManagementScreen extends ConsumerStatefulWidget {
  const PatientManagementScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PatientManagementScreen> createState() => _PatientManagementScreenState();
}

class _PatientManagementScreenState extends ConsumerState<PatientManagementScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredPatientsAsync = ref.watch(filteredPatientsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppCustomAppBar(
        title: 'My Patients',
        showBackButton: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: AppSearchField(
                      hint: 'Search patients...',
                      controller: _searchController,
                      onChanged: (query) {
                        ref.read(patientSearchQueryProvider.notifier).state = query;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: filteredPatientsAsync.when(
                  data: (patients) => patients.isNotEmpty
                      ? ListView.builder(
                          itemCount: patients.length,
                          itemBuilder: (context, index) {
                            final patient = patients[index];
                            return PatientListTile(
                              patient: patient,
                              onTap: () => context.push('/doctor/patient/${patient.id}'),
                            );
                          },
                        )
                      : Center(
                          child: Text('No patients found', style: AppTextStyles.bodyMedium),
                        ),
                  loading: () => const AppLoadingIndicator(fullScreen: true),
                  error: (err, stack) => Center(child: Text('Error: $err')),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                text: 'Add New Patient',
                width: double.infinity,
                onPressed: () => context.push('/doctor/add-patient'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

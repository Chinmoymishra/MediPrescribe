import '../../widgets/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_radius.dart';
import '../../models/user.dart';
import '../../providers/auth_provider.dart';
import '../../providers/patient_provider.dart';
import '../../providers/prescription_provider.dart';
import '../../providers/prescription_form_provider.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_avatar.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_bottom_navigation.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/patient_list_tile.dart';
import '../../widgets/prescription_card.dart';
import '../../widgets/app_dashboard_header.dart';

class DoctorDashboard extends ConsumerStatefulWidget {
  const DoctorDashboard({Key? key}) : super(key: key);

  @override
  ConsumerState<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends ConsumerState<DoctorDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final patientsAsync = ref.watch(patientsProvider);
    final prescriptionsAsync = ref.watch(allPrescriptionsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: authState.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Not logged in'));
          }

          return SafeArea(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _buildHomeTab(context, user, patientsAsync, prescriptionsAsync),
                _buildPatientsTab(context),
                _buildPrescriptionsTab(context),
                _buildProfileTab(context, user),
              ],
            ),
          );
        },
        loading: () => const AppLoadingIndicator(fullScreen: true),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        onCenterActionTap: () {
          ref.read(prescriptionFormProvider.notifier).reset();
          context.push('/prescription/create');
        },
        centerActionIcon: CupertinoIcons.doc_text_fill,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house),
            activeIcon: Icon(CupertinoIcons.house_fill),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_2),
            activeIcon: Icon(CupertinoIcons.person_2_fill),
            label: 'Patients',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.doc_text),
            activeIcon: Icon(CupertinoIcons.doc_text_fill),
            label: 'Prescriptions',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_crop_circle),
            activeIcon: Icon(CupertinoIcons.person_crop_circle_fill),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab(BuildContext context, dynamic user, AsyncValue patientsAsync, AsyncValue prescriptionsAsync) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppDashboardHeader(
            subtitle: 'Dashboard',
            avatarInitials: user.name[0].toUpperCase(),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Back',
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs4),
                  Text(
                    user.name,
                    style: AppTextStyles.headlineMedium,
                  ),
                ],
              ),
              AppAvatar(
                initials: user.name[0].toUpperCase(),
                size: 56,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          patientsAsync.when(
            data: (patients) => _buildSummaryCards(patients.length),
            loading: () => const SizedBox(height: 100, child: AppLoadingIndicator(size: 28)),
            error: (err, stack) => Text('Error: $err'),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildQuickActions(context),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(int patientCount) {
    return Column(
      children: [
        AppCard(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Patients', style: AppTextStyles.bodyMedium),
                  const Icon(CupertinoIcons.person_2, color: AppColors.primaryBlue),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(patientCount.toString(), style: AppTextStyles.displaySmall),
            ],
          ),
        ),
        AppCard(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Prescriptions Today', style: AppTextStyles.bodyMedium),
                  const Icon(CupertinoIcons.doc_text, color: AppColors.primaryBlue),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text('3', style: AppTextStyles.displaySmall),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: AppTextStyles.headlineSmall),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: Consumer(
                builder: (context, ref, _) => _QuickActionButton(
                  icon: Icons.description_outlined,
                  label: 'Create\nPrescription',
                  onTap: () {
                    ref.read(prescriptionFormProvider.notifier).reset();
                    context.push('/prescription/create');
                  },
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.person_add_alt_outlined,
                label: 'Add\nPatient',
                onTap: () => context.push('/doctor/add-patient'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPatientsTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Patients', style: AppTextStyles.headlineLarge),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            text: 'Add New Patient',
            width: double.infinity,
            onPressed: () => context.push('/doctor/add-patient'),
          ),
          const SizedBox(height: AppSpacing.lg),
          Consumer(
            builder: (context, ref, child) {
              final patientsAsync = ref.watch(patientsProvider);
              return patientsAsync.when(
                data: (patients) => patients.isEmpty
                    ? AppEmptyState(
                        icon: CupertinoIcons.person_2,
                        title: 'No patients yet',
                        description: 'Patients you add will appear here.',
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: patients.length,
                        itemBuilder: (context, index) {
                          final patient = patients[index];
                          return PatientListTile(
                            patient: patient,
                            onTap: () => context.push('/doctor/patient/${patient.id}'),
                          );
                        },
                      ),
                loading: () => const AppLoadingIndicator(size: 24),
                error: (err, stack) => Text('Error: $err'),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionsTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Prescriptions', style: AppTextStyles.headlineLarge),
          const SizedBox(height: AppSpacing.lg),
          Consumer(
            builder: (context, ref, child) {
              final prescriptionsAsync = ref.watch(allPrescriptionsProvider);
              return prescriptionsAsync.when(
                data: (prescriptions) => prescriptions.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: prescriptions.length,
                        itemBuilder: (context, index) {
                          final prescription = prescriptions[index];
                          return PrescriptionCard(
                            prescription: prescription,
                            onTap: () => context.push('/prescription/${prescription.id}/preview'),
                          );
                        },
                      )
                    : AppEmptyState(
                        icon: CupertinoIcons.doc_text,
                        title: 'No prescriptions yet',
                        description: 'Prescriptions you create will appear here.',
                      ),
                loading: () => const AppLoadingIndicator(size: 24),
                error: (err, stack) => Text('Error: $err'),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab(BuildContext context, dynamic user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 100),
      child: Column(
        children: [
          AppAvatar(
            initials: user.name[0].toUpperCase(),
            size: 100,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(user.name, style: AppTextStyles.headlineMedium),
          const SizedBox(height: AppSpacing.xs4),
          Text(user.specialization, style: AppTextStyles.bodyMedium),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            text: 'Logout',
            width: double.infinity,
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              context.go('/welcome');
            },
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.labelMedium.copyWith(color: AppColors.primaryText),
            ),
          ],
        ),
      ),
    );
  }
}

import '../../widgets/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_spacing.dart';
import '../../providers/auth_provider.dart';
import '../../providers/prescription_provider.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_avatar.dart';
import '../../widgets/app_bottom_navigation.dart';

class PatientDashboard extends ConsumerStatefulWidget {
  const PatientDashboard({Key? key}) : super(key: key);

  @override
  ConsumerState<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends ConsumerState<PatientDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: authState.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Not logged in'));
          }

          return SafeArea(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _buildHomeTab(context, user),
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house),
            activeIcon: Icon(CupertinoIcons.house_fill),
            label: 'Home',
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

  Widget _buildHomeTab(BuildContext context, dynamic user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Text('Your Prescriptions', style: AppTextStyles.headlineSmall),
          const SizedBox(height: AppSpacing.md),
          Consumer(
            builder: (context, ref, _) {
              final prescriptionsAsync = ref.watch(prescriptionsByPatientIdProvider(user.id));
              return prescriptionsAsync.when(
                data: (prescriptions) => prescriptions.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: prescriptions.length,
                        itemBuilder: (context, index) {
                          final prescription = prescriptions[index];
                          return AppCard(
                            margin: const EdgeInsets.only(bottom: AppSpacing.md),
                            padding: const EdgeInsets.all(AppSpacing.md),
                            onTap: () => context.push('/patient/prescription/${prescription.id}'),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(prescription.diagnosis, style: AppTextStyles.titleMedium),
                                const SizedBox(height: AppSpacing.xs4),
                                Text('${prescription.medicines.length} medicines', style: AppTextStyles.bodySmall),
                              ],
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Text('No prescriptions yet', style: AppTextStyles.bodyMedium),
                        ),
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
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('My Prescriptions', style: AppTextStyles.headlineLarge),
          const SizedBox(height: AppSpacing.lg),
          Consumer(
            builder: (context, ref, _) {
              final authState = ref.watch(authProvider);
              final user = authState.value;
              
              if (user == null) return const Text('Not logged in');

              final prescriptionsAsync = ref.watch(prescriptionsByPatientIdProvider(user.id));
              return prescriptionsAsync.when(
                data: (prescriptions) => prescriptions.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: prescriptions.length,
                        itemBuilder: (context, index) {
                          final prescription = prescriptions[index];
                          return AppCard(
                            margin: const EdgeInsets.only(bottom: AppSpacing.md),
                            padding: const EdgeInsets.all(AppSpacing.md),
                            onTap: () => context.push('/patient/prescription/${prescription.id}'),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(prescription.diagnosis, style: AppTextStyles.titleMedium),
                                const SizedBox(height: AppSpacing.xs4),
                                Text('${prescription.medicines.length} medicines', style: AppTextStyles.bodySmall),
                              ],
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text('No prescriptions yet'),
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
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          AppAvatar(
            initials: user.name[0].toUpperCase(),
            size: 100,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(user.name, style: AppTextStyles.headlineMedium),
          const SizedBox(height: AppSpacing.xs4),
          Text('${user.age} years old', style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}

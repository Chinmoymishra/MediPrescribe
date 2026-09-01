import '../../widgets/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../providers/prescription_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_custom_app_bar.dart';
import '../../widgets/prescription_card.dart';

class PrescriptionListScreen extends ConsumerWidget {
  const PrescriptionListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.value;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Not logged in')),
      );
    }

    final prescriptionsAsync = ref.watch(prescriptionsByPatientIdProvider(user.id));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppCustomAppBar(
        title: 'My Prescriptions',
        showBackButton: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: prescriptionsAsync.when(
            data: (prescriptions) => prescriptions.isNotEmpty
                ? ListView.builder(
                    itemCount: prescriptions.length,
                    itemBuilder: (context, index) {
                      final prescription = prescriptions[index];
                      return PrescriptionCard(
                        prescription: prescription,
                        onTap: () => context.push('/patient/prescription/${prescription.id}'),
                      );
                    },
                  )
                : Center(
                    child: Text('No prescriptions yet'),
                  ),
            loading: () => const AppLoadingIndicator(fullScreen: true),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
        ),
      ),
    );
  }
}

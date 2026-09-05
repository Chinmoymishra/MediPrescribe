import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/theme/app_spacing.dart';
import '../models/user.dart';
import '../widgets/app_button.dart';
import '../widgets/app_logo.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: AppSpacing.lg),
              Column(
                children: [
                  const AppLogo(size: 120),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Welcome to MediPrescribe',
                    style: AppTextStyles.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Digital prescription management made simple and secure',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.secondaryText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Column(
                children: [
                  AppButton(
                    text: 'Continue as Doctor',
                    width: double.infinity,
                    onPressed: () {
                      context.push('/login', extra: UserRole.doctor);
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    text: 'Continue as Patient',
                    width: double.infinity,
                    onPressed: () {
                      context.push('/login', extra: UserRole.patient);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

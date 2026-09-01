import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_custom_app_bar.dart';

class DoctorSignUpScreen extends ConsumerStatefulWidget {
  const DoctorSignUpScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DoctorSignUpScreen> createState() => _DoctorSignUpScreenState();
}

class _DoctorSignUpScreenState extends ConsumerState<DoctorSignUpScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _registrationController;
  late TextEditingController _specializationController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  String? _nameError;
  String? _emailError;
  String? _phoneError;
  String? _registrationError;
  String? _specializationError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _registrationController = TextEditingController();
    _specializationController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _registrationController.dispose();
    _specializationController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    setState(() {
      _nameError = null;
      _emailError = null;
      _phoneError = null;
      _registrationError = null;
      _specializationError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });

    bool isValid = true;

    if (_nameController.text.isEmpty) {
      setState(() => _nameError = 'Name is required');
      isValid = false;
    }

    if (_emailController.text.isEmpty) {
      setState(() => _emailError = 'Email is required');
      isValid = false;
    }

    if (_phoneController.text.isEmpty) {
      setState(() => _phoneError = 'Phone is required');
      isValid = false;
    }

    if (_registrationController.text.isEmpty) {
      setState(() => _registrationError = 'Registration number is required');
      isValid = false;
    }

    if (_specializationController.text.isEmpty) {
      setState(() => _specializationError = 'Specialization is required');
      isValid = false;
    }

    if (_passwordController.text.isEmpty) {
      setState(() => _passwordError = 'Password is required');
      isValid = false;
    } else if (_passwordController.text.length < 6) {
      setState(() => _passwordError = 'Password must be at least 6 characters');
      isValid = false;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _confirmPasswordError = 'Passwords do not match');
      isValid = false;
    }

    return isValid;
  }

  void _handleSignUp() async {
    if (!_validateForm()) return;

    final authNotifier = ref.read(authProvider.notifier);

    try {
      await authNotifier.signUpDoctor(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        registrationNumber: _registrationController.text,
        specialization: _specializationController.text,
        password: _passwordController.text,
      );

      ref.read(authProvider).whenData((user) {
        if (user != null) {
          context.go('/doctor/dashboard');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email already exists')),
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppCustomAppBar(
        title: 'Doctor Sign Up',
        showBackButton: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Full Name',
                  hint: 'Enter your name',
                  controller: _nameController,
                  errorText: _nameError,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: 'Email',
                  hint: 'Enter your email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  errorText: _emailError,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: 'Phone',
                  hint: 'Enter your phone number',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  errorText: _phoneError,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: 'Medical Registration Number',
                  hint: 'e.g., MR-001234',
                  controller: _registrationController,
                  errorText: _registrationError,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: 'Specialization',
                  hint: 'e.g., General Medicine',
                  controller: _specializationController,
                  errorText: _specializationError,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: 'Password',
                  hint: 'Enter password (min 6 characters)',
                  controller: _passwordController,
                  obscureText: true,
                  errorText: _passwordError,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: 'Confirm Password',
                  hint: 'Confirm your password',
                  controller: _confirmPasswordController,
                  obscureText: true,
                  errorText: _confirmPasswordError,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  text: 'Create Account',
                  width: double.infinity,
                  onPressed: _handleSignUp,
                  isLoading: isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

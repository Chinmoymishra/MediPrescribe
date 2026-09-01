import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../models/patient.dart';
import '../../providers/patient_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_custom_app_bar.dart';

class AddPatientScreen extends ConsumerStatefulWidget {
  const AddPatientScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends ConsumerState<AddPatientScreen> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _bloodGroupController;
  late TextEditingController _addressController;

  Gender _selectedGender = Gender.male;
  String? _nameError;
  String? _ageError;
  String? _phoneError;
  String? _emailError;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _bloodGroupController = TextEditingController();
    _addressController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _bloodGroupController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    setState(() {
      _nameError = null;
      _ageError = null;
      _phoneError = null;
      _emailError = null;
    });

    bool isValid = true;

    if (_nameController.text.isEmpty) {
      setState(() => _nameError = 'Name is required');
      isValid = false;
    }

    if (_phoneController.text.isEmpty) {
      setState(() => _phoneError = 'Phone is required');
      isValid = false;
    }

    return isValid;
  }

  void _handleAddPatient() async {
    if (!_validateForm()) return;

    final dob = DateTime.now().subtract(Duration(days: int.parse(_ageController.text) * 365));
    final patient = Patient(
      id: 'patient_${const Uuid().v4()}',
      name: _nameController.text,
      email: _emailController.text.isEmpty ? 'patient@example.com' : _emailController.text,
      phone: _phoneController.text,
      dateOfBirth: dob,
      gender: _selectedGender,
      bloodGroup: _bloodGroupController.text.isEmpty ? null : _bloodGroupController.text,
      address: _addressController.text.isEmpty ? null : _addressController.text,
    );

    try {
      await ref.read(patientsNotifierProvider.notifier).addPatient(patient);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Patient added successfully')),
      );
      context.pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppCustomAppBar(
        title: 'Add Patient',
        showBackButton: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppTextField(
                  label: 'Full Name',
                  hint: 'Enter patient name',
                  controller: _nameController,
                  errorText: _nameError,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: 'Age',
                  hint: 'Enter age',
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  errorText: _ageError,
                ),
                const SizedBox(height: AppSpacing.lg),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Gender'),
                    const SizedBox(height: 8),
                    DropdownButton<Gender>(
                      value: _selectedGender,
                      isExpanded: true,
                      items: Gender.values.map((gender) {
                        return DropdownMenuItem<Gender>(
                          value: gender,
                          child: Text(gender.name),
                        );
                      }).toList(),
                      onChanged: (Gender? newValue) {
                        if (newValue != null) {
                          setState(() => _selectedGender = newValue);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: 'Phone',
                  hint: 'Enter phone number',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  errorText: _phoneError,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: 'Email (Optional)',
                  hint: 'Enter email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: 'Blood Group (Optional)',
                  hint: 'e.g., O+, A-, B+',
                  controller: _bloodGroupController,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: 'Address (Optional)',
                  hint: 'Enter address',
                  controller: _addressController,
                  maxLines: 2,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  text: 'Add Patient',
                  width: double.infinity,
                  onPressed: _handleAddPatient,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

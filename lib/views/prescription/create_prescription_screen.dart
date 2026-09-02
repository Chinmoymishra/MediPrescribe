import '../../widgets/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/patient.dart';
import '../../models/prescribed_medicine.dart';
import '../../models/prescription.dart';
import '../../providers/auth_provider.dart';
import '../../providers/medicine_provider.dart';
import '../../providers/patient_provider.dart';
import '../../providers/prescription_provider.dart';
import '../../providers/prescription_form_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_custom_app_bar.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_search_field.dart';
import '../../widgets/app_card.dart';
import '../../widgets/medicine_suggestion_list.dart';
import '../../widgets/medicine_card.dart';

class CreatePrescriptionScreen extends ConsumerStatefulWidget {
  const CreatePrescriptionScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CreatePrescriptionScreen> createState() => _CreatePrescriptionScreenState();
}

class _CreatePrescriptionScreenState extends ConsumerState<CreatePrescriptionScreen> {
  late TextEditingController _patientSearchController;
  late TextEditingController _medicineSearchController;
  late TextEditingController _diagnosisController;
  late TextEditingController _symptomsController;
  late TextEditingController _notesController;
  late TextEditingController _doseController;
  late TextEditingController _durationController;

  // New patient controllers
  late TextEditingController _newNameController;
  late TextEditingController _newAgeController;
  late TextEditingController _newPhoneController;
  late TextEditingController _newEmailController;
  late TextEditingController _newBloodGroupController;
  late TextEditingController _newAddressController;

  bool _showMedicineSuggestions = false;
  bool _showPatientSuggestions = false;
  List<Instruction> _selectedInstructions = [];
  Frequency _selectedFrequency = Frequency.onceDaily;

  bool _isSaving = false;
  bool _isLoadingHistory = false;
  Patient? _selectedPatient;
  String? _autoFillMessage;

  @override
  void initState() {
    super.initState();
    _patientSearchController = TextEditingController();
    _medicineSearchController = TextEditingController();
    _diagnosisController = TextEditingController();
    _symptomsController = TextEditingController();
    _notesController = TextEditingController();
    _doseController = TextEditingController();
    _durationController = TextEditingController();
    _newNameController = TextEditingController();
    _newAgeController = TextEditingController();
    _newPhoneController = TextEditingController();
    _newEmailController = TextEditingController();
    _newBloodGroupController = TextEditingController();
    _newAddressController = TextEditingController();

    // If a patient was already selected before navigating here (e.g. from
    // Patient Details), reflect it in the local controllers/state.
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncFromExistingSelection());
  }

  Future<void> _syncFromExistingSelection() async {
    final formState = ref.read(prescriptionFormProvider);
    if (formState.patientType == PatientType.existing && formState.patientId != null) {
      final patient = await ref.read(getPatientByIdProvider(formState.patientId!).future);
      if (patient != null && mounted) {
        setState(() {
          _selectedPatient = patient;
          _patientSearchController.text = patient.name;
        });
      }
    }
  }

  @override
  void dispose() {
    _patientSearchController.dispose();
    _medicineSearchController.dispose();
    _diagnosisController.dispose();
    _symptomsController.dispose();
    _notesController.dispose();
    _doseController.dispose();
    _durationController.dispose();
    _newNameController.dispose();
    _newAgeController.dispose();
    _newPhoneController.dispose();
    _newEmailController.dispose();
    _newBloodGroupController.dispose();
    _newAddressController.dispose();
    super.dispose();
  }

  void _syncPrescriptionControllers(PrescriptionFormState formState) {
    if (_diagnosisController.text != formState.diagnosis) {
      _diagnosisController.text = formState.diagnosis;
    }
    if (_symptomsController.text != formState.symptoms) {
      _symptomsController.text = formState.symptoms;
    }
    if (_notesController.text != (formState.notes ?? '')) {
      _notesController.text = formState.notes ?? '';
    }
  }

  Future<void> _selectExistingPatient(Patient patient) async {
    setState(() {
      _selectedPatient = patient;
      _showPatientSuggestions = false;
      _patientSearchController.text = patient.name;
      _isLoadingHistory = true;
      _autoFillMessage = null;
    });

    ref.read(prescriptionFormProvider.notifier).setPatientId(patient.id);

    try {
      final history = await ref.read(prescriptionsByPatientIdProvider(patient.id).future);
      if (!mounted) return;

      if (history.isNotEmpty) {
        final sorted = [...history]..sort((a, b) => b.date.compareTo(a.date));
        final latest = sorted.first;
        ref.read(prescriptionFormProvider.notifier).applyPreviousPrescription(latest);
        setState(() {
          _autoFillMessage = 'Auto-filled from prescription on ${latest.date.day}/${latest.date.month}/${latest.date.year}. You can edit any field.';
        });
      } else {
        setState(() {
          _autoFillMessage = 'No previous prescription found for this patient. Enter new prescription details.';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not load patient history: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoadingHistory = false);
    }
  }

  Future<void> _handleReset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Form?'),
        content: const Text(
          'This will clear the auto-filled diagnosis, symptoms, medicines and notes. '
          'The selected patient will be kept. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    ref.read(prescriptionFormProvider.notifier).resetPrescriptionFields();
    setState(() {
      _diagnosisController.clear();
      _symptomsController.clear();
      _notesController.clear();
      _autoFillMessage = null;
    });
  }

  void _addMedicine(medicine) {
    if (_doseController.text.isEmpty || _durationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter dose and duration')),
      );
      return;
    }

    final prescribedMedicine = PrescribedMedicine(
      id: const Uuid().v4(),
      medicine: medicine,
      dose: _doseController.text,
      frequency: _selectedFrequency,
      duration: _durationController.text,
      instructions: _selectedInstructions,
    );

    ref.read(prescriptionFormProvider.notifier).addMedicine(prescribedMedicine);

    _medicineSearchController.clear();
    _doseController.clear();
    _durationController.clear();
    _selectedInstructions = [];
    setState(() => _showMedicineSuggestions = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Medicine added')),
    );
  }

  bool _validateNewPatientFields(PrescriptionFormState formState) {
    if (formState.newPatientName.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the patient\'s name')),
      );
      return false;
    }
    if (formState.newPatientAge.trim().isEmpty || int.tryParse(formState.newPatientAge.trim()) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid age')),
      );
      return false;
    }
    if (formState.newPatientPhone.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a phone number')),
      );
      return false;
    }
    return true;
  }

  Future<void> _savePrescription() async {
    if (_isSaving) return; // guard against duplicate submits

    final formState = ref.read(prescriptionFormProvider);

    if (formState.patientType == PatientType.existing && formState.patientId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a patient')),
      );
      return;
    }

    if (formState.patientType == PatientType.newPatient && !_validateNewPatientFields(formState)) {
      return;
    }

    if (formState.diagnosis.trim().isEmpty || formState.symptoms.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    if (formState.medicines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one medicine')),
      );
      return;
    }

    final authState = ref.read(authProvider).value;
    if (authState == null) return;

    setState(() => _isSaving = true);

    try {
      String patientId;

      if (formState.patientType == PatientType.newPatient) {
        final dob = DateTime.now().subtract(
          Duration(days: int.parse(formState.newPatientAge.trim()) * 365),
        );
        final newPatient = Patient(
          id: 'patient_${const Uuid().v4()}',
          name: formState.newPatientName.trim(),
          email: formState.newPatientEmail.trim().isEmpty
              ? 'patient@example.com'
              : formState.newPatientEmail.trim(),
          phone: formState.newPatientPhone.trim(),
          dateOfBirth: dob,
          gender: formState.newPatientGender,
          bloodGroup: (formState.newPatientBloodGroup?.trim().isEmpty ?? true)
              ? null
              : formState.newPatientBloodGroup!.trim(),
          address: (formState.newPatientAddress?.trim().isEmpty ?? true)
              ? null
              : formState.newPatientAddress!.trim(),
        );
        await ref.read(patientsNotifierProvider.notifier).addPatient(newPatient);
        patientId = newPatient.id;
      } else {
        patientId = formState.patientId!;
      }

      final prescription = Prescription(
        id: 'rx_${const Uuid().v4()}',
        doctorId: authState.id,
        patientId: patientId,
        date: DateTime.now(),
        diagnosis: formState.diagnosis.trim(),
        symptoms: formState.symptoms.trim(),
        medicines: formState.medicines,
        notes: formState.notes,
        followUpDate: formState.followUpDate,
        status: PrescriptionStatus.draft,
      );

      await ref.read(prescriptionsNotifierProvider.notifier).addPrescription(prescription);
      ref.read(prescriptionFormProvider.notifier).reset();

      if (mounted) {
        context.pushReplacement('/prescription/${prescription.id}/preview', extra: prescription);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving prescription: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final medicineSuggestionsAsync = ref.watch(medicineSuggestionsProvider);
    final formState = ref.watch(prescriptionFormProvider);
    _syncPrescriptionControllers(formState);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppCustomAppBar(
        title: 'Create Prescription',
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPatientTypeSection(formState),
              const SizedBox(height: AppSpacing.lg),
              if (formState.patientType == PatientType.existing)
                _buildExistingPatientSection(formState)
              else
                _buildNewPatientSection(formState),
              const SizedBox(height: AppSpacing.lg),
              if (formState.patientId != null || formState.patientType == PatientType.newPatient) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Prescription Details', style: AppTextStyles.headlineSmall),
                    TextButton.icon(
                      onPressed: _isSaving ? null : _handleReset,
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Reset Form'),
                    ),
                  ],
                ),
                if (_autoFillMessage != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  AppCard(
                    backgroundColor: AppColors.lightBlue,
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: AppColors.primaryBlue, size: 18),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(_autoFillMessage!, style: AppTextStyles.bodySmall),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                Text('Medical Details', style: AppTextStyles.headlineSmall),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Diagnosis *',
                  hint: 'Enter diagnosis',
                  controller: _diagnosisController,
                  onChanged: (value) {
                    ref.read(prescriptionFormProvider.notifier).setDiagnosis(value);
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: 'Symptoms *',
                  hint: 'Enter symptoms',
                  controller: _symptomsController,
                  maxLines: 2,
                  onChanged: (value) {
                    ref.read(prescriptionFormProvider.notifier).setSymptoms(value);
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('Add Medicines', style: AppTextStyles.headlineSmall),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _medicineSearchController,
                  onChanged: (value) {
                    ref.read(medicineSearchQueryProvider.notifier).state = value;
                    setState(() => _showMedicineSuggestions = value.isNotEmpty);
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search medicine...',
                    labelText: 'Search Medicine',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                if (_showMedicineSuggestions)
                  medicineSuggestionsAsync.when(
                    data: (medicines) => MedicineSuggestionList(
                      medicines: medicines,
                      onMedicineSelected: (medicine) {
                        setState(() => _showMedicineSuggestions = false);
                        _medicineSearchController.clear();
                        _showMedicineDetailsForm(medicine);
                      },
                    ),
                    loading: () => const AppLoadingIndicator(fullScreen: true),
                    error: (err, stack) => Text('Error: $err'),
                  ),
                const SizedBox(height: AppSpacing.lg),
                Text('Added Medicines (${formState.medicines.length})', style: AppTextStyles.headlineSmall),
                const SizedBox(height: AppSpacing.md),
                if (formState.medicines.isEmpty)
                  AppCard(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Text('No medicines added yet', style: AppTextStyles.bodyMedium),
                      ),
                    ),
                  )
                else
                  ...formState.medicines.map((medicine) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: MedicineCard(
                          prescribedMedicine: medicine,
                          onDelete: () {
                            ref.read(prescriptionFormProvider.notifier).removeMedicine(medicine.id);
                          },
                        ),
                      )),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: 'Additional Notes (Optional)',
                  hint: 'Enter any additional notes',
                  controller: _notesController,
                  maxLines: 3,
                  onChanged: (value) {
                    ref.read(prescriptionFormProvider.notifier).setNotes(value);
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  text: 'Print & Save',
                  width: double.infinity,
                  isLoading: _isSaving,
                  icon: const Icon(Icons.print, color: Colors.white, size: 18),
                  onPressed: _savePrescription,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientTypeSection(PrescriptionFormState formState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Patient Type', style: AppTextStyles.headlineSmall),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _buildPatientTypeOption(
                label: 'Existing Patient',
                selected: formState.patientType == PatientType.existing,
                onTap: () {
                  ref.read(prescriptionFormProvider.notifier).setPatientType(PatientType.existing);
                  setState(() {
                    _selectedPatient = null;
                    _patientSearchController.clear();
                    _autoFillMessage = null;
                  });
                },
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildPatientTypeOption(
                label: 'New Patient',
                selected: formState.patientType == PatientType.newPatient,
                onTap: () {
                  ref.read(prescriptionFormProvider.notifier).setPatientType(PatientType.newPatient);
                  setState(() {
                    _selectedPatient = null;
                    _autoFillMessage = null;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPatientTypeOption({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.sm),
        decoration: BoxDecoration(
          color: selected ? AppColors.lightBlue : AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primaryBlue : AppColors.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? AppColors.primaryBlue : AppColors.secondaryText,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: selected ? AppColors.primaryBlue : AppColors.primaryText,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExistingPatientSection(PrescriptionFormState formState) {
    final patientsAsync = ref.watch(filteredPatientsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Existing Patient', style: AppTextStyles.headlineSmall),
        const SizedBox(height: AppSpacing.md),
        AppSearchField(
          hint: 'Search patient by name...',
          controller: _patientSearchController,
          onChanged: (value) {
            ref.read(patientSearchQueryProvider.notifier).state = value;
            setState(() {
              _showPatientSuggestions = true;
              if (value.isEmpty) {
                _selectedPatient = null;
                ref.read(prescriptionFormProvider.notifier).setPatientType(PatientType.existing);
              }
            });
          },
          onClear: () {
            setState(() {
              _selectedPatient = null;
              _showPatientSuggestions = false;
              _autoFillMessage = null;
            });
          },
        ),
        if (_showPatientSuggestions && _selectedPatient == null) ...[
          const SizedBox(height: AppSpacing.md),
          patientsAsync.when(
            data: (patients) {
              if (patients.isEmpty) {
                return AppCard(
                  child: Column(
                    children: [
                      Text('No patients found.', style: AppTextStyles.bodyMedium),
                      const SizedBox(height: AppSpacing.sm),
                      TextButton(
                        onPressed: () {
                          ref.read(prescriptionFormProvider.notifier).setPatientType(PatientType.newPatient);
                        },
                        child: const Text('Switch to New Patient'),
                      ),
                    ],
                  ),
                );
              }
              return Container(
                constraints: const BoxConstraints(maxHeight: 260),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: patients.length,
                  separatorBuilder: (_, __) => Divider(height: 1, color: AppColors.divider),
                  itemBuilder: (context, index) {
                    final patient = patients[index];
                    return ListTile(
                      title: Text(patient.name, style: AppTextStyles.bodyMedium),
                      subtitle: Text('${patient.age} years • ${patient.gender.name} • ${patient.phone}'),
                      onTap: () => _selectExistingPatient(patient),
                    );
                  },
                ),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: AppLoadingIndicator(size: 24),
            ),
            error: (err, stack) => Text('Error: $err'),
          ),
        ],
        if (_isLoadingHistory) ...[
          const SizedBox(height: AppSpacing.md),
          const Row(
            children: [
              AppLoadingIndicator(size: 20),
              SizedBox(width: AppSpacing.sm),
              Text('Loading patient history...'),
            ],
          ),
        ],
        if (_selectedPatient != null && !_isLoadingHistory) ...[
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_selectedPatient!.name, style: AppTextStyles.titleMedium),
                const SizedBox(height: AppSpacing.xs4),
                Text(
                  '${_selectedPatient!.age} years • ${_selectedPatient!.gender.name} • ${_selectedPatient!.phone}',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildNewPatientSection(PrescriptionFormState formState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Patient Information', style: AppTextStyles.headlineSmall),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Patient Name *',
          hint: 'Enter patient name',
          controller: _newNameController,
          onChanged: (v) => ref.read(prescriptionFormProvider.notifier).setNewPatientName(v),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          label: 'Patient Age *',
          hint: 'Enter age',
          controller: _newAgeController,
          keyboardType: TextInputType.number,
          onChanged: (v) => ref.read(prescriptionFormProvider.notifier).setNewPatientAge(v),
        ),
        const SizedBox(height: AppSpacing.lg),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Gender', style: AppTextStyles.titleMedium),
            const SizedBox(height: 8),
            DropdownButton<Gender>(
              value: formState.newPatientGender,
              isExpanded: true,
              items: Gender.values.map((gender) {
                return DropdownMenuItem<Gender>(value: gender, child: Text(gender.name));
              }).toList(),
              onChanged: (Gender? value) {
                if (value != null) {
                  ref.read(prescriptionFormProvider.notifier).setNewPatientGender(value);
                }
              },
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          label: 'Contact Number *',
          hint: 'Enter phone number',
          controller: _newPhoneController,
          keyboardType: TextInputType.phone,
          onChanged: (v) => ref.read(prescriptionFormProvider.notifier).setNewPatientPhone(v),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          label: 'Email (Optional)',
          hint: 'Enter email',
          controller: _newEmailController,
          keyboardType: TextInputType.emailAddress,
          onChanged: (v) => ref.read(prescriptionFormProvider.notifier).setNewPatientEmail(v),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          label: 'Blood Group (Optional)',
          hint: 'e.g., O+, A-, B+',
          controller: _newBloodGroupController,
          onChanged: (v) => ref.read(prescriptionFormProvider.notifier).setNewPatientBloodGroup(v),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          label: 'Address (Optional)',
          hint: 'Enter address',
          controller: _newAddressController,
          maxLines: 2,
          onChanged: (v) => ref.read(prescriptionFormProvider.notifier).setNewPatientAddress(v),
        ),
      ],
    );
  }

  void _showMedicineDetailsForm(medicine) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${medicine.name} ${medicine.strength}', style: AppTextStyles.headlineMedium),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: 'Dose',
                  hint: 'e.g., 1 tablet',
                  controller: _doseController,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('Frequency', style: AppTextStyles.labelMedium),
                DropdownButton<Frequency>(
                  value: _selectedFrequency,
                  isExpanded: true,
                  items: Frequency.values.map((freq) {
                    return DropdownMenuItem<Frequency>(
                      value: freq,
                      child: Text(freq.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (Frequency? newValue) {
                    if (newValue != null) {
                      setState(() => _selectedFrequency = newValue);
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: 'Duration',
                  hint: 'e.g., 5 days',
                  controller: _durationController,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  text: 'Add Medicine',
                  width: double.infinity,
                  onPressed: () {
                    _addMedicine(medicine);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

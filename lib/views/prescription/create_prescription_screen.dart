import '../../widgets/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/prescribed_medicine.dart';
import '../../models/prescription.dart';
import '../../providers/auth_provider.dart';
import '../../providers/medicine_provider.dart';
import '../../providers/prescription_provider.dart';
import '../../providers/prescription_form_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_custom_app_bar.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_card.dart';
import '../../widgets/medicine_suggestion_list.dart';
import '../../widgets/medicine_card.dart';

class CreatePrescriptionScreen extends ConsumerStatefulWidget {
  const CreatePrescriptionScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CreatePrescriptionScreen> createState() => _CreatePrescriptionScreenState();
}

class _CreatePrescriptionScreenState extends ConsumerState<CreatePrescriptionScreen> {
  late TextEditingController _medicineSearchController;
  late TextEditingController _diagnosisController;
  late TextEditingController _symptomsController;
  late TextEditingController _notesController;
  late TextEditingController _doseController;
  late TextEditingController _durationController;

  bool _showMedicineSuggestions = false;
  List<Instruction> _selectedInstructions = [];
  Frequency _selectedFrequency = Frequency.onceDaily;
  DateTime? _selectedFollowUpDate;

  @override
  void initState() {
    super.initState();
    _medicineSearchController = TextEditingController();
    _diagnosisController = TextEditingController();
    _symptomsController = TextEditingController();
    _notesController = TextEditingController();
    _doseController = TextEditingController();
    _durationController = TextEditingController();
  }

  @override
  void dispose() {
    _medicineSearchController.dispose();
    _diagnosisController.dispose();
    _symptomsController.dispose();
    _notesController.dispose();
    _doseController.dispose();
    _durationController.dispose();
    super.dispose();
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

  void _savePrescription() async {
    final formState = ref.read(prescriptionFormProvider);

    if (formState.patientId == null || formState.diagnosis.isEmpty || formState.symptoms.isEmpty) {
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

    final prescription = Prescription(
      id: 'rx_${const Uuid().v4()}',
      doctorId: authState.id,
      patientId: formState.patientId!,
      date: DateTime.now(),
      diagnosis: formState.diagnosis,
      symptoms: formState.symptoms,
      medicines: formState.medicines,
      notes: formState.notes,
      followUpDate: formState.followUpDate,
      status: PrescriptionStatus.draft,
    );

    try {
      await ref.read(prescriptionsNotifierProvider.notifier).addPrescription(prescription);
      ref.read(prescriptionFormProvider.notifier).reset();
      
      if (mounted) {
        context.push('/prescription/${prescription.id}/preview', extra: prescription);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final medicineSuggestionsAsync = ref.watch(medicineSuggestionsProvider);
    final formState = ref.watch(prescriptionFormProvider);

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
              Text('Medical Details', style: AppTextStyles.headlineSmall),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Diagnosis',
                hint: 'Enter diagnosis',
                controller: _diagnosisController,
                onChanged: (value) {
                  ref.read(prescriptionFormProvider.notifier).setDiagnosis(value);
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: 'Symptoms',
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
              if (formState.medicines.isNotEmpty)
                ...formState.medicines.map((medicine) => MedicineCard(
                  prescribedMedicine: medicine,
                  onDelete: () {
                    ref.read(prescriptionFormProvider.notifier).removeMedicine(medicine.id);
                  },
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
                text: 'Preview & Send',
                width: double.infinity,
                onPressed: _savePrescription,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMedicineDetailsForm(medicine) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
    );
  }
}

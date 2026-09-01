# MediPrescribe - Implementation Guide

## 🔬 Medicine Suggestion System

The medicine suggestion system is one of the core features of MediPrescribe, providing doctors with intelligent, real-time medicine recommendations.

### How It Works

1. **Search Query**: Doctor types in the medicine search field
2. **Real-time Filtering**: System matches against 25+ mock medicines
3. **Case-Insensitive Search**: "par", "PAR", "Par" all match "Paracetamol"
4. **Dual Search Fields**: Searches both brand name and generic name
5. **Instant Suggestions**: Shows matching medicines in a scrollable list
6. **Selection**: Doctor taps a medicine to add it to the prescription

### Example Searches

| Query | Matches |
|-------|---------|
| "Par" | Paracetamol 500mg, Paracetamol 650mg, Paracip 500mg, Pacimol 650mg |
| "Ami" | Amoxicillin 500mg, Amoxicillin 250mg |
| "Azi" | Azithromycin 500mg, Azithromycin 250mg |
| "Cet" | Cetirizine 10mg, Cetirizine 5mg |

### Technical Implementation

**File**: `lib/services/mock_medicine_service.dart`

```dart
static List<Medicine> searchMedicines(String query) {
  if (query.isEmpty) {
    return [];
  }
  
  final lowerQuery = query.toLowerCase();
  return medicines.where((medicine) {
    return medicine.name.toLowerCase().contains(lowerQuery) ||
        medicine.genericName.toLowerCase().contains(lowerQuery);
  }).toList();
}
```

**State Management** (Riverpod):
- `medicineSearchQueryProvider`: Stores current search query
- `medicineSuggestionsProvider`: Provides filtered results
- Updates in real-time as user types

**UI Component**: `MedicineSuggestionList` Widget
- Shows dropdown list below search field
- Displays medicine name, strength, and form
- Scrollable with max height of 300px
- Smooth interaction feedback

## 📋 Prescription Creation Workflow

### Step 1: Patient Selection
- Doctor navigates to "Create Prescription"
- Patient is pre-selected if coming from patient details
- Or doctor selects from patient list

### Step 2: Medical Information
- Enter diagnosis (required)
- Enter symptoms (required)
- Add optional notes

### Step 3: Add Medicines
1. Search for medicine
2. Select from suggestions
3. Enter dose (e.g., "1 tablet", "2 capsules")
4. Select frequency (Once Daily, Twice Daily, etc.)
5. Enter duration (e.g., "5 days", "2 weeks")
6. Select instructions (Before Food, After Food, etc.)
7. Tap "Add Medicine" to add to prescription
8. Repeat for additional medicines

### Step 4: Follow-up & Notes
- Optional: Set follow-up date
- Optional: Add special notes
- Minimum 1 medicine required

### Step 5: Preview
- Review complete prescription
- Doctor, patient, and medical details
- All medicines with full information
- Send button to finalize

### Step 6: Send
- Prescription marked as "Sent"
- Added to doctor's prescription history
- Added to patient's prescription list
- Notification sent to patient

## 🔐 Authentication & Authorization

### Authentication Flow

```
Welcome Screen
    ↓
Role Selection (Doctor/Patient)
    ↓
Login/Signup
    ↓
Main App
```

### Mock Credentials

**Doctor Accounts**:
- Email: rajesh.kumar@hospital.com | Password: password123
- Email: priya.sharma@hospital.com | Password: password123

**Patient Accounts**:
- Email: amit.singh@email.com | Password: password123
- Email: sneha.patel@email.com | Password: password123

### Authorization
- Doctors can only view their own patients and prescriptions
- Patients can only view their own prescriptions
- Bottom navigation differs by role

## 💾 State Management (Riverpod)

### Key Providers

```dart
// Authentication
authProvider              // Current user state
currentUserRoleProvider   // User role (doctor/patient)

// Patients
patientsProvider          // All patients
filteredPatientsProvider  // Search results
patientSearchQueryProvider// Search state

// Medicines
allMedicinesProvider      // All medicines
medicineSuggestionsProvider // Search results
medicineSearchQueryProvider // Search state

// Prescriptions
allPrescriptionsProvider               // All prescriptions
prescriptionsByDoctorIdProvider        // Doctor's prescriptions
prescriptionsByPatientIdProvider       // Patient's prescriptions
filteredPrescriptionsByDateProvider    // With date filtering
prescriptionFilterProvider             // Filter selection

// Forms
prescriptionFormProvider   // Prescription creation form
```

### State Update Pattern

```dart
// Create or update
await ref.read(patientsNotifierProvider.notifier).addPatient(patient);

// Automatic UI refresh via Riverpod
// No setState() needed!
```

## 📱 Navigation Flow

### Doctor Navigation

```
Splash (3s)
    ↓
Welcome → Login/Signup
    ↓
Doctor Dashboard (Bottom Nav 4 tabs)
├─ Home: Quick overview
├─ Patients: Patient management
├─ Prescriptions: Prescription history
└─ Profile: Settings & profile

From Patients:
├─ Patient Details → Create Prescription
└─ Create Prescription → Preview → Send
```

### Patient Navigation

```
Splash (3s)
    ↓
Welcome → Login/Signup
    ↓
Patient Dashboard (Bottom Nav 3 tabs)
├─ Home: Prescription overview
├─ Prescriptions: All prescriptions
└─ Profile: Personal info
```

## 🎨 Reusable Components

### Widgets

| Widget | Purpose |
|--------|---------|
| AppButton | Primary action button |
| AppOutlinedButton | Secondary button |
| AppTextField | Text input with label |
| AppSearchField | Optimized search input |
| AppCard | Elevated card container |
| AppAvatar | User avatar with initials |
| AppEmptyState | Empty state UI |
| AppLoadingIndicator | Loading spinner |
| MedicineSuggestionList | Dropdown suggestions |
| MedicineCard | Medicine display card |
| PatientListTile | Patient list item |
| PrescriptionCard | Prescription display card |
| ProfileMenuTile | Menu item for profile |
| StatusBadge | Status indicator |
| AppCustomAppBar | Consistent app bar |

## 🔄 Data Flow

### Adding a Medicine to Prescription

```
User types in search box
        ↓
medicineSearchQueryProvider updated
        ↓
medicineSuggestionsProvider recalculates
        ↓
MedicineSuggestionList rebuilt with results
        ↓
User taps medicine
        ↓
Modal shows dose/frequency options
        ↓
User confirms
        ↓
prescriptionFormProvider.addMedicine()
        ↓
Prescription UI refreshed automatically
```

### Saving Prescription

```
User taps "Preview & Send"
        ↓
Form validation
        ↓
Create Prescription object
        ↓
prescriptionsNotifierProvider.addPrescription()
        ↓
Mock service stores in memory
        ↓
Navigate to preview screen
        ↓
User reviews and sends
        ↓
Status changed to "Sent"
        ↓
Added to patient's prescription list
```

## 📊 Mock Data Structure

### Medicine Object
```dart
Medicine {
  id: String (UUID)
  name: String           // "Paracetamol"
  genericName: String    // "Acetaminophen"
  strength: String       // "500 mg"
  form: MedicineForm     // tablet, capsule, syrup, etc.
}
```

### Prescription Object
```dart
Prescription {
  id: String
  doctorId: String
  patientId: String
  date: DateTime
  diagnosis: String
  symptoms: String
  medicines: List<PrescribedMedicine>
  notes: String?
  followUpDate: DateTime?
  status: PrescriptionStatus  // draft, sent, completed
}
```

### PrescribedMedicine Object
```dart
PrescribedMedicine {
  id: String
  medicine: Medicine
  dose: String           // "1 tablet"
  frequency: Frequency   // onceDaily, twiceDaily, etc.
  duration: String       // "5 days"
  instructions: List<Instruction>  // beforeFood, afterFood, etc.
  additionalNotes: String?
}
```

## ⚙️ Configuration

### Theme Colors (Customizable in `app_colors.dart`)
```dart
Primary Blue:    #2563B8
Secondary Blue:  #3B82D0
Light Blue:      #EAF2FF
Background:      #F8FAFC
Card:            #FFFFFF
```

### Font Configuration
- Font Family: Poppins (or system fonts)
- Can be changed in `pubspec.yaml` and `app_text_styles.dart`

### Spacing & Radius
- All defined in `app_spacing.dart` and `app_radius.dart`
- Easy to adjust globally

## 🐛 Debugging

### Enable Verbose Logging
```bash
flutter run -v
```

### Check State
Use Flutter DevTools to inspect Riverpod state:
```bash
flutter pub global activate devtools
devtools
```

### Common Issues

1. **Medicine not appearing in search**
   - Check `mock_medicine_service.dart`
   - Verify search is case-insensitive

2. **Prescription not saving**
   - Check `prescription_form_provider` validation
   - Ensure at least 1 medicine is added

3. **Navigation issues**
   - Check `app_router.dart` routes
   - Verify context.push vs context.go usage

## 📈 Performance Considerations

- **Riverpod Caching**: Providers cache results until invalidated
- **FutureProvider**: Async operations handled elegantly
- **StateNotifierProvider**: Efficient state updates
- **ListView.builder**: Lazy loading for long lists
- **Image Optimization**: Use appropriate sizes and formats

## 🔐 Security Notes

- Mock authentication only (no real security)
- Passwords stored in mock service (plaintext)
- Use proper authentication in production
- Implement encryption for sensitive data
- Use HTTPS for API calls
- Implement token-based auth (JWT)

## 📞 Getting Help

For specific features or clarifications:
1. Check the code comments
2. Review widget implementations
3. Refer to Riverpod documentation
4. Check Flutter Material 3 documentation
5. Review go_router navigation guide

---

**Happy Coding! 🚀**

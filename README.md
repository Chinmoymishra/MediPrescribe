# MediPrescribe - Digital Prescription Management App

**MediPrescribe: Digital Prescription, Better Healthcare**

A premium Flutter mobile application that connects doctors and patients for seamless digital prescription management. Built with clean architecture, Material 3 design, and Riverpod state management.

## 📱 Features

### Doctor Module
- **Dashboard**: Quick overview of patients, prescriptions, and daily metrics
- **Patient Management**: Add, search, and view patient details
- **Prescription Creation**: Complete prescription workflow with:
  - Patient selection
  - Medical details (diagnosis, symptoms)
  - **Advanced Medicine Suggestion System**: Real-time search and filtering with 25+ mock medicines
  - Medicine dosage management (dose, frequency, duration, instructions)
  - Follow-up date scheduling
  - Additional notes
- **Prescription Preview**: Professional prescription layout before sending
- **Prescription History**: Track all prescriptions with date filtering
- **Profile Management**: View and manage doctor profile

### Patient Module
- **Dashboard**: View received prescriptions and medical overview
- **Prescription List**: Access all received prescriptions
- **Prescription Details**: View complete prescription information including:
  - Doctor details
  - Medical information
  - Medicine list with dosage instructions
  - Follow-up appointments
- **Profile Management**: Personal health information

### Authentication
- **Role-based Login**: Doctor and Patient login flows
- **Doctor Registration**: Name, email, phone, registration number, specialization
- **Patient Registration**: Name, email, phone, date of birth, gender
- **Forgotten Password**: Password recovery flow
- **Mock Authentication**: Debug credentials (password: `password123`)

### Design & UX
- Premium iOS-inspired Material 3 design
- Soft shadows and rounded corners
- Responsive layouts for all screen sizes
- Smooth animations and transitions
- Custom color theme optimized for healthcare
- Accessible typography and spacing

## 🎨 Design System

### Colors
- **Primary Blue**: #2563B8
- **Secondary Blue**: #3B82D0
- **Light Blue**: #EAF2FF
- **Background**: #F8FAFC
- **Success**: #22C55E
- **Warning**: #F59E0B
- **Error**: #EF4444

### Typography
- **Font Family**: Poppins (recommended, fallback to system fonts)
- **Text Styles**: Display, Headline, Title, Body, Label, Caption

### Spacing & Radius
- **Spacing**: 2px, 4px, 6px, 8px, 12px, 16px, 18px, 24px, 28px, 32px, 40px, 48px, 56px
- **Radius**: 4px, 8px, 12px, 16px, 20px, 24px, 32px, 999px (full)

## 🏗️ Architecture

### MVC + Repository Pattern
```
lib/
├── core/               # Theme, constants, utilities
│   └── theme/         # Colors, typography, spacing, radius, theme
├── models/            # Data models (User, Doctor, Patient, Medicine, Prescription)
├── services/          # Mock data services
├── repositories/      # Repository interfaces and mock implementations
├── providers/         # Riverpod state management
├── routes/            # Go Router navigation
├── views/             # UI screens
│   ├── auth/          # Authentication screens
│   ├── doctor/        # Doctor module screens
│   ├── patient/       # Patient module screens
│   └── prescription/  # Prescription management screens
└── widgets/           # Reusable components
```

### State Management (Riverpod)
- **Authentication**: `authProvider`, `currentUserProvider`
- **Patients**: `patientsProvider`, `filteredPatientsProvider`
- **Medicines**: `allMedicinesProvider`, `medicineSuggestionsProvider`
- **Prescriptions**: `allPrescriptionsProvider`, `prescriptionsByDoctorIdProvider`, `prescriptionsByPatientIdProvider`
- **Prescription Form**: `prescriptionFormProvider`
- **Notifications**: `userNotificationsProvider`, `unreadNotificationsProvider`

### Repository Pattern
Each domain has a repository interface with mock implementation:
- `AuthRepository` / `MockAuthRepositoryImpl`
- `PatientRepository` / `MockPatientRepositoryImpl`
- `MedicineRepository` / `MockMedicineRepositoryImpl`
- `PrescriptionRepository` / `MockPrescriptionRepositoryImpl`
- `NotificationRepository` / `MockNotificationRepositoryImpl`

This allows easy migration to real APIs by simply replacing the mock implementations.

## 📋 Mock Data

### Pre-loaded Data
- **2 Doctors**: Dr. Rajesh Kumar, Dr. Priya Sharma
- **10 Patients**: With varying ages, genders, blood groups
- **25 Medicines**: Including Paracetamol, Amoxicillin, Azithromycin, etc.
- **4 Sample Prescriptions**: Different statuses (draft, sent, completed)
- **Notifications**: Sample notifications for both doctor and patient

### Medicine Suggestion System
Real-time search with intelligent filtering:
- Type "Par" → Shows Paracetamol variants, Paracip, Pacimol
- Type "Ami" → Shows Amoxicillin variants
- Supports search by name and generic name
- Displays strength and form (tablet, capsule, syrup, etc.)

## 🎯 Key Screens

### Authentication Flow
1. **Splash Screen**: 3-second intro with logo
2. **Welcome Screen**: Role selection (Doctor/Patient)
3. **Login Screen**: Email and password authentication
4. **Signup Screens**: Role-specific registration
5. **Forgot Password**: Password recovery

### Doctor Flow
1. **Dashboard**: Greeting, quick stats, quick actions
2. **Patients**: View and search patient list
3. **Patient Details**: Full patient information
4. **Add Patient**: Create new patient record
5. **Create Prescription**: Multi-step prescription creation with medicine search
6. **Prescription Preview**: Professional preview before sending
7. **Prescription History**: Track all prescriptions
8. **Profile**: Doctor information and settings

### Patient Flow
1. **Dashboard**: Prescription overview
2. **Prescription List**: All received prescriptions
3. **Prescription Details**: Full prescription view with medicines
4. **Profile**: Patient information

## 🔑 Demo Credentials

### Doctor Login
- **Email**: rajesh.kumar@hospital.com
- **Password**: password123

### Patient Login
- **Email**: amit.singh@email.com
- **Password**: password123

## 📦 Dependencies

```yaml
flutter:
  sdk: Flutter 3.10+

state_management:
  - riverpod: ^2.4.0
  - flutter_riverpod: ^2.4.0

navigation:
  - go_router: ^12.0.0

ui:
  - google_fonts: ^6.1.0
  - cupertino_icons: ^1.0.6
  - material_symbols: ^4.7.0

utilities:
  - intl: ^0.19.0
  - uuid: ^4.0.0
  - email_validator: ^2.1.17
```

## 🚀 Getting Started

### Prerequisites
- Flutter 3.10.0 or higher
- Dart 3.0.0 or higher

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd MediPrescribe

# Get dependencies
flutter pub get

# Run the app
flutter run
```

### Build Release

```bash
# iOS
flutter build ios --release

# Android
flutter build apk --release
```

## 📄 Medical Disclaimer

**MediPrescribe is a digital prescription management platform.**

- Medicine information shown in this application is for demonstration purposes only
- It does not replace professional medical judgment
- Always consult healthcare professionals for medical advice
- This app does NOT provide automated diagnosis or treatment recommendations
- Medicine suggestions are only based on mock local data

## 🎯 Future Enhancements

- [ ] Real backend API integration (REST/GraphQL)
- [ ] Firebase authentication and database
- [ ] Cloud prescription storage and sync
- [ ] Push notifications
- [ ] PDF prescription export
- [ ] Integration with pharmacy systems
- [ ] Video consultation feature
- [ ] Patient medical history
- [ ] Medication reminders
- [ ] Real medicine database API
- [ ] E-prescription compliance
- [ ] Doctor ratings and reviews
- [ ] Appointment scheduling
- [ ] Lab report integration

## 🏥 Healthcare Compliance

This application is designed as a demonstration. For production use, ensure compliance with:
- HIPAA (USA)
- GDPR (Europe)
- Local healthcare regulations
- Digital signature laws
- Data protection standards

## 📞 Support & Contribution

For issues, suggestions, or contributions, please refer to the project repository.

## 📜 License

This project is provided as-is for educational and demonstration purposes.

---

**Built with ❤️ using Flutter, Riverpod, and Material 3**

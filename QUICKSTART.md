# MediPrescribe - Quick Start Guide

## 🚀 Getting Started in 5 Minutes

### 1. Clone & Install
```bash
cd MediPrescribe
flutter pub get
```

### 2. Run the App
```bash
flutter run
```

### 3. Login with Demo Account
**Doctor**: rajesh.kumar@hospital.com | password123
**Patient**: amit.singh@email.com | password123

## 📱 Test the App

### Doctor Flow (Test in 2 minutes)
1. Login as doctor
2. Click "Patients" tab
3. Tap a patient
4. Click "Create Prescription"
5. Search for "Paracetamol" (try typing "Par")
6. Select strength
7. Enter dose: "1 tablet"
8. Select frequency: "Twice Daily"
9. Set duration: "5 days"
10. Select instruction: "After Food"
11. Click "Add Medicine"
12. Click "Preview & Send"
13. Review and click "Send Prescription"

### Patient Flow (Test in 1 minute)
1. Login as patient
2. Click "Prescriptions" tab
3. Tap any prescription to view details
4. See all medicines with dosage instructions

## 🎨 Key Features to Explore

- **Medicine Search**: Type in medicine search to see intelligent filtering
- **Real-time Suggestions**: Watch suggestions update as you type
- **Form Validation**: Try submitting without filling required fields
- **Beautiful UI**: Notice Material 3 design and smooth animations
- **Bottom Navigation**: Switch tabs to explore different views
- **Prescription Preview**: Professional prescription layout

## 📝 Architecture Overview

```
MediPrescribe Architecture

┌─────────────────────────────────────┐
│         Flutter UI Layer             │
│  (Screens, Widgets, Navigation)     │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│    Riverpod State Management        │
│   (Providers, Notifiers)            │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│   Repository Pattern               │
│   (Interfaces + Mock Implementations)│
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│     Mock Services & Data            │
│   (In-memory storage for testing)   │
└─────────────────────────────────────┘
```

## 💡 What's Implemented

✅ **Complete Authentication**
- Doctor & Patient login/signup
- Password recovery
- Role-based navigation

✅ **Doctor Module** (6 screens)
- Dashboard with quick stats
- Patient management (add, search, view)
- Prescription creation with medicine search
- Prescription preview & sending
- Prescription history with filters
- Profile management

✅ **Patient Module** (4 screens)
- Dashboard with prescription overview
- Prescription list
- Prescription details view
- Profile management

✅ **Medicine Search System**
- Real-time filtering with 25+ medicines
- Search by brand name & generic name
- Beautiful suggestion dropdown
- Intelligent matching algorithm

✅ **Design System**
- Material 3 theme
- Custom colors (healthcare optimized)
- Typography with Poppins font
- Spacing & radius constants
- Reusable components (17 widgets)

## 🔧 File Structure

```
lib/
├── main.dart                 ← Entry point
├── core/theme/              ← Design system
│   ├── app_colors.dart
│   ├── app_text_styles.dart
│   ├── app_spacing.dart
│   ├── app_radius.dart
│   └── app_theme.dart
├── models/                  ← Data models
├── services/               ← Mock data
├── repositories/           ← Business logic
├── providers/              ← Riverpod state
├── routes/                 ← Navigation
├── views/                  ← Screens
│   ├── auth/
│   ├── doctor/
│   ├── patient/
│   └── prescription/
└── widgets/               ← Reusable components
```

## 🎯 Next Steps

### To Customize

1. **Change Colors**: Edit `lib/core/theme/app_colors.dart`
2. **Change Font**: Update `pubspec.yaml` and `app_text_styles.dart`
3. **Add More Medicines**: Edit `lib/services/mock_medicine_service.dart`
4. **Add More Patients**: Edit `lib/services/mock_patient_service.dart`

### To Extend

1. **Add Backend API**: Replace mock services with API calls
2. **Add Firebase**: Implement real authentication and database
3. **Add More Features**: Follow the existing pattern to add screens
4. **Push Notifications**: Integrate Firebase Cloud Messaging

## 🐛 Troubleshooting

### App won't start
```bash
flutter clean
flutter pub get
flutter run
```

### Hot reload doesn't work
```bash
# Stop the app and rebuild
flutter run --no-fast-start
```

### Build errors
```bash
flutter doctor  # Check dependencies
flutter pub get  # Reinstall packages
```

## 📚 Learning Resources

- **Flutter Docs**: https://flutter.dev/docs
- **Riverpod Docs**: https://riverpod.dev
- **GoRouter Docs**: https://pub.dev/packages/go_router
- **Material 3**: https://m3.material.io

## 🎓 Code Examples

### Search Medicines in Real-Time
```dart
// In create_prescription_screen.dart
ref.watch(medicineSuggestionsProvider)  // Auto-updates as you type
```

### Add Patient
```dart
// In add_patient_screen.dart
await ref.read(patientsNotifierProvider.notifier)
    .addPatient(newPatient);
```

### Get Prescriptions for Patient
```dart
// In patient_dashboard.dart
final prescriptions = ref.watch(
  prescriptionsByPatientIdProvider(patientId)
);
```

## 💬 Support

For issues or questions:
1. Check IMPLEMENTATION_GUIDE.md for detailed docs
2. Review code comments in relevant files
3. Check Flutter and Riverpod documentation
4. Run `flutter analyze` to check for issues

## ⭐ Pro Tips

1. **Use the medicine search**: Type just first letter for suggestions
2. **Try both roles**: Login as doctor and patient to see full features
3. **Check mock data**: Open services to see sample patients/medicines
4. **Inspect the code**: Well-commented for learning
5. **Modify and experiment**: Safe to modify mock services

---

**Happy Learning! 🎉 Enjoy exploring MediPrescribe!**

**Questions or issues?** Check the code comments and documentation files.

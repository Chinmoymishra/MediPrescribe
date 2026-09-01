import 'user.dart';

enum Gender { male, female, other }

class Patient extends BaseUser {
  final DateTime dateOfBirth;
  final Gender gender;
  final String? bloodGroup;
  final String? address;

  Patient({
    required String id,
    required String name,
    required String email,
    required String phone,
    required this.dateOfBirth,
    required this.gender,
    this.bloodGroup,
    this.address,
  }) : super(
    id: id,
    name: name,
    email: email,
    phone: phone,
    role: UserRole.patient,
  );

  int get age {
    final today = DateTime.now();
    int age = today.year - dateOfBirth.year;
    if (today.month < dateOfBirth.month ||
        (today.month == dateOfBirth.month && today.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  Patient copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    DateTime? dateOfBirth,
    Gender? gender,
    String? bloodGroup,
    String? address,
  }) {
    return Patient(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      address: address ?? this.address,
    );
  }
}

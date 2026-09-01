import 'user.dart';

class Doctor extends BaseUser {
  final String registrationNumber;
  final String specialization;

  Doctor({
    required String id,
    required String name,
    required String email,
    required String phone,
    required this.registrationNumber,
    required this.specialization,
  }) : super(
    id: id,
    name: name,
    email: email,
    phone: phone,
    role: UserRole.doctor,
  );

  Doctor copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? registrationNumber,
    String? specialization,
  }) {
    return Doctor(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      specialization: specialization ?? this.specialization,
    );
  }
}

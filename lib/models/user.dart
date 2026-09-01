enum UserRole { doctor, patient }

abstract class BaseUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;

  BaseUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
  });
}

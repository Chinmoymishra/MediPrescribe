enum MedicineForm {
  tablet,
  capsule,
  syrup,
  injection,
  ointment,
  powder,
  liquid,
}

class Medicine {
  final String id;
  final String name;
  final String genericName;
  final String strength;
  final MedicineForm form;

  Medicine({
    required this.id,
    required this.name,
    required this.genericName,
    required this.strength,
    required this.form,
  });

  String get displayName => '$name $strength ${form.name}';

  Medicine copyWith({
    String? id,
    String? name,
    String? genericName,
    String? strength,
    MedicineForm? form,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      genericName: genericName ?? this.genericName,
      strength: strength ?? this.strength,
      form: form ?? this.form,
    );
  }
}

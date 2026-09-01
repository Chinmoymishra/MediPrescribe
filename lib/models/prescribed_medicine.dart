import 'medicine.dart';

enum Frequency {
  onceDaily,
  twiceDaily,
  threeTimesDaily,
  every8Hours,
  sos,
}

enum Instruction {
  beforeFood,
  afterFood,
  atBedtime,
  withWater,
  asNeeded,
}

class PrescribedMedicine {
  final String id;
  final Medicine medicine;
  final String dose;
  final Frequency frequency;
  final String duration; // e.g., "7 days", "14 days"
  final List<Instruction> instructions;
  final String? additionalNotes;

  PrescribedMedicine({
    required this.id,
    required this.medicine,
    required this.dose,
    required this.frequency,
    required this.duration,
    required this.instructions,
    this.additionalNotes,
  });

  String get frequencyDisplay {
    switch (frequency) {
      case Frequency.onceDaily:
        return 'Once Daily';
      case Frequency.twiceDaily:
        return 'Twice Daily';
      case Frequency.threeTimesDaily:
        return 'Three Times Daily';
      case Frequency.every8Hours:
        return 'Every 8 Hours';
      case Frequency.sos:
        return 'SOS (As Needed)';
    }
  }

  List<String> get instructionsDisplay {
    return instructions.map((i) {
      switch (i) {
        case Instruction.beforeFood:
          return 'Before Food';
        case Instruction.afterFood:
          return 'After Food';
        case Instruction.atBedtime:
          return 'At Bedtime';
        case Instruction.withWater:
          return 'With Water';
        case Instruction.asNeeded:
          return 'As Needed';
      }
    }).toList();
  }

  PrescribedMedicine copyWith({
    String? id,
    Medicine? medicine,
    String? dose,
    Frequency? frequency,
    String? duration,
    List<Instruction>? instructions,
    String? additionalNotes,
  }) {
    return PrescribedMedicine(
      id: id ?? this.id,
      medicine: medicine ?? this.medicine,
      dose: dose ?? this.dose,
      frequency: frequency ?? this.frequency,
      duration: duration ?? this.duration,
      instructions: instructions ?? this.instructions,
      additionalNotes: additionalNotes ?? this.additionalNotes,
    );
  }
}

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/doctor.dart';
import '../models/patient.dart';
import '../models/prescription.dart';

// Builds a printable A4 PDF for a prescription. Reused for both the
// "Print & Save" flow and re-printing an old prescription from history.
class PrescriptionPdfGenerator {
  static Future<pw.Document> generate({
    required Prescription prescription,
    required Doctor doctor,
    required Patient patient,
  }) async {
    final doc = pw.Document();
    final dateFormat = DateFormat('dd MMM yyyy');

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(
              'MediPrescribe',
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(doctor.name, style: const pw.TextStyle(fontSize: 12)),
            pw.Text(doctor.specialization, style: const pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 8),
            pw.Divider(thickness: 1),
          ],
        ),
        footer: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.SizedBox(height: 24),
            pw.Text('Doctor Signature', style: const pw.TextStyle(fontSize: 10)),
          ],
        ),
        build: (context) => [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Patient: ${patient.name}', style: const pw.TextStyle(fontSize: 12)),
                  pw.Text(
                    'Age: ${patient.age}   Gender: ${patient.gender.name}',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                  pw.Text('Phone: ${patient.phone}', style: const pw.TextStyle(fontSize: 10)),
                ],
              ),
              pw.Text(
                'Date: ${dateFormat.format(prescription.date)}',
                style: const pw.TextStyle(fontSize: 10),
              ),
            ],
          ),
          pw.SizedBox(height: 16),
          pw.Text('Diagnosis', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.Text(prescription.diagnosis, style: const pw.TextStyle(fontSize: 10)),
          pw.SizedBox(height: 8),
          pw.Text('Symptoms', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.Text(prescription.symptoms, style: const pw.TextStyle(fontSize: 10)),
          pw.SizedBox(height: 16),
          pw.Text('Rx', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          ...prescription.medicines.asMap().entries.map((entry) {
            final index = entry.key + 1;
            final med = entry.value;
            return pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 10),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    '$index. ${med.medicine.name} ${med.medicine.strength}',
                    style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    '${med.dose} | ${med.frequencyDisplay} | ${med.duration}',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                  if (med.instructions.isNotEmpty)
                    pw.Text(
                      med.instructionsDisplay.join(', '),
                      style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
                    ),
                ],
              ),
            );
          }),
          pw.SizedBox(height: 12),
          pw.Divider(thickness: 0.5),
          if (prescription.notes != null && prescription.notes!.isNotEmpty) ...[
            pw.SizedBox(height: 8),
            pw.Text('Advice', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
            pw.Text(prescription.notes!, style: const pw.TextStyle(fontSize: 10)),
          ],
          if (prescription.followUpDate != null) ...[
            pw.SizedBox(height: 8),
            pw.Text('Follow-up', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
            pw.Text(dateFormat.format(prescription.followUpDate!), style: const pw.TextStyle(fontSize: 10)),
          ],
        ],
      ),
    );

    return doc;
  }
}

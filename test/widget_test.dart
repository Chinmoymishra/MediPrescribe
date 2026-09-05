// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that values change correctly.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medi_prescribe/main.dart';


void main() {
  testWidgets('MediPrescribe app loads', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MediPrescribeApp());

    // Verify that the app is loaded.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors — deep medical teal-blue
  static const Color primaryBlue = Color(0xFF0F6E64);
  static const Color secondaryBlue = Color(0xFF14B8A6);
  static const Color lightBlue = Color(0xFFE3F5F2);

  // Accent — soft aqua/cyan used for highlights, chips, secondary actions
  static const Color accent = Color(0xFF38BDF8);
  static const Color accentLight = Color(0xFFE0F4FE);

  // Neutral Colors
  static const Color background = Color(0xFFF6F9F9);
  static const Color card = Color(0xFFFFFFFF);
  static const Color primaryText = Color(0xFF152A2A);
  static const Color secondaryText = Color(0xFF5F7A78);

  // Status Colors
  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFFE7F8ED);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3E2);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFDEBEB);

  // Additional utilities
  static const Color divider = Color(0xFFE1EDEB);
  static const Color shadow = Color(0x140F6E64);
  static const Color border = Color(0xFFE1EDEB);
  static const Color disabled = Color(0xFFCBD9D7);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, secondaryBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0F6E64), Color(0xFF17A398), Color(0xFF38BDF8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle _base({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    required double height,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  // Display styles (Large headings)
  static TextStyle displayLarge = _base(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryText,
    height: 1.2,
  );

  static TextStyle displayMedium = _base(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryText,
    height: 1.2,
  );

  static TextStyle displaySmall = _base(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryText,
    height: 1.2,
  );

  // Headline styles
  static TextStyle headlineLarge = _base(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryText,
    height: 1.3,
  );

  static TextStyle headlineMedium = _base(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
    height: 1.3,
  );

  static TextStyle headlineSmall = _base(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
    height: 1.3,
  );

  // Title styles
  static TextStyle titleLarge = _base(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
    height: 1.4,
  );

  static TextStyle titleMedium = _base(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
    height: 1.4,
  );

  static TextStyle titleSmall = _base(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
    height: 1.4,
  );

  // Body styles
  static TextStyle bodyLarge = _base(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryText,
    height: 1.5,
  );

  static TextStyle bodyMedium = _base(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryText,
    height: 1.5,
  );

  static TextStyle bodySmall = _base(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.secondaryText,
    height: 1.5,
  );

  // Label styles
  static TextStyle labelLarge = _base(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
    height: 1.4,
  );

  static TextStyle labelMedium = _base(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.secondaryText,
    height: 1.3,
  );

  static TextStyle labelSmall = _base(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.secondaryText,
    height: 1.3,
  );

  // Caption styles
  static TextStyle captionLarge = _base(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.secondaryText,
    height: 1.4,
  );

  static TextStyle captionSmall = _base(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.secondaryText,
    height: 1.3,
  );

  // Numeric/medical value emphasis (vitals, dosage numbers, stats)
  static TextStyle statValue = GoogleFonts.plusJakartaSans(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppColors.primaryText,
    height: 1.1,
  );
}

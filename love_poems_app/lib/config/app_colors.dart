import 'package:flutter/material.dart';

class AppColors {
  // Neutral Colors (80% of UI)
  static const Color neutral50 = Color(0xFFFAFAFA); // Backgrounds
  static const Color neutral100 = Color(0xFFF5F5F5); // Subtle surfaces
  static const Color neutral200 = Color(0xFFE5E5E5); // Borders
  static const Color neutral400 = Color(0xFFA3A3A3); // Disabled
  static const Color neutral600 = Color(0xFF525252); // Secondary text
  static const Color neutral800 = Color(0xFF262626); // Primary text
  static const Color neutral900 = Color(0xFF171717); // Headings
  static const Color pureWhite = Color(0xFFFFFFFF); // Cards

  // Accent Colors (15% of UI)
  static const Color accentRose = Color(0xFFD4958B); // Primary actions
  static const Color accentRoseLight = Color(0xFFE8C5BD); // Hover/light states
  static const Color accentRoseDark = Color(0xFFA87569); // Pressed states

  // Semantic Colors (5% of UI)
  static const Color successGreen = Color(0xFF10B981);
  static const Color errorRed = Color(0xFFEF4444);

  // Semantic color aliases
  static const Color primary = accentRose;
  static const Color onPrimary = pureWhite;
  static const Color background = neutral50;
  static const Color surface = pureWhite;
  static const Color textPrimary = neutral800;
  static const Color textSecondary = neutral600;
}

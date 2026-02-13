import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color roseRouge = Color(0xFFE91E63);
  static const Color deepPassion = Color(0xFF880E4F);
  static const Color softBlush = Color(0xFFFCE4EC);
  static const Color antiqueWhite = Color(0xFFFFF9C4);
  static const Color inkBlack = Color(0xFF37474F);
  static const Color goldFoil = Color(0xFFFFD700);

  // Gradient colors (from existing web version)
  static const Color gradientStart = Color(0xFFFDE7F9);
  static const Color gradientEnd = Color(0xFFFFECD2);

  // Semantic colors
  static const Color primary = roseRouge;
  static const Color onPrimary = Colors.white;
  static const Color background = softBlush;
  static const Color surface = Colors.white;
  static const Color textPrimary = inkBlack;
  static const Color textSecondary = Color(0xFF6B7280);

  // Gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientStart, gradientEnd],
  );

  static const LinearGradient primaryButtonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEC4899), Color(0xFFF43F5E)],
  );

  static const RadialGradient waxSealGradient = RadialGradient(
    colors: [goldFoil, roseRouge],
  );
}

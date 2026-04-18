import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFFD70F64); // foodpanda pink
  static const primaryFg = Colors.white;
  static const accent = Color(0xFFFF8FB1);
  static const success = Color(0xFF16A34A);
  static const warning = Color(0xFFF59E0B);
  static const destructive = Color(0xFFDC2626);
  static const background = Color(0xFFFAFAFA);
  static const card = Colors.white;
  static const foreground = Color(0xFF111827);
  static const muted = Color(0xFF6B7280);
  static const secondary = Color(0xFFF3F4F6);
  static const border = Color(0xFFE5E7EB);
}

ThemeData buildTheme() {
  final base = ThemeData.light(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: base.colorScheme.copyWith(
      primary: AppColors.primary,
      onPrimary: AppColors.primaryFg,
      surface: AppColors.card,
    ),
    textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
      bodyColor: AppColors.foreground,
      displayColor: AppColors.foreground,
    ),
  );
}

LinearGradient pandaGradient() => const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.primary, AppColors.accent],
    );

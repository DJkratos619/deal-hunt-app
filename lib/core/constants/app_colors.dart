import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  //Colores primarios
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF4B44CC);
  static const Color primaryLight = Color(0xFF9D97FF);

  //Accent
  static const Color accent = Color(0xFFF6B35);
  static const Color accentLight = Color(0xFFF9A6C);

 //Backgrounds
  static const Color backgroundLight = Color(0xFFF8F9FE);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E2E);
  static const Color cardDark = Color(0xFF252535);

  //Text
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textDarkSecondary = Color(0xFFB0B0C0);

  // Status
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color expired = Color(0xFF9CA3AF);

  // Category colors
  static const Color catFood = Color(0xFFFF6B6B);
  static const Color catTech = Color(0xFF4ECDC4);
  static const Color catFashion = Color(0xFFFF8ED4);
  static const Color catTravel = Color(0xFF45B7D1);
  static const Color catSports = Color(0xFF96CEB4);
  static const Color catEntertainment = Color(0xFFFFBE0B);
  static const Color catHealth = Color(0xFF06D6A0);
  static const Color catAll = Color(0xFF6C63FF);

  //Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6C63FF), Color(0xFF9D97FF)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF6B35), Color(0xFFFFBE0B)],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A1A2E), Color(0xFF252535)],
  );
}
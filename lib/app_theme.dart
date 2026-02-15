import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Premium design-system for the Banknote Recognizer app.
class AppTheme {
  // ── Brand colours ──────────────────────────────────────────────
  static const Color primary = Color(0xFF00C853);       // vibrant green
  static const Color primaryDark = Color(0xFF009624);
  static const Color accent = Color(0xFFFFD600);         // gold
  static const Color surface = Color(0xFF1A1A2E);        // deep navy
  static const Color surfaceLight = Color(0xFF16213E);
  static const Color card = Color(0xFF0F3460);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB0BEC5);

  // ── Gradients ──────────────────────────────────────────────────
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F0C29), Color(0xFF302B63), Color(0xFF24243E)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x33FFFFFF), Color(0x0DFFFFFF)],
  );

  static const LinearGradient captureButtonGradient = LinearGradient(
    colors: [Color(0xFF00C853), Color(0xFF69F0AE)],
  );

  static const LinearGradient autoDetectGradient = LinearGradient(
    colors: [Color(0xFFFFD600), Color(0xFFFFC107)],
  );

  // ── Glassmorphism decoration ───────────────────────────────────
  static BoxDecoration glassCard({double borderRadius = 20}) => BoxDecoration(
        gradient: cardGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      );

  // ── Text styles ────────────────────────────────────────────────
  static TextStyle get headlineLarge => GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      );

  static TextStyle get headlineMedium => GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      );

  static TextStyle get titleMedium => GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      );

  static TextStyle get bodyLarge => GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textSecondary,
      );

  static TextStyle get labelLarge => GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 1.2,
      );

  // ── ThemeData ──────────────────────────────────────────────────
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: surface,
        colorScheme: ColorScheme.dark(
          primary: primary,
          secondary: accent,
          surface: surface,
        ),
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: headlineMedium,
        ),
      );
}

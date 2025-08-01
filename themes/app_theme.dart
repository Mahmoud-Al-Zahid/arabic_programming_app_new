import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Light Mode Colors
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightPrimary = Color(0xFF2979FF);
  static const Color lightSecondary = Color(0xFF00E676);
  static const Color lightText = Color(0xFF212121);
  static const Color lightTextSecondary = Color(0xFF757575);

  // Dark Mode Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkPrimary = Color(0xFF64B5F6);
  static const Color darkSecondary = Color(0xFF81C784);
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      background: lightBackground,
      surface: lightSurface,
      primary: lightPrimary,
      secondary: lightSecondary,
      onBackground: lightText,
      onSurface: lightText,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
    ),
    textTheme: GoogleFonts.cairoTextTheme().copyWith(
      displayLarge: GoogleFonts.cairo(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: lightText,
      ),
      displayMedium: GoogleFonts.cairo(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: lightText,
      ),
      headlineLarge: GoogleFonts.cairo(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: lightText,
      ),
      headlineMedium: GoogleFonts.cairo(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: lightText,
      ),
      titleLarge: GoogleFonts.cairo(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: lightText,
      ),
      titleMedium: GoogleFonts.cairo(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: lightText,
      ),
      bodyLarge: GoogleFonts.cairo(
        fontSize: 16,
        color: lightText,
      ),
      bodyMedium: GoogleFonts.cairo(
        fontSize: 14,
        color: lightTextSecondary,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      background: darkBackground,
      surface: darkSurface,
      primary: darkPrimary,
      secondary: darkSecondary,
      onBackground: darkText,
      onSurface: darkText,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
    ),
    textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.cairo(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: darkText,
      ),
      displayMedium: GoogleFonts.cairo(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: darkText,
      ),
      headlineLarge: GoogleFonts.cairo(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: darkText,
      ),
      headlineMedium: GoogleFonts.cairo(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: darkText,
      ),
      titleLarge: GoogleFonts.cairo(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: darkText,
      ),
      titleMedium: GoogleFonts.cairo(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: darkText,
      ),
      bodyLarge: GoogleFonts.cairo(
        fontSize: 16,
        color: darkText,
      ),
      bodyMedium: GoogleFonts.cairo(
        fontSize: 14,
        color: darkTextSecondary,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
  );
}

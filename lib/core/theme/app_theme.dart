import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color Seeds
  static const Color primarySeed = Color(0xFF2979FF);
  static const Color secondarySeed = Color(0xFF00E676);

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primarySeed,
      secondary: secondarySeed,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: _buildTextTheme(colorScheme),
      cardTheme: _buildCardTheme(),
      elevatedButtonTheme: _buildElevatedButtonTheme(colorScheme),
      outlinedButtonTheme: _buildOutlinedButtonTheme(colorScheme),
      inputDecorationTheme: _buildInputDecorationTheme(colorScheme),
      appBarTheme: _buildAppBarTheme(colorScheme),
      navigationBarTheme: _buildNavigationBarTheme(colorScheme),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primarySeed,
      secondary: secondarySeed,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: _buildTextTheme(colorScheme),
      cardTheme: _buildCardTheme(),
      elevatedButtonTheme: _buildElevatedButtonTheme(colorScheme),
      outlinedButtonTheme: _buildOutlinedButtonTheme(colorScheme),
      inputDecorationTheme: _buildInputDecorationTheme(colorScheme),
      appBarTheme: _buildAppBarTheme(colorScheme),
      navigationBarTheme: _buildNavigationBarTheme(colorScheme),
    );
  }

  static TextTheme _buildTextTheme(ColorScheme colorScheme) {
    return GoogleFonts.cairoTextTheme().copyWith(
      displayLarge: GoogleFonts.cairo(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
      displayMedium: GoogleFonts.cairo(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
      headlineLarge: GoogleFonts.cairo(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
      headlineMedium: GoogleFonts.cairo(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      titleLarge: GoogleFonts.cairo(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      titleMedium: GoogleFonts.cairo(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
      ),
      bodyLarge: GoogleFonts.cairo(
        fontSize: 16,
        color: colorScheme.onSurface,
      ),
      bodyMedium: GoogleFonts.cairo(
        fontSize: 14,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }

  static CardTheme _buildCardTheme() {
    return CardTheme(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme(ColorScheme colorScheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }

  static OutlinedButtonThemeData _buildOutlinedButtonTheme(ColorScheme colorScheme) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme(ColorScheme colorScheme) {
    return InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  static AppBarTheme _buildAppBarTheme(ColorScheme colorScheme) {
    return AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
    );
  }

  static NavigationBarThemeData _buildNavigationBarTheme(ColorScheme colorScheme) {
    return NavigationBarThemeData(
      labelTextStyle: WidgetStateProperty.all(
        GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}

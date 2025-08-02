import 'package:flutter/material.dart';

class AppConstants {
  // Padding and Margins
  static const double defaultPadding = 16.0;
  static const double largePadding = 24.0;
  static const double smallPadding = 8.0;
  
  // Border Radius
  static const double defaultBorderRadius = 12.0;
  static const double largeBorderRadius = 20.0;
  static const double smallBorderRadius = 8.0;
  
  // Durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 600);
  static const Duration shortAnimationDuration = Duration(milliseconds: 150);
  
  // Spacing
  static const double defaultSpacing = 16.0;
  static const double largeSpacing = 24.0;
  static const double smallSpacing = 8.0;
  
  // Card Dimensions
  static const double cardElevation = 4.0;
  static const double cardHeight = 200.0;
  
  // Asset Paths
  static const String imagesPath = 'assets/images/';
  static const String tracksPath = '${imagesPath}tracks/';
  static const String lessonsPath = '${imagesPath}lessons/';
  static const String avatarsPath = '${imagesPath}avatars/';
  static const String iconsPath = '${imagesPath}icons/';
  
  // Colors
  static const Color primaryBlue = Color(0xFF4A90E2);
  static const Color primaryPurple = Color(0xFF9B59B6);
  static const Color primaryGreen = Color(0xFF2ECC71);
  static const Color primaryOrange = Color(0xFFE67E22);
  static const Color primaryPink = Color(0xFFE91E63);
  static const Color primaryGold = Color(0xFFF39C12);
  
  static const List<Color> trackColors = [
    primaryBlue,
    primaryPurple,
    primaryGreen,
    primaryOrange,
    primaryPink,
    primaryGold,
  ];
  
  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );
  
  static const TextStyle captionStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  
  // API Configuration (for future use)
  static const String baseUrl = 'https://api.arabicprogramming.app';
  static const Duration requestTimeout = Duration(seconds: 30);
  
  // Local Storage Keys
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'app_language';
  static const String progressKey = 'user_progress';
  
  // App Information
  static const String appName = 'تعلم البرمجة بالعربية';
  static const String appVersion = '1.0.0';
  
  // Social Links
  static const String githubUrl = 'https://github.com/arabicprogramming';
  static const String websiteUrl = 'https://arabicprogramming.app';
  static const String supportEmail = 'support@arabicprogramming.app';
}

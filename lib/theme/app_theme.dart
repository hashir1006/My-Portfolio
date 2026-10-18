import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Light Theme Palette (Matches reference image)
  static const Color bgLight = Color(0xFFF7F2E8); // Warm parchment cream
  static const Color textLight = Color(0xFF222222); // Deep charcoal
  static const Color goldPrimary = Color(0xFFB88946); // Rich Persian gold
  static const Color goldMuted = Color(0xFFD7B77A); // Soft luminous gold
  static const Color goldLight = Color(0xFFE8D6B2); // Pale gold
  static const Color goldDark = Color(0xFF8A6229); // Burnished gold
  static const Color navySecondary = Color(0xFF202A3B); // Deep Persian navy
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceLightAlt = Color(0xFFFAF6EE);
  static const Color mutedTextLight = Color(0xFF6E6A63); // Warm readable gray
  static const Color borderLight = Color(0xFFE5DDD0); // Delicate parchment border
  static const Color borderGold = Color(0xFFCDB07B);

  // Dark Theme Palette
  static const Color bgDark = Color(0xFF121316); // Deep charcoal
  static const Color textDark = Color(0xFFF7F2E8); // Off-white / cream
  static const Color surfaceDark = Color(0xFF1A1B20); // Dark surface
  static const Color surfaceDarkElevated = Color(0xFF22242B);
  static const Color mutedTextDark = Color(0xFFA8A399); // Soft muted gray
  static const Color borderDark = Color(0xFF2B2E38);
  static const Color borderGoldDark = Color(0xFF6E562F);

  // Common Elements
  static const Color navCapsuleLight = Color(0xFF1D1E23); // Reference image capsule
  static const Color navCapsuleDark = Color(0xFF15161A);
  static const Color placeholderSilhouette = Color(0xFF4A4E58);
  static const Color placeholderBg = Color(0xFF22242B);
}

class AppTypography {
  // Editorial Serif for Headings (Cormorant Garamond / Playfair)
  static TextStyle headingSerif({
    required BuildContext context,
    double fontSize = 32,
    FontWeight fontWeight = FontWeight.w600,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = isDark ? AppColors.textDark : AppColors.textLight;

    return GoogleFonts.cormorantGaramond(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? defaultColor,
      letterSpacing: letterSpacing ?? 0.2,
      height: height,
    );
  }

  // Modern Sans-serif for Body & UI (Inter)
  static TextStyle bodySans({
    required BuildContext context,
    double fontSize = 15,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
    double? letterSpacing,
    double? height = 1.6,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = isDark ? AppColors.textDark : AppColors.textLight;

    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? defaultColor,
      letterSpacing: letterSpacing ?? 0.1,
      height: height,
    );
  }

  // Label / Subtitle uppercase styling
  static TextStyle labelSpaced({
    required BuildContext context,
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.w600,
    Color? color,
    double letterSpacing = 2.5,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? AppColors.goldPrimary,
      letterSpacing: letterSpacing,
    );
  }
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.bgLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.goldPrimary,
        secondary: AppColors.navySecondary,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textLight,
        onPrimary: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderLight, width: 1),
        ),
      ),
      dividerColor: AppColors.borderLight,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.goldPrimary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bgDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.goldMuted,
        secondary: AppColors.goldPrimary,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textDark,
        onPrimary: Colors.black87,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderDark, width: 1),
        ),
      ),
      dividerColor: AppColors.borderDark,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceDarkElevated,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.goldMuted, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }
}

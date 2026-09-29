import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// CoLearn Design System — Minimal, Premium, Black-and-White Aesthetic
/// Human-designed, crisp typography, responsive layout system.
class AppTheme {
  AppTheme._();

  // ─── Monochrome Palette ──────────────────────────────────────
  static const Color pureBlack = Color(0xFF000000);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color darkNeutral = Color(0xFF0D0D0E);
  static const Color cardDark = Color(0xFF17171A);
  static const Color greyDark = Color(0xFF27272A);
  static const Color greyMedium = Color(0xFF52525B);
  static const Color greyLight = Color(0xFFA1A1AA);
  static const Color greySubtle = Color(0xFFE4E4E7);
  static const Color backgroundLight = Color(0xFFF9F9FA);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF4F4F5);

  // Text Colors
  static const Color textPrimary = Color(0xFF09090B);
  static const Color textSecondary = Color(0xFF52525B);
  static const Color textMuted = Color(0xFF71717A);
  static const Color textHint = Color(0xFFA1A1AA);
  static const Color textOnDark = Color(0xFFFFFFFF);

  // Status & Subtle Accent Accents
  static const Color successGreen = Color(0xFF16A34A);
  static const Color warningAmber = Color(0xFFD97706);
  static const Color errorRed = Color(0xFFDC2626);
  static const Color infoBlue = Color(0xFF2563EB);

  // Borders & Dividers
  static const Color borderColor = Color(0xFFE4E4E7);
  static const Color borderSubtle = Color(0xFFEEEEF0);
  static const Color dividerColor = Color(0xFFEBEBEF);

  // Aliases for backward compatibility
  static const Color primaryGreen = Color(0xFF0D0D0E);
  static const Color primaryGreenDark = Color(0xFF000000);
  static const Color primaryGreenLight = Color(0xFF27272A);
  static const Color secondaryGold = Color(0xFF17171A);

  // ─── Spacing ─────────────────────────────────────────────────
  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 16.0;
  static const double spacingLG = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // ─── Radii ───────────────────────────────────────────────────
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 18.0;
  static const double radiusPill = 999.0;

  // ─── Typography (Google Fonts: Plus Jakarta Sans) ─────────────
  static TextTheme _buildTextTheme() {
    return GoogleFonts.plusJakartaSansTextTheme().copyWith(
      displayLarge: GoogleFonts.plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: textPrimary,
        letterSpacing: -0.8,
        height: 1.15,
      ),
      displayMedium: GoogleFonts.plusJakartaSans(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: textPrimary,
        letterSpacing: -0.6,
        height: 1.2,
      ),
      displaySmall: GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        letterSpacing: -0.4,
        height: 1.25,
      ),
      headlineLarge: GoogleFonts.plusJakartaSans(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        letterSpacing: -0.3,
        height: 1.3,
      ),
      headlineMedium: GoogleFonts.plusJakartaSans(
        fontSize: 19,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        letterSpacing: -0.2,
        height: 1.35,
      ),
      headlineSmall: GoogleFonts.plusJakartaSans(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: -0.1,
        height: 1.4,
      ),
      titleLarge: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.4,
      ),
      titleMedium: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.45,
      ),
      titleSmall: GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: textSecondary,
        letterSpacing: 0,
        height: 1.45,
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.55,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        fontSize: 13.5,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        letterSpacing: 0,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textMuted,
        letterSpacing: 0,
        height: 1.45,
      ),
      labelLarge: GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0.3,
        height: 1.35,
      ),
      labelMedium: GoogleFonts.plusJakartaSans(
        fontSize: 11.5,
        fontWeight: FontWeight.w600,
        color: textSecondary,
        letterSpacing: 0.4,
        height: 1.35,
      ),
      labelSmall: GoogleFonts.plusJakartaSans(
        fontSize: 10.5,
        fontWeight: FontWeight.w600,
        color: textMuted,
        letterSpacing: 0.5,
        height: 1.3,
      ),
    );
  }

  // ─── Light Minimal Theme ─────────────────────────────────────
  static ThemeData get lightTheme {
    final textTheme = _buildTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: pureBlack,
        onPrimary: pureWhite,
        secondary: cardDark,
        onSecondary: pureWhite,
        surface: surfaceWhite,
        onSurface: textPrimary,
        error: errorRed,
        onError: pureWhite,
      ),
      scaffoldBackgroundColor: backgroundLight,
      textTheme: textTheme,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceWhite,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.2,
        ),
        iconTheme: const IconThemeData(color: textPrimary, size: 22),
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceWhite,
        selectedItemColor: pureBlack,
        unselectedItemColor: greyLight,
        type: BottomNavigationBarType.fixed,
        elevation: 16,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        color: surfaceWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          side: const BorderSide(color: borderColor, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button (Solid Black)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: pureBlack,
          foregroundColor: pureWhite,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),

      // Outlined Button (Crisp Monochrome Border)
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          backgroundColor: Colors.transparent,
          side: const BorderSide(color: pureBlack, width: 1.2),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: pureBlack,
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceWhite,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: pureBlack, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: errorRed),
        ),
        hintStyle: GoogleFonts.plusJakartaSans(color: textHint, fontSize: 13.5),
        labelStyle: GoogleFonts.plusJakartaSans(color: textSecondary, fontSize: 13.5),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: surfaceWhite,
        selectedColor: pureBlack,
        secondarySelectedColor: pureBlack,
        labelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 12.5,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        secondaryLabelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: pureWhite,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusPill),
          side: const BorderSide(color: borderColor),
        ),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: 1,
      ),
    );
  }
}

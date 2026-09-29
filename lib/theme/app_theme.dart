import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Radio BB Brand Color Palette
  static const Color navyDark = Color(0xFF06141F);
  static const Color navyPrimary = Color(0xFF0B2436);
  static const Color navyCard = Color(0xFF0F324B);
  static const Color navyCardLight = Color(0xFF164463);
  static const Color bluePrimary = Color(0xFF1387BB);
  static const Color blueDeep = Color(0xFF0B6E9E);
  static const Color blueSoft = Color(0xFFBFE1F0);
  static const Color amberAccent = Color(0xFFE8963C);
  static const Color creamBg = Color(0xFFF6F8F6);
  static const Color paperWhite = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFF8BA5B5);
  static const Color textLight = Color(0xFFD3E3EC);
  static const Color liveRed = Color(0xFFE53935);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: navyDark,
      primaryColor: bluePrimary,
      colorScheme: const ColorScheme.dark(
        primary: bluePrimary,
        secondary: amberAccent,
        surface: navyCard,
        onPrimary: paperWhite,
        onSecondary: navyDark,
        onSurface: paperWhite,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: navyPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.manrope(
          color: paperWhite,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(color: paperWhite),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: navyPrimary,
        selectedItemColor: bluePrimary,
        unselectedItemColor: textMuted,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 16,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.archivoBlack(
          fontSize: 32,
          color: paperWhite,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.archivoBlack(
          fontSize: 24,
          color: paperWhite,
          letterSpacing: -0.3,
        ),
        headlineMedium: GoogleFonts.manrope(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: paperWhite,
        ),
        titleLarge: GoogleFonts.manrope(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: paperWhite,
        ),
        titleMedium: GoogleFonts.manrope(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textLight,
        ),
        bodyLarge: GoogleFonts.manrope(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: paperWhite,
        ),
        bodyMedium: GoogleFonts.manrope(
          fontSize: 13.5,
          fontWeight: FontWeight.w400,
          color: textLight,
        ),
        labelLarge: GoogleFonts.jetBrainsMono(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: blueSoft,
        ),
      ),
    );
  }
}

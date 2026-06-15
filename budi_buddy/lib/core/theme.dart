import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';

abstract class AppTheme {
  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.poppinsTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: kPrimaryGreen,
        onPrimary: kWhite,
        secondary: kPrimaryAmber,
        onSecondary: kPrimaryGreen,
        error: kError,
        onError: kWhite,
        surface: kSurfaceGreen,
        onSurface: kTextPrimary,
      ),
      scaffoldBackgroundColor: kNeutralBg,
      textTheme: baseTextTheme.copyWith(
        displayLarge: GoogleFonts.poppins(
          fontSize: kFontXXL,
          fontWeight: FontWeight.w600,
          color: kTextPrimary,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: kFontLG,
          fontWeight: FontWeight.w600,
          color: kTextPrimary,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: kFontBase,
          fontWeight: FontWeight.w500,
          color: kTextPrimary,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: kFontMD,
          fontWeight: FontWeight.w400,
          color: kTextSecondary,
        ),
        bodySmall: GoogleFonts.poppins(
          fontSize: kFontSM,
          fontWeight: FontWeight.w400,
          color: kTextMuted,
        ),
        labelSmall: GoogleFonts.poppins(
          fontSize: kFontXS,
          fontWeight: FontWeight.w500,
          color: kTextMuted,
          letterSpacing: 0.08,
        ),
      ),
      appBarTheme: AppBarThemeData(
        backgroundColor: kPrimaryGreen,
        foregroundColor: kWhite,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: kWhite,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: kPrimaryGreen,
        selectedItemColor: kPrimaryAmber,
        unselectedItemColor: Colors.white.withValues(alpha: 0.5),
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w400,
        ),
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryGreen,
          foregroundColor: kWhite,
          minimumSize: const Size(double.infinity, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kRadiusMD),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: GoogleFonts.poppins(
            fontSize: kFontMD,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: kPrimaryGreen,
          minimumSize: const Size(double.infinity, 0),
          side: const BorderSide(color: kPrimaryGreen, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kRadiusMD),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: GoogleFonts.poppins(
            fontSize: kFontMD,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: kWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadiusLG),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: kWhite,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: kSpaceMD,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kRadiusMD),
          borderSide: const BorderSide(color: kSurfaceGreen, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kRadiusMD),
          borderSide: const BorderSide(color: kPrimaryGreen, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kRadiusMD),
          borderSide: const BorderSide(color: kError, width: 1),
        ),
        labelStyle: GoogleFonts.poppins(
          fontSize: kFontMD,
          color: kTextSecondary,
        ),
        hintStyle: GoogleFonts.poppins(
          fontSize: kFontMD,
          color: kTextMuted,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: kSurfaceGreen,
        thickness: 1,
        space: 0,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: kSurfaceGreen,
        labelStyle: GoogleFonts.poppins(
          fontSize: kFontSM,
          color: kPrimaryGreen,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

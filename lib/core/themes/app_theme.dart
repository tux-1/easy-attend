import 'package:easyattend/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Private constructor
  const AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      textTheme: GoogleFonts.itimTextTheme(Typography.whiteRedwoodCity),
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.dark(primary: AppColors.primary),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: AppColors.lightSilver.withValues(alpha: 0.4)
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            color: AppColors.backgroundCircleBorder,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            color: AppColors.backgroundCircleBorder,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 1,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: GoogleFonts.inter().copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            fontFeatures: [
              FontFeature.enable('bold'),
              FontFeature.enable('salt'),
            ],
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.background,
          elevation: 0, // We'll handle shadows manually
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  static BoxDecoration getElevatedButtonDecoration() {
    return BoxDecoration(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        // Inner shadow
        BoxShadow(
          color: AppColors.black20,
          offset: const Offset(0, -8),
          blurRadius: 10,
          spreadRadius: 0,
        ),
        // Drop shadow
        BoxShadow(
          color: AppColors.black25,
          offset: Offset.zero,
          blurRadius: 26,
          spreadRadius: 0,
        ),
      ],
    );
  }
}

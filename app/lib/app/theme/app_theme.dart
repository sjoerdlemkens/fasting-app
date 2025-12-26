import 'package:flutter/material.dart';
import 'package:fasting_app/app/theme/theme.dart';
import 'package:fasting_app/app/theme/app_radius.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.lightBlue,
      onPrimary: Colors.white,
      secondary: AppColors.lightBlue,
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      surface: AppColors.almostWhite,
      onSurface: Colors.black,
      surfaceContainer: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      textTheme: GoogleFonts.interTextTheme(),
      colorScheme: colorScheme,
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey.shade200.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        margin: const EdgeInsets.all(0),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
      ),
    );
  }
}

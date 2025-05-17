import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'AppColors.dart';

class AppTheme {
  // Light theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryColor,
        secondary: AppColors.secondaryColor,
        background: AppColors.backgroundColor,
        surface: AppColors.cardColor,
        onSurface: AppColors.textColor,
      ),
      scaffoldBackgroundColor: AppColors.backgroundColor,
      cardColor: AppColors.cardColor,
      textTheme: GoogleFonts.poppinsTextTheme(
        const TextTheme(
          displayLarge: TextStyle(color: AppColors.textColor),
          displayMedium: TextStyle(color: AppColors.textColor),
          displaySmall: TextStyle(color: AppColors.textColor),
          headlineLarge: TextStyle(color: AppColors.textColor),
          headlineMedium: TextStyle(color: AppColors.textColor),
          headlineSmall: TextStyle(color: AppColors.textColor),
          titleLarge: TextStyle(color: AppColors.textColor),
          titleMedium: TextStyle(color: AppColors.textColor),
          titleSmall: TextStyle(color: AppColors.textColor),
          bodyLarge: TextStyle(color: AppColors.textColor),
          bodyMedium: TextStyle(color: AppColors.secondaryTextColor),
          bodySmall: TextStyle(color: AppColors.secondaryTextColor),
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.textColor),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryColor,
          side: BorderSide(color: AppColors.primaryColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.errorColor, width: 2),
        ),
        fillColor: Colors.grey[50],
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundColor,
        foregroundColor: AppColors.textColor,
        elevation: 0,
        centerTitle: true,
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: AppColors.primaryColor,
        unselectedLabelColor: AppColors.secondaryTextColor,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.cardColor,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey[400],
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      dividerTheme: DividerThemeData(color: Colors.grey[200], thickness: 1),
    );
  }

  // Dark theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primaryColor,
        secondary: AppColors.secondaryColor,
        background: AppColors.darkBackgroundColor,
        surface: AppColors.darkCardColor,
        onSurface: AppColors.darkTextColor,
      ),
      scaffoldBackgroundColor: AppColors.darkBackgroundColor,
      cardColor: AppColors.darkCardColor,
      textTheme: GoogleFonts.poppinsTextTheme(
        const TextTheme(
          displayLarge: TextStyle(color: AppColors.darkTextColor),
          displayMedium: TextStyle(color: AppColors.darkTextColor),
          displaySmall: TextStyle(color: AppColors.darkTextColor),
          headlineLarge: TextStyle(color: AppColors.darkTextColor),
          headlineMedium: TextStyle(color: AppColors.darkTextColor),
          headlineSmall: TextStyle(color: AppColors.darkTextColor),
          titleLarge: TextStyle(color: AppColors.darkTextColor),
          titleMedium: TextStyle(color: AppColors.darkTextColor),
          titleSmall: TextStyle(color: AppColors.darkTextColor),
          bodyLarge: TextStyle(color: AppColors.darkTextColor),
          bodyMedium: TextStyle(color: AppColors.darkSecondaryTextColor),
          bodySmall: TextStyle(color: AppColors.darkSecondaryTextColor),
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.darkTextColor),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryColor,
          side: BorderSide(color: AppColors.primaryColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[700]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[700]!),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.errorColor, width: 2),
        ),
        fillColor: Colors.grey[900],
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackgroundColor,
        foregroundColor: AppColors.darkTextColor,
        elevation: 0,
        centerTitle: true,
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: AppColors.primaryColor,
        unselectedLabelColor: AppColors.darkSecondaryTextColor,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkCardColor,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey[600],
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      dividerTheme: DividerThemeData(color: Colors.grey[800], thickness: 1),
    );
  }
}

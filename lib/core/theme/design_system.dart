// lib/core/theme/design_system.dart
import 'package:flutter/material.dart';

/// Design tokens and UI standards for E-Commerce Flutter App

/// Color palette
class AppColors {
  // --- Light colors
  static const Color primary = Color(0xFFD3A270);
  static const Color secondary = Colors.black;
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // --- Dark colors
  static const Color darkPrimary = Color(0xFF4B3322);
  static const Color darkSecondary = Color(0xFFBDA786);
  static const Color darkBackground = Color(0xFF000000);
  static const Color darkSurface = Color(0xFF000000);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFFFFFFF);
  static const Color darkTextOnPrimary = Color(0xFF000000);

  // Feedback colors (same for both modes)
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);

  /// The app’s main gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 208, 231, 1), // Yellow
      Color.fromARGB(255, 27, 192, 247), // Blue
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// Spacing scale (8-pt grid)
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
}

/// Corner radii for a more modern, rounded look
class AppRadius {
  static const double small = 8.0;
  static const double normal = 16.0;
  static const double large = 32.0;
  static const double extraLarge = 48.0;
}

/// Elevation (shadow) levels
class AppElevation {
  static const double none = 0.0;
  static const double low = 2.0;
  static const double medium = 4.0;
  static const double high = 8.0;
}

/// Typography styles using Rubik font
class AppTextStyles {
  static const String fontFamily = 'Rubik';

  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  static const TextStyle body1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle body2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.4,
    color: AppColors.textSecondary,
  );
}

/// Material Button styles
class AppButtonStyles {
  static final ButtonStyle primary = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.textOnPrimary,
    minimumSize: const Size(double.infinity, 48),
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.normal),
    ),
    textStyle: const TextStyle(
      fontFamily: AppTextStyles.fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );

  static final ButtonStyle secondary = OutlinedButton.styleFrom(
    side: const BorderSide(color: AppColors.primary),
    foregroundColor: AppColors.primary,
    minimumSize: const Size(double.infinity, 48),
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.normal),
    ),
    textStyle: const TextStyle(
      fontFamily: AppTextStyles.fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );
}

/// Card decoration standard
class AppCardStyles {
  static final BoxDecoration card = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(AppRadius.normal),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: AppElevation.medium,
        offset: const Offset(0, 2),
      ),
    ],
  );
}

/// Input (TextField) decoration standard
class AppInputStyles {
  static InputDecoration defaultDecoration({String? label, String? hint}) =>
      InputDecoration(
        labelText: label,
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.small),
        ),
      );
}

/// Complete ThemeData for light & dark mode
class AppThemes {
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Rubik',
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    cardColor: AppColors.surface,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      background: AppColors.background,
      surface: AppColors.surface,
      onPrimary: AppColors.textOnPrimary,
      onSecondary: AppColors.textPrimary,
      onBackground: AppColors.textPrimary,
      onSurface: AppColors.textPrimary,
      error: AppColors.error,
    ),
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.h1,
      displayMedium: AppTextStyles.h2,
      bodyLarge: AppTextStyles.body1,
      bodyMedium: AppTextStyles.body2,
      labelSmall: AppTextStyles.caption,
    ),
  );

  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Rubik',
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.darkBackground,
    cardColor: AppColors.darkSurface,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.darkTextPrimary,
      elevation: 0,
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      secondary: AppColors.darkSecondary,
      background: AppColors.darkBackground,
      surface: AppColors.darkSurface,
      onPrimary: AppColors.darkTextOnPrimary,
      onSecondary: AppColors.darkTextPrimary,
      onBackground: AppColors.darkTextPrimary,
      onSurface: AppColors.darkTextPrimary,
      error: AppColors.error,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: AppTextStyles.fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        height: 1.25,
        color: AppColors.darkTextPrimary,
      ),
      displayMedium: TextStyle(
        fontFamily: AppTextStyles.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: AppColors.darkTextPrimary,
      ),
      bodyLarge: TextStyle(
        fontFamily: AppTextStyles.fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        height: 1.5,
        color: AppColors.darkTextPrimary,
      ),
      bodyMedium: TextStyle(
        fontFamily: AppTextStyles.fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        height: 1.5,
        color: AppColors.darkTextSecondary,
      ),
      labelSmall: TextStyle(
        fontFamily: AppTextStyles.fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.normal,
        height: 1.4,
        color: AppColors.darkTextSecondary,
      ),
    ),
  );
}

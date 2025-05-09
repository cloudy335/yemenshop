// lib/core/theme/design_system.dart
import 'package:flutter/material.dart';

/// Design tokens and UI standards for E-Commerce Flutter App

/// Color palette
class AppColors {
  // Primary brand color (icons & buttons)
  static const Color primary = Color(0xFFD3A270);
  // Secondary brand color (e.g., accents)
  static const Color secondary = Color(0xFF3D281B);

  // Feedback colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);

  // Surfaces & backgrounds
  static const Color background = Color(0xFFF5E8D7);
  static const Color surface = Color(0xFFFFFFFF);

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
}

/// Spacing scale (8-pt grid)
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
}

/// Corner radii
class AppRadius {
  static const double small = 4.0;
  static const double normal = 12.0;
  static const double large = 24.0;
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
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  static const TextStyle body1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
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
    side: BorderSide(color: AppColors.primary),
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
          vertical: AppSpacing.sm,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.small),
        ),
      );
}

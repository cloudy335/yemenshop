// lib/core/theme/app_button.dart
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'design_system.dart';

/// Platform-aware button using your primary color and Rubik font.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const AppButton({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Unified text style for both platforms
    final TextStyle textStyle = TextStyle(
      fontFamily: 'Rubik',
      color: AppColors.textOnPrimary,
      fontWeight: Platform.isIOS ? FontWeight.w500 : FontWeight.w600,
      fontSize: Platform.isIOS ? 17 : 16,
    );

    if (Platform.isIOS) {
      return SizedBox(
        height: 44,
        width: double.infinity,
        child: CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          borderRadius: BorderRadius.circular(AppRadius.normal),
          color: AppColors.primary,
          onPressed: onPressed,
          child: Text(
            label,
            style: textStyle,
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 48,
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
            minimumSize: const Size(double.infinity, 48),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.normal),
            ),
            textStyle: textStyle,
          ),
          onPressed: onPressed,
          child: Text(label),
        ),
      );
    }
  }
}

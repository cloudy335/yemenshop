// lib/core/theme/app_button.dart
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'design_system.dart';

/// Platform-aware button using your primary color and Rubik font.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;

  const AppButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.backgroundColor, // Optional parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = TextStyle(
      fontFamily: 'Rubik',
      color: AppColors.textOnPrimary,
      fontWeight: Platform.isIOS ? FontWeight.w400 : FontWeight.w400,
      fontSize: Platform.isIOS ? 15 : 14,
    );

    final Color buttonColor = backgroundColor ?? AppColors.primary;

    if (Platform.isIOS) {
      return SizedBox(
        height: 44,
        width: double.infinity,
        child: CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          borderRadius:
              BorderRadius.circular(AppRadius.normal), // Adjusted radius
          color: buttonColor,
          onPressed: onPressed,
          child: Text(
            label,
            style: textStyle,
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 56,
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: AppColors.textOnPrimary,
            minimumSize: const Size(double.infinity, 48),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(AppRadius.normal), // Adjusted radius
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

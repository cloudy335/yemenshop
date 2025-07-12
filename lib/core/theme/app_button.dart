import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'design_system.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final LinearGradient? gradient;

  const AppButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.backgroundColor, // للحالات الخاصة
    this.gradient, // في حال أردت تمرير تدرج مخصص
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = TextStyle(
      fontFamily: 'Rubik',
      color: AppColors.textOnPrimary,
      fontWeight: FontWeight.w400,
      fontSize: Platform.isIOS ? 15 : 14,
    );

    final LinearGradient buttonGradient = gradient ?? AppColors.primaryGradient;

    // تصميم الزر بالتدرج بشكل يدوي (أندرويد وiOS)
    return SizedBox(
      height: Platform.isIOS ? 44 : 56,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: buttonGradient,
          borderRadius: BorderRadius.circular(AppRadius.normal),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.normal),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.normal),
            onTap: onPressed,
            child: Center(
              child: Text(
                label,
                style: textStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

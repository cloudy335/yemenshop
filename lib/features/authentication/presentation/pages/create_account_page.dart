import 'package:flutter/material.dart';
import 'package:yemenshop/core/theme/design_system.dart';
import 'package:yemenshop/routes.dart';

class CreateAccountPageUI extends StatelessWidget {
  const CreateAccountPageUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface, // White background
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl, // Apply RTL globally
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.xl * 2.5),

                // Logo
                Image.asset(
                  'assets/images/Logo.png',
                  width: 140,
                  height: 140,
                ),

                const SizedBox(height: AppSpacing.md),

                // Title
                const Text(
                  'إنشاء حساب ',
                  style: AppTextStyles.h2,
                ),

                const SizedBox(height: AppSpacing.xl),

                // Phone Field
                TextField(
                  textAlign: TextAlign.right, // Align text to the right
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                  decoration: AppInputStyles.defaultDecoration(
                    label: 'رقم الهاتف',
                  ).copyWith(
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.normal),
                      borderSide: const BorderSide(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    labelStyle: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        color: AppColors.textPrimary,
                        fontSize: 12),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg), // Space between fields

                // Create Password Field
                TextField(
                  textAlign: TextAlign.right,
                  textAlignVertical: TextAlignVertical.center,
                  obscureText: true,
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                  decoration: AppInputStyles.defaultDecoration(
                    label: 'إنشاء كلمة المرور',
                  ).copyWith(
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.normal),
                      borderSide: const BorderSide(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    labelStyle: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        color: AppColors.textPrimary,
                        fontSize: 12),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg), // Space between fields

                // Confirm Password Field
                TextField(
                  textAlign: TextAlign.right,
                  textAlignVertical: TextAlignVertical.center,
                  obscureText: true,
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                  decoration: AppInputStyles.defaultDecoration(
                    label: 'تأكيد كلمة المرور',
                  ).copyWith(
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.normal),
                      borderSide: const BorderSide(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    labelStyle: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        color: AppColors.textPrimary,
                        fontSize: 12),
                  ),
                ),

                const SizedBox(height: 70), // Space before the button

                // Create Account button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context,
                          AppRoutes
                              .otpRegistration); // Navigate to the OTP page
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.normal),
                      ),
                    ),
                    child: const Text(
                      'إنشاء حساب',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textOnPrimary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.sm), // Space below the button

                // Navigate to Login Page
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      // Navigate back to the login screen
                      Navigator.pushNamed(context, '/login');
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                      minimumSize: const Size(50, 30),
                    ),
                    child: const Text(
                      'لديك حساب؟ تسجيل الدخول',
                      style: AppTextStyles.caption,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:yemenshop/core/theme/design_system.dart';
import 'package:yemenshop/routes.dart';

class LoginPageUI extends StatelessWidget {
  const LoginPageUI({super.key});

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
                  'تسجيل الدخول',
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
                      borderRadius: BorderRadius.circular(
                          AppRadius.normal), // Same as button
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

                // Adjusted space between input fields
                const SizedBox(
                    height: AppSpacing
                        .lg), // Space between phone and password field

                // Password Field
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
                    label: 'كلمة المرور',
                  ).copyWith(
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          AppRadius.normal), // Same as button
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

                const SizedBox(
                    height: AppSpacing
                        .sm), // Slightly smaller space for the "forgot password" text

                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.resetPassword);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
                      minimumSize: const Size(50, 30),
                    ),
                    child: const Text(
                      'نسيت كلمة المرور؟',
                      style: AppTextStyles.caption,
                    ),
                  ),
                ),

                const SizedBox(
                    height: AppSpacing.lg), // Space before login button

                // Login button just below the fields
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColors.primary, // Icon color for button
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            AppRadius.normal), // Same radius
                      ),
                    ),
                    child: const Text(
                      'تسجيل الدخول',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textOnPrimary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                    height: AppSpacing
                        .sm), // Reduced space for better visual alignment

                // Add new TextButton for creating account
                Align(
                  alignment: Alignment.center, // Center the text button
                  child: TextButton(
                    onPressed: () {
                      // Navigate to the create account screen
                      Navigator.pushNamed(context, '/create-account');
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                      minimumSize: const Size(50, 30),
                    ),
                    child: const Text(
                      'لا يوجد حساب؟ قم بإنشاء حساب',
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

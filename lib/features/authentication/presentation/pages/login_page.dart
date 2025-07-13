// lib/features/authentication/presentation/pages/login_page_ui.dart

import 'package:flutter/material.dart';
import 'package:yemenshop/core/theme/design_system.dart';
import 'package:yemenshop/routes.dart';

class LoginPageUI extends StatelessWidget {
  const LoginPageUI({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Input decoration with filled surface and no inner border
    InputDecoration _inputDecoration(String label) {
      return AppInputStyles.defaultDecoration(label: label).copyWith(
        filled: true,
        fillColor: theme.colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.normal),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.normal),
          borderSide: BorderSide.none,
        ),
        labelStyle: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          color: theme.colorScheme.onSurface,
          fontSize: 12,
        ),
      );
    }

    // Field wrapped in primary gradient border
    Widget _gradientBorderField({
      required String label,
      bool obscure = false,
      TextInputType? keyboardType,
    }) {
      return Container(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(AppRadius.normal),
        ),
        padding: const EdgeInsets.all(1),
        child: TextField(
          obscureText: obscure,
          keyboardType: keyboardType,
          textAlign: TextAlign.right,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 14,
            color: theme.colorScheme.onSurface,
          ),
          decoration: _inputDecoration(label),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.xl * 2.5),
                Image.asset('assets/images/Logo.png', width: 140, height: 140),
                const SizedBox(height: AppSpacing.md),
                Text('تسجيل الدخول',
                    style: AppTextStyles.h2.copyWith(
                      color: theme.colorScheme.onBackground,
                    )),
                const SizedBox(height: AppSpacing.xl),

                // Phone Field with primary gradient border
                _gradientBorderField(
                  label: 'رقم الهاتف',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: AppSpacing.lg),

                // Password Field with primary gradient border
                _gradientBorderField(
                  label: 'كلمة المرور',
                  obscure: true,
                ),
                const SizedBox(height: AppSpacing.sm),

                // Forgot password link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.resetPassword),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
                      minimumSize: const Size(50, 30),
                    ),
                    child: Text('نسيت كلمة المرور؟',
                        style: AppTextStyles.caption.copyWith(
                          color:
                              theme.colorScheme.onBackground.withOpacity(0.7),
                        )),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Login button with primary gradient background
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(AppRadius.normal),
                  ),
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.home),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.normal),
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
                const SizedBox(height: AppSpacing.sm),

                // Create account link
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.createAccount),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                      minimumSize: const Size(50, 30),
                    ),
                    child: Text(
                      'لا يوجد حساب؟ قم بإنشاء حساب',
                      style: AppTextStyles.caption.copyWith(
                        color: theme.colorScheme.onBackground.withOpacity(0.7),
                      ),
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

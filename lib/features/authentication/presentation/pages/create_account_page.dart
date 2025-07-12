// lib/features/authentication/presentation/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:yemenshop/routes.dart';
import 'package:yemenshop/core/theme/design_system.dart';

class CreateAccountPageUI extends StatelessWidget {
  const CreateAccountPageUI({super.key});

  @override
  Widget build(BuildContext context) {
    // Use the centralized primary gradient
    final gradient = AppColors.primaryGradient;

    // Helper to build a TextField with a gradient border
    Widget _gradientBorderField({
      required String label,
      bool obscure = false,
      TextInputType? keyboardType,
    }) {
      return Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppRadius.normal),
        ),
        padding: const EdgeInsets.all(1), // border thickness
        child: TextField(
          obscureText: obscure,
          keyboardType: keyboardType,
          textAlign: TextAlign.right,
          textAlignVertical: TextAlignVertical.center,
          style: const TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
          decoration: AppInputStyles.defaultDecoration(label: label).copyWith(
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.normal),
              borderSide: BorderSide.none,
            ),
            labelStyle: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              color: AppColors.textPrimary,
              fontSize: 12,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.xl),

                // Logo
                Image.asset(
                  'assets/images/Logo.png',
                  width: 140,
                  height: 140,
                ),

                const SizedBox(height: AppSpacing.md),

                // Title
                const Text('إنشاء حساب', style: AppTextStyles.h2),

                const SizedBox(height: AppSpacing.xl),

                // Phone Field with gradient border
                _gradientBorderField(
                  label: 'رقم الهاتف',
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: AppSpacing.lg),

                // Create Password Field with gradient border
                _gradientBorderField(
                  label: 'إنشاء كلمة المرور',
                  obscure: true,
                ),

                const SizedBox(height: AppSpacing.lg),

                // Confirm Password Field with gradient border
                _gradientBorderField(
                  label: 'تأكيد كلمة المرور',
                  obscure: true,
                ),

                const SizedBox(height: 70),

                // Create Account button with gradient fill
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(AppRadius.normal),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.otpRegistration);
                    },
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

                const SizedBox(height: AppSpacing.sm),

                // "Have an account? Login" link with gradient text
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, '/login'),
                    borderRadius: BorderRadius.circular(AppRadius.normal),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                      child: ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (bounds) => gradient.createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                        child: const Text(
                          'لديك حساب؟ تسجيل الدخول',
                          style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 13),
                        ),
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

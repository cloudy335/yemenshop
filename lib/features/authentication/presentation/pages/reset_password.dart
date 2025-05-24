import 'package:flutter/material.dart';
import 'package:yemenshop/core/theme/design_system.dart';
import 'package:yemenshop/routes.dart'; // Import routes

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        iconTheme: IconThemeData(color: AppColors.primary),
      ),
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.xl * 2.5),

                // Title
                const Text(
                  'إعادة تعيين كلمة المرور',
                  style: AppTextStyles.h2,
                ),

                const SizedBox(height: AppSpacing.md),

                // Subtitle
                const Text(
                  'يرجى إدخال رقم الهاتف لإعادة تعيين كلمة المرور.',
                  style: AppTextStyles.body2,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSpacing.xl),

                // Phone Number Field
                TextField(
                  textAlign: TextAlign.right,
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
                      fontSize: 12,
                    ),
                  ),
                ),

                const SizedBox(height: 80),

                // Reset Password Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to OTP Verification Screen using routes
                      Navigator.pushNamed(context, AppRoutes.otpReset);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.normal),
                      ),
                    ),
                    child: const Text(
                      'إرسال',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textOnPrimary,
                        fontSize: 16,
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

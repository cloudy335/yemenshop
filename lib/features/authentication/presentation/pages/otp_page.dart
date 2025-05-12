import 'package:flutter/material.dart';
import 'package:yemenshop/core/theme/design_system.dart';

class OTPPageUI extends StatelessWidget {
  const OTPPageUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
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
                  'التحقق من الرمز',
                  style: AppTextStyles.h2,
                ),

                const SizedBox(height: AppSpacing.xl),

                // Description
                const Text(
                  'أدخل الرمز المرسل إلى رقم هاتفك',
                  style: AppTextStyles.body1,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSpacing.lg),

                // OTP Input Field
                TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 6, // Assume 6-digit OTP
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 20,
                    letterSpacing: 4, // Add spacing between digits
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.surface,
                    counterText: '', // Hide character counter
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.normal),
                      borderSide: const BorderSide(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    hintText: '••••••',
                    hintStyle: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      color: AppColors.textSecondary,
                      fontSize: 20,
                      letterSpacing: 4,
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Resend Code
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Logic to resend the code
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.sm,
                      ),
                    ),
                    child: const Text(
                      'إعادة إرسال الرمز؟',
                      style: AppTextStyles.caption,
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Verify Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Logic to verify the OTP
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
                      'تحقق',
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

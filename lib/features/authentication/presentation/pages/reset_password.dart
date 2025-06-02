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
        // لون أيقونة الرجوع سيكون AppColors.primary كما هو محدد
        iconTheme: const IconThemeData(color: AppColors.primary),
        // يمكنك إضافة عنوان إذا أردت
        // title: const Text('إعادة تعيين', style: AppTextStyles.h2),
        // centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // تم إزالة Directionality
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.xl * 2.5),

              // العنوان
              const Text(
                'إعادة تعيين كلمة المرور',
                style: AppTextStyles.h2,
              ),

              const SizedBox(height: AppSpacing.md),

              // العنوان الفرعي
              const Text(
                'يرجى إدخال رقم الهاتف لإعادة تعيين كلمة المرور.',
                style: AppTextStyles.body2,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.xl),

              // حقل رقم الهاتف
              TextField(
                textAlign: TextAlign.right,
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.phone,
                style: AppTextStyles.body1.copyWith(
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
                  labelStyle: AppTextStyles.body2.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                  ),
                ),
              ),

              const SizedBox(height: 80),

              // زر إعادة تعيين كلمة المرور
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // الانتقال إلى شاشة التحقق من OTP باستخدام المسارات
                    Navigator.pushNamed(context, AppRoutes.otpReset);
                  },
                  style: AppButtonStyles
                      .primary, // <--- استخدام AppButtonStyles.primary
                  child: Text(
                    'إرسال',
                    style: AppTextStyles
                        .body1, // <--- استخدام AppTextStyles.body1 أو أي ستايل مناسب آخر
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

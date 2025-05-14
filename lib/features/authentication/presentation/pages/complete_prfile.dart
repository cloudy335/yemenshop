import 'package:flutter/material.dart';
import 'package:yemenshop/core/theme/app_button.dart';
import 'package:yemenshop/core/theme/design_system.dart';

class CompleteProfilePage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          title: const Text(
            'إكمال الملف الشخصي',
            style: AppTextStyles.h1,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.xl * 2),

                // Name Field
                _buildInputField(
                  hint: 'أدخل اسمك الكامل',
                  controller: nameController,
                ),

                const SizedBox(height: AppSpacing.lg),

                // Phone Field
                _buildInputField(
                  hint: 'أدخل رقم هاتفك',
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: AppSpacing.lg),

                // Address Field
                _buildInputField(
                  hint: 'أدخل عنوانك',
                  controller: addressController,
                  keyboardType: TextInputType.streetAddress,
                  maxLines: 3,
                ),

                const SizedBox(height: AppSpacing.xl),

                // Save Button
                AppButton(
                  label: 'حفظ التعديلات',
                  onPressed: () {
                    final name = nameController.text;
                    final phone = phoneController.text;
                    final address = addressController.text;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم تحديث البيانات بنجاح'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: controller,
          textAlign: TextAlign.right,
          textAlignVertical: TextAlignVertical.center,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
          decoration: AppInputStyles.defaultDecoration(
            label: hint,
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
            alignLabelWithHint: true,
            floatingLabelAlignment: FloatingLabelAlignment.start,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
          ),
        ),
      ],
    );
  }
}

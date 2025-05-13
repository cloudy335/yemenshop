// lib/features/authentication/presentation/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:yemenshop/routes.dart';
import 'package:yemenshop/core/theme/design_system.dart';
import 'package:yemenshop/core/theme/app_button.dart';

class CreateLoginPageUI extends StatelessWidget {
  const CreateLoginPageUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: AppSpacing.xl * 4),

              // Logo
              Image.asset(
                'assets/images/Logo.png',
                width: AppSpacing.xl * 7,
                height: AppSpacing.xl * 7,
                fit: BoxFit.contain,
              ),

              SizedBox(height: AppSpacing.lg),

              // Title
              Text(
                'المتجر اليمني',
                textAlign: TextAlign.center,
                style: AppTextStyles.h1.copyWith(color: AppColors.secondary),
              ),

              SizedBox(height: AppSpacing.xl * 5),

              // Description with line spacing
              Text(
                'انطلق في رحلة الذوق اليمني مع المتجر اليمني أول تطبيق في السعودية يجمع أفضل وأشهر المنتجات اليمنية الأصيلة مثل العسل الفاخر والبُن المختار',
                textAlign: TextAlign.right,
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.textPrimary,
                  height: 2.5,
                  wordSpacing: 1.5,
                ),
              ),

              const Spacer(),

              // Buttons Row
              Row(
                children: [
                  // Primary button with custom color
                  Expanded(
                    child: AppButton(
                      label: 'تسجيل الدخول',
                      backgroundColor: Colors.black, // New color
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.login);
                      },
                    ),
                  ),
                  SizedBox(width: AppSpacing.lg),
                  // Secondary button with default color
                  Expanded(
                    child: AppButton(
                      label: 'انشاء حساب',
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.createAccount);
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

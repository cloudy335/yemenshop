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

              // Description
              Text(
                'انطلق في رحلة الذوق اليمني مع المتجر اليمني أول تطبيق في السعودية يجمع أفضل وأشهر المنتجات اليمنية الأصيلة مثل العسل الفاخر والبُن المختار',
                textAlign: TextAlign.right,
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textPrimary,
                  height: 2.5,
                  wordSpacing: 1.5,
                ),
              ),

              const Spacer(),

              // Buttons Row
              Row(
                children: [
                  // 1) تسجيل الدخول: filled gradient
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(AppRadius.normal),
                      ),
                      child: AppButton(
                        label: 'تسجيل الدخول',
                        backgroundColor: Colors.transparent,
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.login);
                        },
                      ),
                    ),
                  ),

                  SizedBox(width: AppSpacing.lg),

                  // 2) إنشاء حساب: white fill, gradient outline, gradient text
                  Expanded(
                    child: InkWell(
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.createAccount),
                      borderRadius: BorderRadius.circular(AppRadius.normal),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(AppRadius.normal),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2), // stroke width
                          child: Container(
                            height: 56,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.normal),
                            ),
                            child: ShaderMask(
                              blendMode: BlendMode.srcIn,
                              shaderCallback: (bounds) => AppColors
                                  .primaryGradient
                                  .createShader(Rect.fromLTWH(
                                      0, 0, bounds.width, bounds.height)),
                              child: Text(
                                'إنشاء حساب',
                                style: AppTextStyles.body1.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
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

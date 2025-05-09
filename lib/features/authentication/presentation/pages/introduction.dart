// lib/features/introduction/presentation/introduction_screen.dart
import 'package:flutter/material.dart';
import 'package:yemenshop/core/theme/design_system.dart';
import 'package:yemenshop/core/theme/app_button.dart';
import 'package:yemenshop/features/authentication/presentation/pages/createLogin_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_Data> _data = [
    const _Data(
      image: 'assets/images/oldSanaa.jpg',
      title: 'اكتشف المنتجات اليمنية الأصيلة',
      subtitle: 'تصفح تشكيلتنا اليدوية والقهوة المميزة',
    ),
    const _Data(
      image: 'assets/images/treeblood.jpg',
      title: 'تسوق بسهولة وأمان',
      subtitle: 'دفع إلكتروني آمن وتوصيل سريع',
    ),
    const _Data(
      image: 'assets/images/Aden.jpg',
      title: 'ادعم المنتج المحلي',
      subtitle: 'ساهم في دعم الحرفيين والحفاظ على التراث',
    ),
  ];

  void _goHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const CreateLoginPageUI()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _data.length,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemBuilder: (context, index) {
                    final slide = _data[index];
                    return Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Semantics(
                            label: 'صورة توضيحية لـ${slide.title}',
                            child: ClipOval(
                              child: SizedBox(
                                width: AppSpacing.xl * 5,
                                height: AppSpacing.xl * 5,
                                child: Image.asset(
                                  slide.image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, error, stack) =>
                                      Container(
                                    color: AppColors.secondary.withOpacity(0.1),
                                    child: const Icon(
                                      Icons.error,
                                      color: AppColors.textOnPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: AppSpacing.lg),
                          Text(
                            slide.title,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.h2.copyWith(
                              color: AppColors.secondary,
                            ),
                          ),
                          SizedBox(height: AppSpacing.md),
                          Text(
                            slide.subtitle,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.body1.copyWith(
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_data.length, (i) {
                    final bool isActive = i == _currentPage;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin:
                          const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                      width: isActive
                          ? AppSpacing.lg
                          : AppSpacing.sm + AppSpacing.xs,
                      height: AppSpacing.sm,
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.secondary
                            : AppColors.secondary.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(AppRadius.small),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: AppButton(
                  label:
                      _currentPage < _data.length - 1 ? 'التالي' : 'ابدأ الآن',
                  onPressed: _currentPage < _data.length - 1
                      ? () => _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeOut,
                          )
                      : _goHome,
                ),
              ),
              SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

class _Data {
  final String image;
  final String title;
  final String subtitle;
  const _Data({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}

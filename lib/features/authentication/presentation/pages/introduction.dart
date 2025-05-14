import 'package:flutter/material.dart';
import 'package:yemenshop/core/theme/design_system.dart';
import 'package:yemenshop/core/theme/app_button.dart';
import 'package:yemenshop/features/authentication/presentation/pages/create_login_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  double _currentPageValue = 0.0;

  final List<_Data> _data = [
    const _Data(
      image: 'assets/images/oldSanaa.png',
      title: 'اكتشف المنتجات اليمنية الأصيلة',
      subtitle: 'تصفح تشكيلتنا اليدوية والقهوة المميزة',
    ),
    const _Data(
      image: 'assets/images/treebloood.png',
      title: 'تسوق بسهولة وأمان',
      subtitle: 'دفع إلكتروني آمن وتوصيل سريع',
    ),
    const _Data(
      image: 'assets/images/clock.png',
      title: 'ادعم المنتج المحلي',
      subtitle: 'ساهم في دعم الحرفيين والحفاظ على التراث',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPageValue = _pageController.page!;
      });
    });
  }

  void _goHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const CreateLoginPageUI()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final slide = _data[index];
                    return Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 290,
                            height: 290,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.background,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                slide.image,
                                fit: BoxFit.contain,
                                errorBuilder: (ctx, error, stack) => Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: AppColors.textOnPrimary,
                                    size: 50,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          Text(
                            slide.title,
                            style: AppTextStyles.h1.copyWith(
                              color: AppColors.textPrimary,
                              fontSize: 24,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg),
                            child: Text(
                              slide.subtitle,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.body1.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_data.length, (i) {
                    final distance = (i - _currentPageValue).abs();
                    final scale = 1.0 - distance.clamp(0.0, 1.0);

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin:
                          const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                      width: 8.0 + 4.0 * scale,
                      height: AppSpacing.sm,
                      decoration: BoxDecoration(
                        color: Color.lerp(
                          AppColors.primary.withOpacity(0.2),
                          AppColors.primary,
                          scale,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: AppButton(
                  label:
                      _currentPage < _data.length - 1 ? 'التالي' : 'ابدأ الآن',
                  onPressed: _currentPage < _data.length - 1
                      ? () => _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          )
                      : _goHome,
                  backgroundColor: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
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

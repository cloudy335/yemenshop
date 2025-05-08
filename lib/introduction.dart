import 'package:flutter/material.dart';
import 'main.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const Color _primary = Color(0xFF3D281B);
  static const Color _accent = Color(0xFFD3A270);
  static const Color _background = Color(0xFFF5E8D7);

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

  void _goHome() => Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => const HomeScreen()),
  );

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _background,
        body: SafeArea(
          child: Column(
            children: [
              // زر التخطي مع تعديل المحاذاة لليمين
              Align(
                alignment: Alignment.topRight,
                child: AnimatedOpacity(
                  opacity: _currentPage == _data.length - 1 ? 0 : 1,
                  duration: const Duration(milliseconds: 300),
                  child: TextButton(
                    onPressed: _goHome,
                    child: const Text('تخطي'),
                    style: TextButton.styleFrom(
                      foregroundColor: _primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _data.length,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemBuilder: (c, i) {
                    final d = _data[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // تحسين تحميل الصور مع إدارة الأخطاء
                          Semantics(
                            label: 'صورة توضيحية لـ${d.title}',
                            child: ClipOval(
                              child: SizedBox(
                                width: 160,
                                height: 160,
                                child: Image.asset(
                                  d.image,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) => Container(
                                        color: _primary.withOpacity(0.1),
                                        child: const Icon(
                                          Icons.error,
                                          color: Colors.white,
                                        ),
                                      ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Text(
                            d.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: _primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            d.subtitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // مؤشرات الصفحات مع تحسين الوضوح
              Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_data.length, (i) {
                    bool active = _data.length - 1 - i == _currentPage;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: active ? 24 : 12,
                      height: 8,
                      decoration: BoxDecoration(
                        color: active ? _primary : _primary.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 24),

              // زر التحكم مع تحسين التباين
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed:
                        _currentPage == _data.length - 1
                            ? _goHome
                            : () => _pageController.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOut,
                            ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: Text(
                      _currentPage == _data.length - 1 ? 'ابدأ الآن' : 'التالي',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
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

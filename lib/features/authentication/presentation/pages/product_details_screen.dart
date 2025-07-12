import 'package:flutter/material.dart';
import 'package:yemenshop/core/theme/design_system.dart';
import 'package:yemenshop/features/authentication/data/models/favorites.dart';

class ProductDetailsScreen extends StatefulWidget {
  final FavoriteItem item;
  const ProductDetailsScreen({Key? key, required this.item}) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;
  int _quantity = 1;

  void _increment() => setState(() => _quantity++);
  void _decrement() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  @override
  Widget build(BuildContext context) {
    final gradient = AppColors.primaryGradient;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Carousel with heart icon at top-right
              SizedBox(
                height: 380,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      onPageChanged: (i) => setState(() => _pageIndex = i),
                      itemCount: 1,
                      itemBuilder: (ctx, i) {
                        final page = _pageController.hasClients
                            ? (_pageController.page ?? _pageIndex.toDouble())
                            : _pageIndex.toDouble();
                        final delta = (i - page) * 30;
                        return Transform.translate(
                          offset: Offset(delta, 0),
                          child: Image.asset(
                            widget.item.imagePath,
                            width: double.infinity,
                            height: 380,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                    Positioned(
                      top: AppSpacing.md,
                      left: AppSpacing.md,
                      child: CircleAvatar(
                        backgroundColor: Colors.white70,
                        child: BackButton(color: AppColors.textPrimary),
                      ),
                    ),
                    Positioned(
                      top: AppSpacing.md,
                      right: AppSpacing.md,
                      child: CircleAvatar(
                        backgroundColor: Colors.white70,
                        child: IconButton(
                          icon: Icon(Icons.favorite_border,
                              color: AppColors.textPrimary),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title + Quantity Selector in same line
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(widget.item.title,
                                style: TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                          Row(
                            children: [
                              _qtyBtn(Icons.remove, _decrement),
                              const SizedBox(width: 8),
                              Text('$_quantity', style: AppTextStyles.h2),
                              const SizedBox(width: 8),
                              _qtyBtn(Icons.add, _increment),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.sm),

                      // Rating & Reviews
                      Row(
                        children: [
                          Icon(Icons.star, size: 20, color: AppColors.warning),
                          const SizedBox(width: 4),
                          Text('4.7', style: AppTextStyles.caption),
                          const SizedBox(width: 8),
                          Text('(5,471 مراجعة)', style: AppTextStyles.caption),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // Description
                      Text('الوصف', style: AppTextStyles.h2),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'استمتع بمذاق القهوة الغنية والفاخرة التي تم اختيار حبوبها بعناية من أجود مزارع البن. محمصة بدقة لتمنحك نكهة عميقة ومتوازنة مع لمسات عطرية رائعة تدوم طويلًا. مثالية لتبدأ بها يومك أو لترافق أوقاتك المميزة.',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // Features
                      Text('المميزات',
                          style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 19)),
                      const SizedBox(height: AppSpacing.sm),
                      _bullet('جودة عالية'),
                      _bullet('مقاوم للاهتراء'),
                      _bullet('تصميم عصري'),

                      const Spacer(),

                      // Gradient Button and Price
                      Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                width: 255,
                                height: 55,
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius: BorderRadius.circular(
                                      16), // Increased roundness
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          25), // Increased roundness
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                  ),
                                  child: const Text(
                                    'أضف إلى السلة',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          ShaderMask(
                            shaderCallback: (bounds) =>
                                AppColors.primaryGradient.createShader(bounds),
                            blendMode: BlendMode.srcIn,
                            child: Text(
                              widget.item.price.replaceAll('ريال', '﷼'),
                              style: AppTextStyles.h2.copyWith(
                                  fontSize: 25), // Increased font size
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: Colors.white),
        ),
      );

  Widget _bullet(String text) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.xs),
        child: Row(
          children: [
            const Text('• ', style: TextStyle(fontSize: 13)),
            Expanded(
              child:
                  Text(text, style: AppTextStyles.body2.copyWith(height: 1.4)),
            ),
          ],
        ),
      );
}

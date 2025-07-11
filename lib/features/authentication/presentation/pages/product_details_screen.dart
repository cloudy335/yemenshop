// lib/features/authentication/presentation/pages/product_details_screen.dart

import 'package:flutter/material.dart';
import 'package:yemenshop/core/theme/design_system.dart';
import 'package:yemenshop/features/authentication/data/models/favorites.dart';

class ProductDetailsScreen extends StatefulWidget {
  final FavoriteItem item;
  const ProductDetailsScreen({Key? key, required this.item}) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;
  bool _isFavorite = false;

  void _increment() => setState(() => _quantity++);
  void _decrement() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  void _toggleFavorite() => setState(() => _isFavorite = !_isFavorite);

  @override
  Widget build(BuildContext context) {
    const gradient = LinearGradient(
      colors: [Colors.red, Colors.blue],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    Widget _gradientPrice(String priceText) {
      return ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => gradient
            .createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
        child: Text(
          priceText,
          style: AppTextStyles.h2.copyWith(color: Colors.white),
        ),
      );
    }

    Widget _gradientBorderField({required Widget child}) {
      return DecoratedBox(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppRadius.normal),
        ),
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.normal),
            ),
            child: child,
          ),
        ),
      );
    }

    Widget _gradientIconContainer(
        {required VoidCallback onTap, required IconData icon}) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.small),
        child: Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(AppRadius.small),
          ),
          child: Icon(icon, size: 16, color: Colors.white),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Hero(
            tag: widget.item.id,
            child: Image.asset(
              widget.item.imagePath,
              width: double.infinity,
              height: 600,
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.7),
                    child: BackButton(color: AppColors.primary),
                  ),
                  InkWell(
                    onTap: _toggleFavorite,
                    borderRadius: BorderRadius.circular(AppRadius.normal),
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.7),
                      child: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.55,
            minChildSize: 0.45,
            maxChildSize: 0.90,
            builder: (context, scrollCtrl) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppRadius.normal),
                    topRight: Radius.circular(AppRadius.normal),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: AppElevation.medium,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.sm),
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollCtrl,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.md,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Gradient-colored price text
                                _gradientPrice(widget.item.price),
                                Expanded(
                                  child: Text(
                                    widget.item.title,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontFamily: AppTextStyles.fontFamily,
                                      fontSize: 26,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('4.5', style: AppTextStyles.caption),
                                const SizedBox(width: AppSpacing.sm),
                                ...List.generate(
                                  5,
                                  (i) => Icon(
                                    i < 4 ? Icons.star : Icons.star_border,
                                    size: 20,
                                    color: AppColors.warning,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Quantity selector with gradient border
                                _gradientBorderField(
                                  child: Container(
                                    height: 45,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: AppSpacing.sm),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // Gradient minus button
                                        _gradientIconContainer(
                                          onTap: _decrement,
                                          icon: Icons.remove,
                                        ),
                                        const SizedBox(width: AppSpacing.sm),
                                        Text(
                                          '$_quantity',
                                          style: AppTextStyles.h2.copyWith(
                                              color: AppColors.secondary),
                                        ),
                                        const SizedBox(width: AppSpacing.sm),
                                        // Gradient plus button
                                        _gradientIconContainer(
                                          onTap: _increment,
                                          icon: Icons.add,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Text(
                                  'الكمية',
                                  style: TextStyle(
                                    fontFamily: AppTextStyles.fontFamily,
                                    fontSize: 20,
                                    color: AppColors.textPrimary,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              'الوصف',
                              style: AppTextStyles.h2,
                              textAlign: TextAlign.right,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'هذا وصف تفصيلي للمنتج يشرح مواصفاته وفوائده للمستخدم. يناسب هذا المساحة وصفًا طويلًا مع تباعد جيد لسهولة القراءة',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xl),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: gradient,
                          borderRadius: BorderRadius.circular(AppRadius.normal),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: add widget.item with _quantity
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.md),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.normal),
                            ),
                          ),
                          child: Text(
                            'أضف إلى السلة',
                            style: AppTextStyles.body1.copyWith(
                              color: AppColors.textOnPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

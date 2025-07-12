// lib/features/authentication/presentation/pages/widgets/products_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:yemenshop/core/theme/design_system.dart';
import 'package:yemenshop/features/authentication/data/models/favorites.dart';
import 'package:yemenshop/features/authentication/presentation/pages/product_details_screen.dart';

class ProductsSection extends StatelessWidget {
  const ProductsSection({
    Key? key,
    required this.products,
    required this.onAddToCart,
    required this.favorites,
    required this.onToggleFavorite,
  }) : super(key: key);

  final List<FavoriteItem> products;
  final void Function(FavoriteItem item) onAddToCart;
  final List<FavoriteItem> favorites;
  final void Function(FavoriteItem item) onToggleFavorite;

  bool _isFavorite(FavoriteItem item) => favorites.contains(item);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'المنتجات الأكثر مبيعًا',
            style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 1),
          MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.lg,
            crossAxisSpacing: AppSpacing.md,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final item = products[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProductDetailsScreen(item: item),
                    ),
                  );
                },
                child: _ModernProductCard(
                  item: item,
                  isFavorite: _isFavorite(item),
                  onToggleFavorite: () => onToggleFavorite(item),
                  onAddToCart: () => onAddToCart(item),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ModernProductCard extends StatelessWidget {
  const _ModernProductCard({
    Key? key,
    required this.item,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onAddToCart,
  }) : super(key: key);

  final FavoriteItem item;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1) Image container with light grey outline & subtle shadow
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300, width: 1),
            borderRadius: BorderRadius.circular(19),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 0.8,
                  child: Image.asset(
                    item.imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.white70,
                    shape: const CircleBorder(),
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color:
                            isFavorite ? Colors.red : AppColors.textSecondary,
                      ),
                      onPressed: onToggleFavorite,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 2) Add extra breathing room before details
        const SizedBox(height: AppSpacing.md),

        // Title / price / add-to-cart row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: AppTextStyles.body1,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  // Price painted with app’s primary gradient
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        AppColors.primaryGradient.createShader(bounds),
                    blendMode: BlendMode.srcIn,
                    child: Text(
                      item.price,
                      style: AppTextStyles.body1.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // “Add to cart” button: filled green pill
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: onAddToCart,
                    child: Container(
                      width: 52,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Icon(
                          HugeIcons.strokeRoundedShoppingCart01,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

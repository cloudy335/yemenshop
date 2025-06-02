// lib/features/authentication/presentation/pages/widgets/products_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:yemenshop/core/theme/design_system.dart';
import 'package:yemenshop/features/authentication/data/models/favorites.dart';

class ProductsSection extends StatelessWidget {
  /// In a real app, you might fetch these from your ViewModel/Bloc/Provider.
  final List<FavoriteItem> products = [
    FavoriteItem(
      id: 'p1',
      imagePath: 'assets/images/clothes.png',
      title: 'ثوب وشال',
      price: '200 ريال',
    ),
    FavoriteItem(
      id: 'p2',
      imagePath: 'assets/images/womenclothes.png',
      title: 'جلالية يمني',
      price: '100 ريال',
    ),
    FavoriteItem(
      id: 'p3',
      imagePath: 'assets/images/coffee4.png',
      title: 'قهوة يمنية',
      price: '50 ريال',
    ),
    FavoriteItem(
      id: 'p4',
      imagePath: 'assets/images/honey5.png',
      title: 'عسل يمني',
      price: '300 ريال',
    ),
    // …you can duplicate or extend as you like
  ];

  /// Called whenever the user taps the green “Add to Cart” icon.
  final void Function(FavoriteItem item) onAddToCart;

  /// The current list of favorites, passed down from parent.
  final List<FavoriteItem> favorites;

  /// Toggle a favorite on/off (parent manages actual list).
  final void Function(FavoriteItem item) onToggleFavorite;

  ProductsSection({
    Key? key,
    required this.onAddToCart,
    required this.favorites,
    required this.onToggleFavorite,
  }) : super(key: key);

  bool _isFavorite(FavoriteItem item) {
    return favorites.contains(item);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('المنتجات الأكثر مبيعًا', style: AppTextStyles.h2),
          const SizedBox(height: AppSpacing.md),
          MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.sm,
            crossAxisSpacing: AppSpacing.sm,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final item = products[index];
              final heights = [260.0, 240.0, 280.0, 220.0];
              final imageHeight = heights[index % heights.length];

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.normal),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, 1)),
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15,
                      spreadRadius: -3,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        // Product Image
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(AppRadius.normal),
                            bottom: Radius.circular(AppRadius.normal),
                          ),
                          child: Image.asset(
                            item.imagePath,
                            height: imageHeight,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),

                        // Favorite (heart) button
                        Positioned(
                          top: 8,
                          right: 8,
                          child: CircleAvatar(
                            backgroundColor: Colors.black54,
                            child: IconButton(
                              icon: Icon(
                                _isFavorite(item)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.white,
                              ),
                              onPressed: () => onToggleFavorite(item),
                            ),
                          ),
                        ),

                        // Title / Price / Add-to-Cart overlay
                        Positioned(
                          bottom: 5,
                          left: 5,
                          right: 5,
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(AppRadius.normal),
                                top: Radius.circular(AppRadius.normal),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item.title,
                                  style: AppTextStyles.body1
                                      .copyWith(color: Colors.white),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Price text
                                    Text(
                                      item.price,
                                      style: AppTextStyles.body1.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),

                                    // "Add to Cart" button
                                    InkWell(
                                      borderRadius: BorderRadius.circular(
                                          AppRadius.normal),
                                      onTap: () => onAddToCart(item),
                                      child: Container(
                                        width: 52,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            HugeIcons
                                                .strokeRoundedShoppingCart01,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
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

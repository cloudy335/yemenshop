import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:yemenshop/core/theme/design_system.dart';
import 'package:yemenshop/features/authentication/data/models/favorites.dart';
import 'package:yemenshop/features/authentication/presentation/pages/product_details_screen.dart'; // <-- Import details screen

class FavoritesScreen extends StatelessWidget {
  final List<FavoriteItem> favorites;
  final void Function(FavoriteItem) onToggleFavorite;
  final void Function(FavoriteItem)? onAddToCart; // Optional

  const FavoritesScreen({
    Key? key,
    required this.favorites,
    required this.onToggleFavorite,
    this.onAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.appBarTheme.backgroundColor,
          foregroundColor: theme.colorScheme.onBackground,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'المفضلة',
            style: AppTextStyles.h2
                .copyWith(color: theme.colorScheme.onBackground),
          ),
        ),
        body: favorites.isEmpty
            ? Center(
                child: Text(
                  'لا توجد عناصر مفضلة',
                  style: AppTextStyles.body1
                      .copyWith(color: theme.colorScheme.onBackground),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: MasonryGridView.builder(
                  gridDelegate:
                      const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  mainAxisSpacing: AppSpacing.xl,
                  crossAxisSpacing: AppSpacing.lg,
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final item = favorites[index];
                    return ModernProductCard(
                      item: item,
                      isFavorite: true,
                      onToggleFavorite: () => onToggleFavorite(item),
                      onAddToCart: onAddToCart != null
                          ? () => onAddToCart!(item)
                          : () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('تمت الإضافة إلى السلة')),
                              );
                            },
                      // Navigation to details screen on tap
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ProductDetailsScreen(item: item),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
      ),
    );
  }
}

class ModernProductCard extends StatelessWidget {
  final FavoriteItem item;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onAddToCart;
  final VoidCallback? onTap;

  const ModernProductCard({
    Key? key,
    required this.item,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onAddToCart,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border.all(
                  color: theme.colorScheme.onBackground.withOpacity(0.2),
                  width: 1),
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
                      color: theme.colorScheme.surface.withOpacity(0.8),
                      shape: const CircleBorder(),
                      child: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite
                              ? Colors.red
                              : theme.colorScheme.onBackground,
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
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTextStyles.body1.copyWith(
                    color: theme.colorScheme.onBackground,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    // Price with gradient
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
                    // Add to cart button
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
      ),
    );
  }
}

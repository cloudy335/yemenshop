import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // for SystemUiOverlayStyle
import 'package:yemenshop/core/theme/design_system.dart';
import 'package:yemenshop/features/authentication/data/models/favorites.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hugeicons/hugeicons.dart';

class FavoritesScreen extends StatelessWidget {
  final List<FavoriteItem> favorites;
  final void Function(FavoriteItem) onToggleFavorite;

  const FavoritesScreen({
    Key? key,
    required this.favorites,
    required this.onToggleFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.surface, // pure white
        appBar: AppBar(
          // Force a fully white background, overriding any theme:
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          systemOverlayStyle:
              SystemUiOverlayStyle.dark, // status bar icons dark
          elevation: 0, // no shadow
          automaticallyImplyLeading: false,
          title: Text(
            'المفضلة',
            style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
          ),
        ),
        body: favorites.isEmpty
            ? Center(
                child: Text(
                  'لا توجد عناصر مفضلة',
                  style: AppTextStyles.body1
                      .copyWith(color: AppColors.textSecondary),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: MasonryGridView.builder(
                  gridDelegate:
                      const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                  mainAxisSpacing: AppSpacing.sm,
                  crossAxisSpacing: AppSpacing.sm,
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final item = favorites[index];
                    return _FavoriteCard(
                      item: item,
                      index: index,
                      onToggle: onToggleFavorite,
                    );
                  },
                ),
              ),
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final FavoriteItem item;
  final int index;
  final void Function(FavoriteItem) onToggle;

  const _FavoriteCard({
    Key? key,
    required this.item,
    required this.index,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Cycle through heights for a staggered (Pinterest) look
    final heights = [260.0, 240.0, 280.0, 220.0];
    final imageHeight = heights[index % heights.length];

    return Container(
      decoration: AppCardStyles.card,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppRadius.normal),
                    bottom: Radius.circular(AppRadius.normal)),
                child: Image.asset(
                  item.imagePath,
                  height: imageHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: AppSpacing.sm,
                right: AppSpacing.sm,
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  radius: 16,
                  child: IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 16,
                    ),
                    onPressed: () => onToggle(item),
                  ),
                ),
              ),
              Positioned(
                bottom: AppSpacing.xs,
                left: AppSpacing.xs,
                right: AppSpacing.xs,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
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
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.textOnPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.price,
                            style: AppTextStyles.body2.copyWith(
                              color: AppColors.textOnPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Container(
                            width: 48,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.small),
                            ),
                            child: const Icon(
                              HugeIcons.strokeRoundedShoppingCart01,
                              color: AppColors.textOnPrimary,
                              size: 18,
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
  }
}

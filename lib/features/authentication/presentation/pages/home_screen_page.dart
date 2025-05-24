import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:yemenshop/core/theme/design_system.dart';

class YemenShopHomeScreen extends StatelessWidget {
  const YemenShopHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: AppElevation.none,
        leading: IconButton(
          icon: const Icon(Icons.notifications, color: AppColors.textSecondary),
          onPressed: () {
            // Add your notification logic here
          },
        ),
        title: Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(
                      color: AppColors.textSecondary,
                      width: 1), // Add an outline
                  borderRadius: BorderRadius.circular(AppRadius.normal),
                ),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Row(
                  textDirection: TextDirection.rtl, // Add this line
                  children: [
                    const Icon(Icons.search, color: AppColors.textSecondary),
                    const SizedBox(width: AppSpacing.sm),
                    const Text(
                      'ابحث ',
                      style: AppTextStyles.body2,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Image.asset("assets/images/Logo.png", width: 50, height: 50),
          ],
        ),
        // Remove actions as notifications moved to leading
        actions: [],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Promo Section
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.normal),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/coffee.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'خصومات كبيرة',
                          style: AppTextStyles.h2,
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Text(
                          'تصل الى 50%',
                          style: AppTextStyles.body1,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Categories Section
                const Text(
                  'الفئات',
                  style: AppTextStyles.h2,
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: 110,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCategoryCard('عسل يمني',
                          HugeIcons.strokeRoundedHoney01), // Example icon
                      SizedBox(width: AppSpacing.sm),
                      _buildCategoryCard(
                          'قهوة', HugeIcons.strokeRoundedCoffee01),
                      SizedBox(width: AppSpacing.sm),
                      _buildCategoryCard(
                          'منتجات غذائية', HugeIcons.strokeRoundedOrganicFood),
                      SizedBox(width: AppSpacing.sm),
                      _buildCategoryCard(
                          'ملابس     تقليدية', HugeIcons.strokeRoundedClothes),
                      SizedBox(width: AppSpacing.sm),
                      _buildCategoryCard(
                          'جنابي',
                          HugeIcons
                              .strokeRoundedKnife01), // Use an available icon
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Most Sold Products Section
                const Text(
                  'المنتجات الأكثر مبيعًا',
                  style: AppTextStyles.h2,
                ),
                const SizedBox(height: AppSpacing.md),
                StaggeredGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSpacing.sm,
                  crossAxisSpacing: AppSpacing.sm,
                  children: [
                    StaggeredGridTile.count(
                      crossAxisCellCount: 1,
                      mainAxisCellCount: 1.5,
                      child: _buildProductCard(
                        'assets/images/clothes.png',
                        'ثوب وشال',
                        '200 ريال',
                      ),
                    ),
                    StaggeredGridTile.count(
                      crossAxisCellCount: 1,
                      mainAxisCellCount: 2,
                      child: _buildProductCard(
                        'assets/images/womenclothes.png',
                        'جلالية يمني',
                        '100 ريال',
                      ),
                    ),
                    StaggeredGridTile.count(
                      crossAxisCellCount: 1,
                      mainAxisCellCount: 1.7,
                      child: _buildProductCard(
                        'assets/images/coffee4.png',
                        'قهوة يمنية',
                        '50 ريال',
                      ),
                    ),
                    StaggeredGridTile.count(
                      crossAxisCellCount: 1,
                      mainAxisCellCount: 1.2,
                      child: _buildProductCard(
                        'assets/images/honey5.png',
                        'عسل يمني',
                        '300 ريال',
                      ),
                    ),
                    StaggeredGridTile.count(
                      crossAxisCellCount: 1,
                      mainAxisCellCount: 1.2,
                      child: _buildProductCard(
                        'assets/images/jambia.png',
                        'جنبيه يمني',
                        '300 ريال',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData iconData) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: AppSpacing.sm),
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.normal),
            color: AppColors.primary,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Icon(
            iconData,
            size: 30,
            color: AppColors.surface, // Change to your design system color
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 70,
          child: Text(
            title,
            style: AppTextStyles.body1.copyWith(fontSize: 11),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(String imagePath, String name, String price) {
    return Container(
      width: 300, // Adjust the width here
      decoration: BoxDecoration(
        color: Colors.white, // Ensure background color matches your design
        borderRadius: BorderRadius.circular(AppRadius.normal),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Shadow color
            offset: const Offset(0, 2), // Shadow position
            blurRadius: 6, // Blurriness of the shadow
            spreadRadius: 2, // Spread of the shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppRadius.normal),
                      bottom: Radius.circular(AppRadius.normal)),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Positioned(
                  top: AppSpacing.sm,
                  right: AppSpacing.sm,
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.6),
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border),
                      color: Colors.white,
                      onPressed: () {},
                    ),
                  ),
                ),
                Positioned(
                  height: 70,
                  bottom: 5,
                  left: 5,
                  right: 5,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(AppRadius.normal),
                      top: Radius.circular(AppRadius.normal),
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(0.6),
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                name,
                                style: AppTextStyles.body1.copyWith(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.right,
                              ),
                              const Text(
                                "XL L M S",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "$price",
                                style: AppTextStyles.body1.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                              Container(
                                width: 40,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(
                                  Icons.shopping_cart_checkout_outlined,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

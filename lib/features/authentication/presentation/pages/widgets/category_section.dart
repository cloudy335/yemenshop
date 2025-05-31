import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:yemenshop/core/theme/design_system.dart';
// Import your custom styles and icons here
// import 'path_to_app_text_styles.dart';
// import 'path_to_app_spacing.dart';
// import 'path_to_huge_icons.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({Key? key}) : super(key: key);

  Widget _buildCategoryCard(String title, IconData iconData) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.normal),
            color: AppColors.primary,
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 4),
            ],
          ),
          child: Icon(iconData, size: 30, color: AppColors.surface),
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('الفئات', style: AppTextStyles.h2),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 110,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCategoryCard('عسل يمني', HugeIcons.strokeRoundedHoney01),
                const SizedBox(width: AppSpacing.sm),
                _buildCategoryCard('قهوة', HugeIcons.strokeRoundedCoffee01),
                const SizedBox(width: AppSpacing.sm),
                _buildCategoryCard(
                    'منتجات غذائية', HugeIcons.strokeRoundedOrganicFood),
                const SizedBox(width: AppSpacing.sm),
                _buildCategoryCard(
                    'ملابس تقليدية', HugeIcons.strokeRoundedClothes),
                const SizedBox(width: AppSpacing.sm),
                _buildCategoryCard('جنابي', HugeIcons.strokeRoundedKnife01),
                const SizedBox(width: AppSpacing.sm),
                _buildCategoryCard(
                    'بخور يمني', HugeIcons.strokeRoundedSunCloudMidSnow01),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

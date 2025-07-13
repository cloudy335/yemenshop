// lib/features/authentication/presentation/pages/widgets/categories_section.dart

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:yemenshop/core/theme/design_system.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({Key? key}) : super(key: key);

  Widget _buildCategoryCard(
      String title, IconData iconData, BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.normal),
            gradient:
                AppColors.primaryGradient, // ← use the centralized gradient
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
            style: AppTextStyles.body1.copyWith(
              fontSize: 11,
              color: theme.colorScheme.onBackground,
            ),
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
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('الفئات',
              style: AppTextStyles.h2.copyWith(
                color: theme.colorScheme.onBackground,
              )),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 110,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCategoryCard(
                    'عسل يمني', HugeIcons.strokeRoundedHoney01, context),
                const SizedBox(width: AppSpacing.sm),
                _buildCategoryCard(
                    'قهوة', HugeIcons.strokeRoundedCoffee01, context),
                const SizedBox(width: AppSpacing.sm),
                _buildCategoryCard('منتجات غذائية',
                    HugeIcons.strokeRoundedOrganicFood, context),
                const SizedBox(width: AppSpacing.sm),
                _buildCategoryCard(
                    'ملابس تقليدية', HugeIcons.strokeRoundedClothes, context),
                const SizedBox(width: AppSpacing.sm),
                _buildCategoryCard(
                    'جنابي', HugeIcons.strokeRoundedKnife01, context),
                const SizedBox(width: AppSpacing.sm),
                _buildCategoryCard('بخور يمني',
                    HugeIcons.strokeRoundedSunCloudMidSnow01, context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

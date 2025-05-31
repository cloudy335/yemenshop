import 'package:flutter/material.dart';
import 'package:yemenshop/core/theme/design_system.dart';

Widget _buildAppBarContent() {
  return SafeArea(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          // Logo remains on the left
          Image.asset(
            "assets/images/Logo.png",
            width: 50,
            height: 50,
          ),
          const SizedBox(width: AppSpacing.md),
          // Search bar takes remaining space
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.textSecondary, width: 1),
                borderRadius: BorderRadius.circular(AppRadius.normal),
              ),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Row(
                textDirection: TextDirection.rtl,
                children: const [
                  Icon(Icons.search, color: AppColors.textSecondary),
                  SizedBox(width: AppSpacing.sm),
                  Text('ابحث ', style: AppTextStyles.body2),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

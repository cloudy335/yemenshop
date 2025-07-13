// lib/features/authentication/presentation/pages/widgets/bottom_nav_bar.dart

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:yemenshop/core/theme/design_system.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onNavBarTapped;

  const BottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onNavBarTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(
                color: theme.colorScheme.onBackground.withOpacity(0.2),
                width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onNavBarTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.colorScheme.surface,
        showUnselectedLabels: true,
        elevation: 0,

        // Make all labels theme-aware
        selectedItemColor: theme.colorScheme.onBackground,
        unselectedItemColor: theme.colorScheme.onBackground.withOpacity(0.7),
        selectedLabelStyle: AppTextStyles.body2.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onBackground,
        ),
        unselectedLabelStyle: AppTextStyles.body2.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.normal,
          color: theme.colorScheme.onBackground.withOpacity(0.7),
        ),

        items: [
          _buildItem(HugeIcons.strokeRoundedSetting06, 'الإعدادات', 0),
          _buildItem(
              HugeIcons.strokeRoundedShoppingBasketFavorite01, 'المفضلة', 1),
          _buildItem(HugeIcons.strokeRoundedHome01, 'الرئيسية', 2),
          _buildItem(HugeIcons.strokeRoundedShoppingCart01, 'السلة', 3),
          _buildItem(HugeIcons.strokeRoundedUser02, 'الحساب', 4),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildItem(IconData iconData, String label, int idx) {
    final bool isSelected = idx == selectedIndex;

    // gradient-colored icon for unselected state
    final Widget gradientIcon = ShaderMask(
      shaderCallback: (bounds) =>
          AppColors.primaryGradient.createShader(bounds),
      blendMode: BlendMode.srcIn,
      child: Icon(iconData, size: 28),
    );

    // white icon for selected state
    final Widget whiteIcon = Icon(iconData, size: 28, color: Colors.white);

    return BottomNavigationBarItem(
      label: label,
      icon: isSelected
          // selected: gradient-filled rounded container
          ? Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: whiteIcon,
            )
          // unselected: gradient-only icon
          : gradientIcon,
      activeIcon: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: whiteIcon,
      ),
    );
  }
}

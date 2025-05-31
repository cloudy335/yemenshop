import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:yemenshop/core/theme/design_system.dart';
// Import your custom classes like AppColors, AppTextStyles, HugeIcons here

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
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onNavBarTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: AppTextStyles.body2.copyWith(fontSize: 12),
        unselectedLabelStyle: AppTextStyles.body1.copyWith(fontSize: 10),
        selectedIconTheme: const IconThemeData(size: 30),
        unselectedIconTheme: const IconThemeData(size: 28),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(HugeIcons.strokeRoundedSetting06),
            label: 'الإعدادات',
          ),
          BottomNavigationBarItem(
            icon: Icon(HugeIcons.strokeRoundedShoppingBasketFavorite01),
            label: 'المفضلة',
          ),
          BottomNavigationBarItem(
            icon: Icon(HugeIcons.strokeRoundedHome01),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(HugeIcons.strokeRoundedShoppingCart01),
            label: 'السلة',
          ),
          BottomNavigationBarItem(
            icon: Icon(HugeIcons.strokeRoundedUser02),
            label: 'الحساب',
          ),
        ],
      ),
    );
  }
}

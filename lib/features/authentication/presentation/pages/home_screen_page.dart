import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:yemenshop/core/theme/design_system.dart';
import 'package:yemenshop/features/authentication/data/models/favorites.dart';
import 'package:yemenshop/features/authentication/presentation/pages/favorites_screen.dart';
import 'package:yemenshop/features/authentication/presentation/pages/profile_screen.dart';
import 'package:yemenshop/features/authentication/presentation/pages/settings_screen.dart';
import 'package:yemenshop/features/authentication/presentation/pages/widgets/app_bar_content.dart';
import 'package:yemenshop/features/authentication/presentation/pages/widgets/bottom_nav_bar.dart';
import 'package:yemenshop/features/authentication/presentation/pages/widgets/category_section.dart';
import 'package:yemenshop/features/authentication/presentation/pages/widgets/product_tile.dart';
import 'package:yemenshop/features/authentication/presentation/pages/widgets/promo_carsousel.dart';

class YemenShopHomeScreen extends StatefulWidget {
  const YemenShopHomeScreen({Key? key}) : super(key: key);

  @override
  State<YemenShopHomeScreen> createState() => _YemenShopHomeScreenState();
}

class _YemenShopHomeScreenState extends State<YemenShopHomeScreen> {
  final PageController _promoController = PageController();
  int _currentPromoPage = 0;

  final ScrollController _scrollController = ScrollController();
  bool _showTopShadow = false;

  final List<FavoriteItem> _favorites = [];
  int _selectedIndex = 4;

  // Now using a PromoAd model that promo_carsousel.dart expects:
  final List<PromoAd> promoAds = [
    PromoAd(
      id: 'a',
      imagePath: 'assets/images/coffee.png',
      title: 'خصومات كبيرة',
      subtitle: 'تصل الى 50%',
      price: '100 ريال',
    ),
    PromoAd(
      id: 'b',
      imagePath: 'assets/images/honey5.png',
      title: 'أفضل العسل اليمني',
      subtitle: 'خصم حتى 30%',
      price: '200 ريال',
    ),
    PromoAd(
      id: 'c',
      imagePath: 'assets/images/coffee4.png',
      title: 'قهوة يمنية طازجة',
      subtitle: 'توصيل مجاني',
      price: '150 ريال',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    Timer.periodic(const Duration(seconds: 4), (_) {
      setState(() {
        _currentPromoPage = (_currentPromoPage + 1) % promoAds.length;
      });
      if (_promoController.hasClients) {
        _promoController.animateToPage(
          _currentPromoPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _promoController.dispose();
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    final show = _scrollController.offset > 20;
    if (show != _showTopShadow) {
      setState(() => _showTopShadow = show);
    }
  }

  bool _isFavorite(FavoriteItem item) => _favorites.contains(item);

  void _toggleFavorite(FavoriteItem item) {
    setState(() {
      if (_isFavorite(item)) {
        _favorites.remove(item);
      } else {
        _favorites.add(item);
      }
    });
  }

  void _onNavBarTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const SettingsScreen(),
          FavoritesScreen(
            favorites: _favorites,
            onToggleFavorite: _toggleFavorite,
          ),
          _buildHomeContent(),
          const CartScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onNavBarTapped: _onNavBarTapped,
      ),
    );
  }

  Widget _buildHomeContent() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            automaticallyImplyLeading: false,
            expandedHeight: 100,
            backgroundColor: AppColors.surface,
            elevation: 0,
            flexibleSpace: const FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: AppBarContent(),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              PromoCarousel(
                promoController: _promoController,
                promoAds: promoAds,
              ),

              // ← REPLACED: _buildCategoriesSection()
              const CategoriesSection(),

              ProductsSection(),
            ]),
          ),
        ],
      ),
    );
  }

  /// No need for _buildCategoriesSection() or _buildCategoryCard() anymore,
  /// because we're using CategoriesSection() instead.
}

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('السلة'),
          backgroundColor: AppColors.surface,
          elevation: 1,
        ),
        body: const Center(
          child: Text(
            'محتوى صفحة السلة هنا',
            style: AppTextStyles.body1,
          ),
        ),
      ),
    );
  }
}

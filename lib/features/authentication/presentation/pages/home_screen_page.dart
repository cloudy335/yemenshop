import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:yemenshop/core/theme/design_system.dart';
import 'package:yemenshop/features/authentication/data/models/favorites.dart';
import 'package:yemenshop/features/authentication/presentation/pages/favorites_screen.dart';
import 'package:yemenshop/features/authentication/presentation/pages/profile_screen.dart';
import 'package:yemenshop/features/authentication/presentation/pages/settings_screen.dart';

class YemenShopHomeScreen extends StatefulWidget {
  const YemenShopHomeScreen({Key? key}) : super(key: key);

  @override
  State<YemenShopHomeScreen> createState() => _YemenShopHomeScreenState();
}

class _YemenShopHomeScreenState extends State<YemenShopHomeScreen> {
  // Promo carousel controller & current page index
  final PageController _promoController = PageController();
  int _currentPromoPage = 0;

  // Scroll shadow logic
  final ScrollController _scrollController = ScrollController();
  bool _showTopShadow = false;

  // Favorites storage
  final List<FavoriteItem> _favorites = [];

  // Bottom nav: 0=Settings, 1=Favorites, 2=Cart, 3=Profile, 4=Home
  int _selectedIndex = 4;

  // Sample promo ads
  final List<FavoriteItem> promoAds = [
    FavoriteItem(
      id: 'a',
      imagePath: 'assets/images/coffee.png',
      title: 'خصومات كبيرة',
      price: 'تصل الى 50%',
    ),
    FavoriteItem(
      id: 'b',
      imagePath: 'assets/images/honey5.png',
      title: 'أفضل العسل اليمني',
      price: 'خصم حتى 30%',
    ),
    FavoriteItem(
      id: 'c',
      imagePath: 'assets/images/coffee4.png',
      title: 'قهوة يمنية طازجة',
      price: 'توصيل مجاني',
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
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildHomeContent() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                automaticallyImplyLeading: false,
                expandedHeight: 100,
                backgroundColor: AppColors.surface,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: _buildAppBarContent(),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  _buildPromoSection(),
                  _buildCategoriesSection(),
                  _buildProductsSection(),
                ]),
              ),
            ],
          ),
          /*if (_showTopShadow) _buildTopShadow(),*/
        ],
      ),
    );
  }

  Widget _buildAppBarContent() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Row(
          children: [
            Image.asset("assets/images/Logo.png", width: 50, height: 50),
            const SizedBox(width: AppSpacing.md),
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
                    Text('ابحث', style: AppTextStyles.body2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*Widget _buildTopShadow() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: _showTopShadow ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.7), Colors.transparent],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 10,
                offset: const Offset(0, 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
*/
  Widget _buildPromoSection() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: SizedBox(
        height: 180,
        child: PageView.builder(
          controller: _promoController,
          itemCount: promoAds.length,
          itemBuilder: (context, index) {
            final p = promoAds[index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
                borderRadius: BorderRadius.circular(AppRadius.normal),
                image: DecorationImage(
                  image: AssetImage(p.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.title,
                      style: AppTextStyles.h2.copyWith(
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      p.price,
                      style: AppTextStyles.body1.copyWith(
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
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

  /// MasonryGridView for Pinterest-like layout, keeping the original card design.
  /// Each image now has a fixed but varying height based on index so cards stagger.
  Widget _buildProductsSection() {
    final products = [
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
      FavoriteItem(
        id: 'p4',
        imagePath: 'assets/images/honey5.png',
        title: 'عسل يمني',
        price: '300 ريال',
      ),
      FavoriteItem(
        id: 'p2',
        imagePath: 'assets/images/womenclothes.png',
        title: 'جلالية يمني',
        price: '100 ريال',
      ),
      FavoriteItem(
        id: 'p1',
        imagePath: 'assets/images/clothes.png',
        title: 'ثوب وشال',
        price: '200 ريال',
      ),
      // يمكنك إضافة عناصر أخرى بأطوال صور مختلفة لتلاحظ اختلاف الطول
    ];

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
              return _buildProductCard(products[index], index);
            },
          ),
        ],
      ),
    );
  }

  /// Original-style card, but image heights vary by index for a staggered look:
  /// index 0→260, 1→240, 2→280, 3→220, then repeat.
  Widget _buildProductCard(FavoriteItem item, int index) {
    // Define a list of heights to cycle through
    final heights = [260.0, 240.0, 280.0, 220.0];
    final imageHeight = heights[index % heights.length];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.normal),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 1)),
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
          // Image with varying height per index to create staggered effect
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
                    onPressed: () => _toggleFavorite(item),
                  ),
                ),
              ),
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
                        style:
                            AppTextStyles.body1.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.price,
                            style: AppTextStyles.body1.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                          Container(
                            width: 52,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              HugeIcons.strokeRoundedShoppingCart01,
                              color: Colors.white,
                              size: 20,
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

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTapped,
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

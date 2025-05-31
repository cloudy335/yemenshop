import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:yemenshop/core/theme/design_system.dart' as design;
import 'package:yemenshop/core/theme/design_system.dart';
import 'package:yemenshop/features/authentication/presentation/pages/cart_page.dart';

class YemenShopHomeScreen extends StatefulWidget {
  const YemenShopHomeScreen({Key? key}) : super(key: key);

  @override
  State<YemenShopHomeScreen> createState() => _YemenShopHomeScreenState();
}

class _YemenShopHomeScreenState extends State<YemenShopHomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _selectedIndex = 0;

  final List<Map<String, String>> promoAds = [
    {
      'image': 'assets/images/coffee.png',
      'title': 'خصومات كبيرة',
      'subtitle': 'تصل الى 50%',
    },
    {
      'image': 'assets/images/honey5.png',
      'title': 'أفضل العسل اليمني',
      'subtitle': 'خصم حتى 30%',
    },
    {
      'image': 'assets/images/coffee4.png',
      'title': 'قهوة يمنية طازجة',
      'subtitle': 'توصيل مجاني',
    },
  ];

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_currentPage < promoAds.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onNavBarTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CartScreenUI(
            items: const [],
            subTotal: 0.0,
            deliveryFee: 0.0,
            discount: 0.0,
            totalCost: 0.0,
            onQuantityChanged: (item, quantity) {},
            onRemoveItem: (item) {},
            onUndoRemove: (item) {},
            onApplyPromoCode: (code) {},
            onCheckout: () {},
          ),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
    print("Tapped navigation item: $index");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: design.AppColors.surface,
      appBar: AppBar(
        backgroundColor: design.AppColors.surface,
        elevation: design.AppElevation.none,
        leading: IconButton(
          icon: const Icon(Icons.notifications,
              color: design.AppColors.textSecondary),
          onPressed: () {},
        ),
        title: Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: design.AppColors.surface,
                  border: Border.all(
                      color: design.AppColors.textSecondary, width: 1),
                  borderRadius: BorderRadius.circular(design.AppRadius.normal),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: design.AppSpacing.sm),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: const [
                    Icon(Icons.search, color: design.AppColors.textSecondary),
                    SizedBox(width: design.AppSpacing.sm),
                    Text('ابحث ', style: design.AppTextStyles.body2),
                  ],
                ),
              ),
            ),
            SizedBox(width: design.AppSpacing.md),
            Image.asset("assets/images/Logo.png", width: 50, height: 50),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
                color: Colors.grey.shade300,
                width: 1), // line color & thickness
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onNavBarTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: design.AppColors.surface,
          selectedItemColor: design.AppColors.primary,
          unselectedItemColor: design.AppColors.textSecondary,
          selectedLabelStyle: design.AppTextStyles.body2
              .copyWith(color: design.AppColors.primary, fontSize: 12),
          unselectedLabelStyle: design.AppTextStyles.body1
              .copyWith(color: design.AppColors.textSecondary, fontSize: 10),
          selectedIconTheme:
              const IconThemeData(size: 30, color: design.AppColors.primary),
          unselectedIconTheme: const IconThemeData(
              size: 28, color: design.AppColors.textSecondary),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(HugeIcons.strokeRoundedUser02),
              label: 'الحساب',
            ),
            BottomNavigationBarItem(
              icon: Icon(HugeIcons.strokeRoundedShoppingCart01),
              label: 'السلة',
            ),
            BottomNavigationBarItem(
              icon: Icon(HugeIcons.strokeRoundedHome01),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(HugeIcons.strokeRoundedShoppingBasketFavorite01),
              label: 'المفضلة',
            ),
            BottomNavigationBarItem(
              icon: Icon(HugeIcons.strokeRoundedSetting06),
              label: 'الإعدادات',
            ),
          ],
        ),
      ),
      body: _buildHomeContent(),
    );
  }

  Widget _buildHomeContent() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(design.AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Promo Carousel ---
              SizedBox(
                height: 180,
                width: double.infinity,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: promoAds.length,
                  itemBuilder: (context, index) {
                    final promo = promoAds[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(design.AppRadius.normal),
                        image: DecorationImage(
                          image: AssetImage(promo['image']!),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(design.AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              promo['title']!,
                              style: design.AppTextStyles.h2.copyWith(
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.7),
                                    offset: const Offset(1, 1),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: design.AppSpacing.sm),
                            Text(
                              promo['subtitle']!,
                              style: design.AppTextStyles.body1.copyWith(
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.7),
                                    offset: const Offset(1, 1),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                ),
              ),

              const SizedBox(height: design.AppSpacing.md),
              const Text('الفئات', style: design.AppTextStyles.h2),
              const SizedBox(height: design.AppSpacing.md),
              SizedBox(
                height: 110,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildCategoryCard(
                        'عسل يمني', HugeIcons.strokeRoundedHoney01),
                    const SizedBox(width: design.AppSpacing.sm),
                    _buildCategoryCard('قهوة', HugeIcons.strokeRoundedCoffee01),
                    const SizedBox(width: design.AppSpacing.sm),
                    _buildCategoryCard(
                        'منتجات غذائية', HugeIcons.strokeRoundedOrganicFood),
                    const SizedBox(width: design.AppSpacing.sm),
                    _buildCategoryCard(
                        'ملابس تقليدية', HugeIcons.strokeRoundedClothes),
                    const SizedBox(width: design.AppSpacing.sm),
                    _buildCategoryCard('جنابي', HugeIcons.strokeRoundedKnife01),
                  ],
                ),
              ),

              const SizedBox(height: design.AppSpacing.lg),
              const Text('المنتجات الأكثر مبيعًا',
                  style: design.AppTextStyles.h2),
              const SizedBox(height: design.AppSpacing.md),
              StaggeredGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: design.AppSpacing.sm,
                crossAxisSpacing: design.AppSpacing.sm,
                children: [
                  StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: 1.5,
                    child: _buildProductCard(
                        'assets/images/clothes.png', 'ثوب وشال', '200 ريال'),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: 2,
                    child: _buildProductCard('assets/images/womenclothes.png',
                        'جلالية يمني', '100 ريال'),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: 1.7,
                    child: _buildProductCard(
                        'assets/images/coffee4.png', 'قهوة يمنية', '50 ريال'),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: 1.2,
                    child: _buildProductCard(
                        'assets/images/honey5.png', 'عسل يمني', '300 ريال'),
                  ),
                ],
              ),
            ],
          ),
        ),
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
            borderRadius: BorderRadius.circular(design.AppRadius.normal),
            color: design.AppColors.primary,
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Icon(iconData, size: 30, color: design.AppColors.surface),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 70,
          child: Text(
            title,
            style: design.AppTextStyles.body1.copyWith(fontSize: 11),
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
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(design.AppRadius.normal),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(design.AppRadius.normal),
                      bottom: Radius.circular(design.AppRadius.normal)),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border),
                      color: Colors.white,
                      onPressed: () {},
                    ),
                  ),
                ),
                Positioned(
                  bottom: 5,
                  left: 5,
                  right: 5,
                  child: Container(
                    padding: const EdgeInsets.all(design.AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(design.AppRadius.normal),
                          top: Radius.circular(design.AppRadius.normal)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(name,
                                style: design.AppTextStyles.body1
                                    .copyWith(color: Colors.white)),
                            const Text("XL L M S",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 11)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(price,
                                style: design.AppTextStyles.body1.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11)),
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
                                  size: 20),
                            ),
                          ],
                        ),
                      ],
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

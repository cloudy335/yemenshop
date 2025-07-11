// lib/features/authentication/presentation/pages/yemen_shop_home_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:yemenshop/core/theme/design_system.dart';
import 'package:yemenshop/features/authentication/data/models/favorites.dart';
import 'package:yemenshop/features/authentication/presentation/pages/cart_page.dart';
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

  // keep track of favorites and cart items
  final List<FavoriteItem> _favorites = [];
  final List<CartItem> _cartItems = [];

  // your master product list
  final List<FavoriteItem> _allProducts = [
    FavoriteItem(
      id: 'a',
      title: 'قهوة يمنية طازجة',
      imagePath: 'assets/images/coffee.png',
      price: '150 ريال',
    ),
    FavoriteItem(
      id: 'b',
      title: 'أفضل العسل اليمني',
      imagePath: 'assets/images/honey5.png',
      price: '200 ريال',
    ),
    FavoriteItem(
      id: 'c',
      title: 'خصومات كبيرة',
      imagePath: 'assets/images/coffee4.png',
      price: '100 ريال',
    ),
  ];

  // bottom-nav index
  int _selectedIndex = 2;

  // promo ads
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
    final shouldShow = _scrollController.offset > 20;
    if (shouldShow != _showTopShadow) {
      setState(() => _showTopShadow = shouldShow);
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

  void _addToCart(FavoriteItem fav) {
    final unitPrice = double.tryParse(
          fav.price.replaceAll(RegExp(r'[^0-9.]'), ''),
        ) ??
        0.0;
    final newItem = CartItem(
      id: fav.id,
      name: fav.title,
      imagePath: fav.imagePath,
      price: unitPrice,
      quantity: 1,
    );
    setState(() {
      final idx = _cartItems.indexWhere((c) => c.id == newItem.id);
      if (idx >= 0) {
        _cartItems[idx].quantity += 1;
      } else {
        _cartItems.add(newItem);
      }
    });
  }

  void _onQuantityChanged(String itemId, int change) {
    setState(() {
      final idx = _cartItems.indexWhere((c) => c.id == itemId);
      if (idx < 0) return;
      final newQty = _cartItems[idx].quantity + change;
      if (newQty <= 0) {
        _cartItems.removeAt(idx);
      } else {
        _cartItems[idx].quantity = newQty;
      }
    });
  }

  void _onRemoveItem(String itemId) {
    setState(() => _cartItems.removeWhere((c) => c.id == itemId));
  }

  void _onUndoRemove(CartItem removedItem) {
    setState(() => _cartItems.add(removedItem));
  }

  void _onApplyPromoCode(String code) {
    final valid = code == 'SAVE10' && _cartItems.isNotEmpty;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          valid ? 'رمز العرض SAVE10 تم تفعيله!' : 'رمز العرض غير صالح',
        ),
      ),
    );
  }

  void _onCheckout() {
    final msg =
        _cartItems.isEmpty ? 'السلة فارغة' : 'جاري الانتقال إلى صفحة الدفع...';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  void _onNavBarTapped(int index) {
    setState(() => _selectedIndex = index);
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
            backgroundColor: Colors.transparent,
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
              const CategoriesSection(),
              // ← here we pass in the real product list
              ProductsSection(
                products: _allProducts,
                favorites: _favorites,
                onToggleFavorite: _toggleFavorite,
                onAddToCart: _addToCart,
              ),
            ]),
          ),
        ],
      ),
    );
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
          CartScreenUI(
            items: _cartItems,
            subTotal: _cartItems.fold(
              0.0,
              (sum, item) => sum + (item.price * item.quantity),
            ),
            deliveryFee: 0.0,
            discount: 0.0,
            totalCost: _cartItems.fold(
              0.0,
              (sum, item) => sum + (item.price * item.quantity),
            ),
            onQuantityChanged: _onQuantityChanged,
            onRemoveItem: _onRemoveItem,
            onUndoRemove: _onUndoRemove,
            onCheckout: _onCheckout,
          ),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onNavBarTapped: _onNavBarTapped,
      ),
    );
  }
}

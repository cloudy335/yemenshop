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

  // Keep track of "favorites":
  final List<FavoriteItem> _favorites = [];

  // Keep track of "cart" as a list of CartItem:
  final List<CartItem> _cartItems = [];

  // Bottom‐nav index:
  int _selectedIndex = 2; // Start on Home (index 2)

  // Your promo ads (passed into PromoCarousel):
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

    // Auto‐scroll the promo carousel every 4 seconds:
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

  /// Convert a FavoriteItem → CartItem and add to cart (or bump qty if exists).
  void _addToCart(FavoriteItem fav) {
    final unitPrice = double.tryParse(
          fav.price.replaceAll(RegExp(r'[^0-9.]'), ''),
        ) ??
        0.0;

    // Create a new CartItem:
    final newItem = CartItem(
      id: fav.id,
      name: fav.title,
      imagePath: fav.imagePath,
      price: unitPrice,
      quantity: 1,
    );

    setState(() {
      final existingIndex =
          _cartItems.indexWhere((cart) => cart.id == newItem.id);
      if (existingIndex >= 0) {
        // If already in cart, increment quantity (now allowed, since quantity is mutable)
        _cartItems[existingIndex].quantity += 1;
      } else {
        // Otherwise, add as a new line:
        _cartItems.add(newItem);
      }
    });
  }

  /// Called by CartScreenUI when the “+” or “–” button is tapped.
  void _onQuantityChanged(String itemId, int change) {
    setState(() {
      final idx = _cartItems.indexWhere((c) => c.id == itemId);
      if (idx < 0) return;
      final old = _cartItems[idx];
      final newQty = old.quantity + change;
      if (newQty <= 0) {
        _cartItems.removeAt(idx);
      } else {
        old.quantity = newQty;
      }
    });
  }

  /// Called by CartScreenUI when the user swipes‐to‐delete a line.
  void _onRemoveItem(String itemId) {
    setState(() {
      _cartItems.removeWhere((c) => c.id == itemId);
    });
  }

  /// Called by CartScreenUI if the user taps “Undo” after removal.
  void _onUndoRemove(CartItem removedItem) {
    setState(() {
      _cartItems.add(removedItem);
    });
  }

  /// Called by CartScreenUI when the user enters a promo code.
  void _onApplyPromoCode(String code) {
    // Example: apply a flat 10.0 discount if code == "SAVE10"
    if (code == 'SAVE10' && _cartItems.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('رمز العرض SAVE10 وافد بنجاح!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('رمز العرض غير صالح')),
      );
    }
  }

  /// Called by CartScreenUI when the user taps “Checkout”
  void _onCheckout() {
    if (_cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('السلة فارغة')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('جاري الانتقال إلى صفحة الدفع...')),
    );
    // e.g. Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentScreen()));
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
          // 0: Settings Tab
          const SettingsScreen(),

          // 1: Favorites Tab
          FavoritesScreen(
            favorites: _favorites,
            onToggleFavorite: _toggleFavorite,
          ),

          // 2: Home Tab
          _buildHomeContent(),

          // 3: Cart Tab
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
            onApplyPromoCode: _onApplyPromoCode,
            onCheckout: _onCheckout,
          ),

          // 4: Profile Tab
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

              const CategoriesSection(),

              // Pass in our callbacks and favorites list:
              ProductsSection(
                onAddToCart: _addToCart,
                favorites: _favorites,
                onToggleFavorite: _toggleFavorite,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemenshop/core/theme/design_system.dart';
import 'package:yemenshop/features/authentication/data/models/favorites.dart';
import 'package:yemenshop/features/authentication/data/models/cart_item.dart'
    as cart_model;
import 'package:yemenshop/features/authentication/presentation/bloc/blocs.dart';
import 'package:yemenshop/features/authentication/presentation/pages/widgets/app_bar_content.dart';
import 'package:yemenshop/features/authentication/presentation/pages/widgets/bottom_nav_bar.dart';
import 'package:yemenshop/features/authentication/presentation/pages/widgets/category_section.dart';
import 'package:yemenshop/features/authentication/presentation/pages/widgets/product_tile.dart';
import 'package:yemenshop/features/authentication/presentation/pages/widgets/promo_carsousel.dart';
// Import the screens we need for navigation
import 'settings_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';
// Import the original cart components
import 'cart_page.dart';

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

  int _selectedIndex = 2; // Start with home (index 2)

  final List<PromoAd> promoAds = [
    PromoAd(
      id: 'a',
      imagePath: 'assets/images/coffee.png',
      title: 'قهوة',
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

    // Load products using BLoC
    context.read<ProductBloc>().add(LoadProducts());

    // Load cart using BLoC
    context.read<CartBloc>().add(LoadCart());

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Set system UI overlay style when dependencies change
    final isDark = Theme.of(context).brightness == Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
    ));
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

  void _toggleFavorite(FavoriteItem item) {
    context.read<ProductBloc>().add(ToggleFavorite(product: item));
  }

  void _addToCart(FavoriteItem fav) {
    final unitPrice = double.tryParse(
          fav.price.replaceAll(RegExp(r'[^0-9.]'), ''),
        ) ??
        0.0;
    final newItem = cart_model.CartItem(
      id: fav.id,
      name: fav.title,
      imagePath: fav.imagePath,
      price: unitPrice,
      quantity: 1,
    );
    context.read<CartBloc>().add(AddToCart(item: newItem));
  }

  void _onNavBarTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              // Settings Screen (index 0)
              SettingsScreen(),

              // Favorites Screen (index 1)
              BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductsLoaded) {
                    return FavoritesScreen(
                      favorites: state.favorites,
                      onToggleFavorite: _toggleFavorite,
                      onAddToCart: _addToCart,
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),

              // Home Screen (index 2)
              _buildHomeContent(),

              // Cart Screen (index 3)
              BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  if (state is CartLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is CartLoaded) {
                    return _buildOriginalCartScreen(state.items, state.total);
                  }

                  if (state is CartError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'حدث خطأ في تحميل السلة',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.7),
                                ),
                          ),
                        ],
                      ),
                    );
                  }

                  // For CartInitial state, show empty cart
                  return _buildOriginalCartScreen([], 0.0);
                },
              ),

              // Profile Screen (index 4)
              ProfileScreen(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavBar(
          selectedIndex: _selectedIndex,
          onNavBarTapped: _onNavBarTapped,
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        // App Bar
        AppBarContent(),

        // Main Content with BLoC
        Expanded(
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ProductsLoaded) {
                return _buildContent(state.products, state.favorites);
              }

              if (state is ProductError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'حدث خطأ في تحميل المنتجات',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.7),
                            ),
                      ),
                    ],
                  ),
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContent(
      List<FavoriteItem> products, List<FavoriteItem> favorites) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Your original Promo Carousel
        SliverToBoxAdapter(
          child: PromoCarousel(
            promoController: _promoController,
            promoAds: promoAds,
          ),
        ),

        // Your original Categories Section
        const SliverToBoxAdapter(
          child: CategoriesSection(),
        ),

        // Your original Products Section
        SliverToBoxAdapter(
          child: ProductsSection(
            products: products,
            favorites: favorites,
            onToggleFavorite: _toggleFavorite,
            onAddToCart: _addToCart,
          ),
        ),
      ],
    );
  }

  Widget _buildOriginalCartScreen(
      List<cart_model.CartItem> blocItems, double total) {
    // Convert BLoC cart items to the format expected by CartScreenUI
    final List<CartItem> originalItems = blocItems
        .map((blocItem) => CartItem(
              id: blocItem.id,
              name: blocItem.name,
              imagePath: blocItem.imagePath,
              quantity: blocItem.quantity,
              price: blocItem.price,
            ))
        .toList();

    // Calculate fees (you can adjust these values)
    final double deliveryFee = 10.0;
    final double discount = 0.0;
    final double totalCost = total + deliveryFee - discount;

    return CartScreenUI(
      items: originalItems,
      subTotal: total,
      deliveryFee: deliveryFee,
      discount: discount,
      totalCost: totalCost,
      onQuantityChanged: (itemId, change) {
        context.read<CartBloc>().add(
              UpdateQuantity(
                itemId: itemId,
                quantity: change,
              ),
            );
      },
      onRemoveItem: (itemId) {
        context.read<CartBloc>().add(RemoveFromCart(itemId: itemId));
      },
      onUndoRemove: (removedItem) {
        // Convert back to BLoC format
        final blocItem = cart_model.CartItem(
          id: removedItem.id,
          name: removedItem.name,
          imagePath: removedItem.imagePath,
          price: removedItem.price,
          quantity: removedItem.quantity,
        );
        context.read<CartBloc>().add(AddToCart(item: blocItem));
      },
      onCheckout: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('جاري الانتقال إلى الدفع...'),
          ),
        );
      },
    );
  }
}

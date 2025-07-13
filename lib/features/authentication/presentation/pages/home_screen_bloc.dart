import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemenshop/core/theme/design_system.dart';
import 'package:yemenshop/features/authentication/data/models/favorites.dart';
import 'package:yemenshop/features/authentication/data/models/cart_item.dart';
import 'package:yemenshop/features/authentication/presentation/bloc/blocs.dart';

class YemenShopHomeScreenBloc extends StatefulWidget {
  const YemenShopHomeScreenBloc({Key? key}) : super(key: key);

  @override
  State<YemenShopHomeScreenBloc> createState() =>
      _YemenShopHomeScreenBlocState();
}

class _YemenShopHomeScreenBlocState extends State<YemenShopHomeScreenBloc> {
  final PageController _promoController = PageController();
  int _currentPromoPage = 0;

  final ScrollController _scrollController = ScrollController();
  bool _showTopShadow = false;

  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);

    // Load products using BLoC
    context.read<ProductBloc>().add(LoadProducts());

    Timer.periodic(const Duration(seconds: 4), (_) {
      setState(() {
        _currentPromoPage = (_currentPromoPage + 1) % 3;
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

  void _toggleFavorite(FavoriteItem item) {
    context.read<ProductBloc>().add(ToggleFavorite(product: item));
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
    context.read<CartBloc>().add(AddToCart(item: newItem));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Simple App Bar
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/Logo.png",
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search),
                          const SizedBox(width: 8),
                          Text('ابحث'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  BlocBuilder<CartBloc, CartState>(
                    builder: (context, cartState) {
                      int cartItemCount = 0;
                      if (cartState is CartLoaded) {
                        cartItemCount = cartState.items.length;
                      }
                      return Badge(
                        label: Text(cartItemCount.toString()),
                        child: Icon(Icons.shopping_cart),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Main Content
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

                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          // Navigation logic can be added here
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'الإعدادات'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'المفضلة'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'السلة'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'الحساب'),
        ],
      ),
    );
  }

  Widget _buildContent(
      List<FavoriteItem> products, List<FavoriteItem> favorites) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Simple Promo Section
        SliverToBoxAdapter(
          child: Container(
            height: 200,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                'عروض خاصة',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),

        // Products Grid
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = products[index];
                final isFavorite = favorites.contains(product);

                return _buildProductCard(product, isFavorite);
              },
              childCount: products.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(FavoriteItem product, bool isFavorite) {
    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.asset(
                product.imagePath,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  product.price,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : null,
                      ),
                      onPressed: () => _toggleFavorite(product),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      onPressed: () => _addToCart(product),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

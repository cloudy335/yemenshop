import 'package:flutter/material.dart';
import 'package:yemenshop/core/theme/app_button.dart';
import 'package:yemenshop/core/theme/design_system.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedColorIndex = 0;
  String? _selectedSize;
  int _quantity = 1;
  final PageController _imageController = PageController();
  int _currentImageIndex = 0;

  // Mock product data - replace with API data
  final Map<String, dynamic> _product = {
    'title': 'Premium Leather Jacket',
    'price': 299.99,
    'discount': 30,
    'images': [
      'https://example.com/jacket1.jpg',
      'https://example.com/jacket2.jpg',
    ],
    'colors': ['#D3A270', '#000000', '#FFFFFF'],
    'sizes': ['S', 'M', 'L', 'XL'],
    'description': 'High-quality genuine leather jacket with...',
    'sku': 'JKT-2024-LUX',
    'brand': 'Luxury Apparel',
    'stock': 10,
    'rating': 4.5,
    'reviews': [
      {
        'user': 'John D.',
        'rating': 5,
        'comment': 'Excellent quality, perfect fit!',
        'date': '2024-03-15'
      },
      // More reviews...
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_product['title'], style: AppTextStyles.h2),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageGallery(),
            _buildProductInfo(),
            _buildVariantSelectors(),
            _buildReviewsSection(),
            _buildRelatedProducts(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildImageGallery() {
    return SizedBox(
      height: 360,
      child: Stack(
        children: [
          Positioned(
            bottom: AppSpacing.md,
            right: AppSpacing.md,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.background.withOpacity(0.8),
                borderRadius: BorderRadius.circular(AppRadius.small),
              ),
              child: Text(
                  '${_currentImageIndex + 1}/${_product['images'].length}'),
            ),
          ),
          if (_product['discount'] > 0)
            Positioned(
              top: AppSpacing.md,
              left: AppSpacing.md,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(AppRadius.small),
                ),
                child: Text(
                  '${_product['discount']}% OFF',
                  style: const TextStyle(color: AppColors.textOnPrimary),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductInfo() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_product['title'], style: AppTextStyles.h1),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Text(
                '\$${(_product['price'] * (1 - _product['discount'] / 100)).toStringAsFixed(2)}',
                style: AppTextStyles.h2.copyWith(color: AppColors.error),
              ),
              if (_product['discount'] > 0)
                Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.sm),
                  child: Text(
                    '\$${_product['price']}',
                    style: AppTextStyles.body2.copyWith(
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(_product['description'], style: AppTextStyles.body1),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text('SKU: ${_product['sku']}', style: AppTextStyles.caption),
              const Text('•', style: AppTextStyles.caption),
              Text('Brand: ${_product['brand']}', style: AppTextStyles.caption),
              const Text('•', style: AppTextStyles.caption),
              Text(
                _product['stock'] > 0 ? 'In Stock' : 'Out of Stock',
                style: AppTextStyles.caption.copyWith(
                  color: _product['stock'] > 0
                      ? AppColors.success
                      : AppColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVariantSelectors() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Color Options', style: AppTextStyles.h2),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            children: List.generate(_product['colors'].length, (index) {
              return GestureDetector(
                onTap: () => setState(() => _selectedColorIndex = index),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(int.parse(
                            _product['colors'][index].substring(1, 7),
                            radix: 16) +
                        0xFF000000),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _selectedColorIndex == index
                          ? AppColors.primary
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text('Select Size', style: AppTextStyles.h2),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            children: _product['sizes'].map<Widget>((size) {
              final isAvailable = true; // Replace with actual stock check
              return OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: _selectedSize == size
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                  backgroundColor: _selectedSize == size
                      ? AppColors.primary.withOpacity(0.1)
                      : Colors.transparent,
                ),
                onPressed: isAvailable
                    ? () => setState(() => _selectedSize = size)
                    : null,
                child: Text(
                  size,
                  style: TextStyle(
                    color: _selectedSize == size
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Customer Reviews', style: AppTextStyles.h2),
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => _navigateToReviewForm(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...List<Widget>.from(_product['reviews']
              .map<Widget>((review) => _buildReviewCard(review))),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.normal),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(review['user'], style: AppTextStyles.body1),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(review['comment'], style: AppTextStyles.body2),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.thumb_up_alt_outlined, size: 16),
                  label: const Text('Helpful'),
                  onPressed: () {},
                ),
                const Spacer(),
                Text(
                  review['date'],
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelatedProducts() {
    // Implement related products carousel
    return Container(); // Replace with horizontal ListView
  }

  Widget _buildBottomBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: AppElevation.medium,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: AppButton(
                label: 'Add to Cart',
                onPressed: () => _addToCart(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () => _saveToWishlist(),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart() {
    // Implement add to cart logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added ${_product['title']} to cart')),
    );
  }

  void _saveToWishlist() {
    // Implement wishlist logic
  }

  void _navigateToReviewForm() {
    // Navigate to review submission screen
  }
}

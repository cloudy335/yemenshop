import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المتجر اليمني'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearch(context),
          ),
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [_AdsCarousel(), _CategoriesSection(), _PopularProducts()],
        ),
      ),
    );
  }

  void _showSearch(BuildContext context) {
    showSearch(context: context, delegate: _YemenShopSearchDelegate());
  }
}

class _AdsCarousel extends StatelessWidget {
  const _AdsCarousel();

  @override
  Widget build(BuildContext context) {
    final ads = [
      'assets/images/ad1.jpg',
      'assets/images/ad2.jpg',
      'assets/images/ad3.jpg',
    ];

    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.95,
        enlargeCenterPage: true,
      ),
      items: ads.map((image) => _CarouselImageItem(image)).toList(),
    );
  }
}

class _CarouselImageItem extends StatelessWidget {
  final String imagePath;

  const _CarouselImageItem(this.imagePath);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
    );
  }
}

class _CategoriesSection extends StatelessWidget {
  const _CategoriesSection();

  @override
  Widget build(BuildContext context) {
    const categories = [
      {'icon': Icons.coffee, 'name': 'القهوة'},
      {'icon': Icons.brush, 'name': 'الحرف اليدوية'},
      {'icon': Icons.kitchen, 'name': 'الأواني'},
      {'icon': Icons.spa, 'name': 'العسل'},
      {'icon': Icons.local_drink, 'name': 'المشروبات'},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('الأقسام'),
          const SizedBox(height: 10),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 15),
              itemBuilder: (_, i) => _CategoryItem(categories[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final Map<String, dynamic> category;

  const _CategoryItem(this.category);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleCategoryTap(context),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              category['icon'] as IconData,
              size: 35,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            category['name'] as String,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _handleCategoryTap(BuildContext context) {
    // TODO: Implement category navigation
  }
}

class _PopularProducts extends StatelessWidget {
  const _PopularProducts();

  @override
  Widget build(BuildContext context) {
    final products = [
      {
        'image': 'assets/images/coffee1.jpg',
        'name': 'قهوة يمنية ممتازة',
        'price': 25.0,
        'sales': 1200,
      },
      {
        'image': 'assets/images/honey.jpg',
        'name': 'عسل سدر أصلي',
        'price': 80.0,
        'sales': 950,
      },
      {
        'image': 'assets/images/pottery.jpg',
        'name': 'جرة فخارية',
        'price': 150.0,
        'sales': 670,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('الأكثر شراء'),
          const SizedBox(height: 10),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(height: 15),
            itemBuilder: (_, i) => _ProductItem(products[i]),
          ),
        ],
      ),
    );
  }
}

class _ProductItem extends StatelessWidget {
  final Map<String, dynamic> product;

  const _ProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              product['image'] as String,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'] as String,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 5),
                Text(
                  '${product['price']} ريال',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${product['sales']}+ عملية بيع',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_shopping_cart),
            color: Colors.white,
            onPressed: () => _addToCart(context),
          ),
        ],
      ),
    );
  }

  void _addToCart(BuildContext context) {
    // TODO: Implement add to cart
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _YemenShopSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(
        'نتائج البحث عن: $query',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text(
        'اقتراحات البحث عن: $query',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

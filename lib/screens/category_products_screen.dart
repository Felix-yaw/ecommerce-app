import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../models/product.dart';
import '../models/product_category.dart';
import '../navigation/app_routes.dart';
import '../state/shop_scope.dart';
import '../state/shop_state.dart';
import '../theme/app_colors.dart';
import '../widgets/product_card.dart';

/// "See all" screen listing every product within a category, with sorting.
class CategoryProductsScreen extends StatefulWidget {
  const CategoryProductsScreen({super.key, required this.categoryId});

  final String categoryId;

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  String _sort = 'popular';

  static const Map<String, String> _sortLabels = <String, String>{
    'popular': 'Most popular',
    'priceLow': 'Price: low to high',
    'priceHigh': 'Price: high to low',
    'rating': 'Top rated',
  };

  String get _title {
    for (final ProductCategory c in SampleData.categories) {
      if (c.id == widget.categoryId) return c.name;
    }
    return 'Products';
  }

  List<Product> get _products {
    final ShopState shop = ShopScope.read(context);
    final List<Product> items = shop.catalogue
        .where(
          (Product p) =>
              widget.categoryId == 'all' || p.categoryId == widget.categoryId,
        )
        .toList();

    switch (_sort) {
      case 'priceLow':
        items.sort((Product a, Product b) => a.price.compareTo(b.price));
      case 'priceHigh':
        items.sort((Product a, Product b) => b.price.compareTo(a.price));
      case 'rating':
        items.sort((Product a, Product b) => b.rating.compareTo(a.rating));
      default:
        items.sort(
          (Product a, Product b) => b.reviewCount.compareTo(a.reviewCount),
        );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final List<Product> products = _products;

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: <Widget>[
          PopupMenuButton<String>(
            initialValue: _sort,
            tooltip: 'Sort',
            icon: const Icon(Icons.sort_rounded),
            onSelected: (String value) => setState(() => _sort = value),
            itemBuilder: (BuildContext context) => _sortLabels.entries
                .map(
                  (MapEntry<String, String> e) => PopupMenuItem<String>(
                    value: e.key,
                    child: Text(e.value),
                  ),
                )
                .toList(),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Row(
              children: <Widget>[
                Text(
                  '${products.length} products',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                Text(
                  _sortLabels[_sort]!,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.60,
              ),
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                final Product product = products[index];
                return ProductCard(
                  product: product,
                  onTap: () => AppRoutes.openProduct(context, product),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

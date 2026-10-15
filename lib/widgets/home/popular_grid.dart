import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../navigation/app_routes.dart';
import '../../state/shop_state.dart';
import '../product_card.dart';
import '../reveal.dart';

/// Lazily-built grid of products for the selected category.
///
/// Subscribes only to the (cached, stable) filtered product list, so cart and
/// wishlist changes never rebuild it.
class PopularGrid extends StatelessWidget {
  const PopularGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Product> products = context.select<ShopState, List<Product>>(
      (ShopState s) => s.filteredProducts,
    );

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.60,
        ),
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          final Product product = products[index];
          return Reveal(
            key: ValueKey<String>(product.id),
            delay: Duration(milliseconds: 40 * (index % 6)),
            child: ProductCard(
              product: product,
              onTap: () => AppRoutes.openProduct(context, product),
            ),
          );
        },
      ),
    );
  }
}

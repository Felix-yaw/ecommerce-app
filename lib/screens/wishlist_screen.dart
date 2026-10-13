import 'package:flutter/material.dart';

import '../models/product.dart';
import '../navigation/app_routes.dart';
import '../state/shop_scope.dart';
import '../state/shop_state.dart';
import '../theme/app_colors.dart';
import '../widgets/empty_state.dart';
import '../widgets/product_card.dart';

/// Saved products tab.
class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key, this.onBrowse});

  final VoidCallback? onBrowse;

  @override
  Widget build(BuildContext context) {
    final ShopState shop = ShopScope.of(context);
    final List<Product> products = shop.wishlistProducts;

    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist${products.isEmpty ? '' : ' (${products.length})'}'),
      ),
      body: products.isEmpty
          ? EmptyState(
              icon: Icons.favorite_border_rounded,
              title: 'No favourites yet',
              message:
                  'Tap the heart on any product to save it here for later.',
              actionLabel: 'Discover products',
              onAction: onBrowse,
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              itemCount: products.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (BuildContext context, int index) {
                final Product product = products[index];
                return ProductListCard(
                  product: product,
                  onTap: () => AppRoutes.openProduct(context, product),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        tooltip: 'Remove',
                        onPressed: () => shop.toggleWishlist(product),
                        icon: const Icon(
                          Icons.favorite_rounded,
                          color: AppColors.accent,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Add to cart',
                        onPressed: () => _addToCart(context, shop, product),
                        icon: const Icon(
                          Icons.add_shopping_cart_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  void _addToCart(BuildContext context, ShopState shop, Product product) {
    shop.addToCart(product);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('${product.name} added to cart')),
      );
  }
}

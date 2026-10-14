import 'package:flutter/material.dart';

import '../models/product.dart';
import '../navigation/app_routes.dart';
import '../state/shop_scope.dart';
import '../state/shop_state.dart';
import '../theme/app_colors.dart';
import '../widgets/empty_state.dart';
import '../widgets/product_card.dart';
import '../widgets/reveal.dart';

/// Saved products tab with elegant list cards.
class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key, this.onBrowse});

  final VoidCallback? onBrowse;

  @override
  Widget build(BuildContext context) {
    final ShopState shop = ShopScope.of(context);
    final List<Product> products = shop.wishlistProducts;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Saved${products.isEmpty ? '' : ' (${products.length})'}',
        ),
      ),
      body: products.isEmpty
          ? EmptyState(
              icon: Icons.favorite_border_rounded,
              title: 'Nothing saved yet',
              message:
                  'Tap the heart on any product to keep it here for later.',
              actionLabel: 'Discover products',
              onAction: onBrowse,
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
              itemCount: products.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (BuildContext context, int index) {
                final Product product = products[index];
                return Reveal(
                  delay: Duration(milliseconds: 45 * index),
                  child: ProductListCard(
                    product: product,
                    onTap: () => AppRoutes.openProduct(context, product),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _CircleIconButton(
                          icon: Icons.favorite_rounded,
                          color: AppColors.accent,
                          background: AppColors.accentLight,
                          tooltip: 'Remove',
                          onTap: () => shop.toggleWishlist(product),
                        ),
                        const SizedBox(height: 8),
                        _CircleIconButton(
                          icon: Icons.add_shopping_cart_rounded,
                          color: Colors.white,
                          background: AppColors.primary,
                          tooltip: 'Add to bag',
                          onTap: () => _addToCart(context, shop, product),
                        ),
                      ],
                    ),
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
        SnackBar(content: Text('${product.name} added to bag')),
      );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.color,
    required this.background,
    required this.onTap,
    this.tooltip,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: background,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 42,
            height: 42,
            child: Icon(icon, size: 19, color: color),
          ),
        ),
      ),
    );
  }
}

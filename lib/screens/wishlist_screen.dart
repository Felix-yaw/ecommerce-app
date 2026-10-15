import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../navigation/app_routes.dart';
import '../state/shop_state.dart';
import '../theme/app_colors.dart';
import '../widgets/circle_icon_button.dart';
import '../widgets/empty_state.dart';
import '../widgets/product_list_card.dart';
import '../widgets/reveal.dart';

/// Saved products tab with elegant list cards.
///
/// Subscribes only to the wishlist slice so cart changes do not rebuild it.
class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key, this.onBrowse});

  final VoidCallback? onBrowse;

  @override
  Widget build(BuildContext context) {
    final List<Product> products = context.select<ShopState, List<Product>>(
      (ShopState s) => s.wishlistProducts,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Saved${products.isEmpty ? '' : ' (${products.length})'}'),
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
                  key: ValueKey<String>(product.id),
                  delay: Duration(milliseconds: 45 * index),
                  child: ProductListCard(
                    product: product,
                    onTap: () => AppRoutes.openProduct(context, product),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleIconButton(
                          icon: Icons.favorite_rounded,
                          color: AppColors.accent,
                          background: AppColors.accentLight,
                          tooltip: 'Remove',
                          onTap: () => context
                              .read<ShopState>()
                              .toggleWishlist(product),
                        ),
                        const SizedBox(height: 8),
                        CircleIconButton(
                          icon: Icons.add_shopping_cart_rounded,
                          color: Colors.white,
                          background: AppColors.primary,
                          tooltip: 'Add to bag',
                          onTap: () => _addToCart(context, product),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _addToCart(BuildContext context, Product product) {
    context.read<ShopState>().addToCart(product);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('${product.name} added to bag')),
      );
  }
}

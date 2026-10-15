import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/shop_state.dart';
import '../theme/app_colors.dart';
import '../widgets/cart/cart_body.dart';
import '../widgets/empty_state.dart';

/// Shopping bag. Renders as a pushed route or an embedded tab.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key, this.embedded = false, this.onBrowse});

  final bool embedded;
  final VoidCallback? onBrowse;

  @override
  Widget build(BuildContext context) {
    final ShopState shop = context.watch<ShopState>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !embedded,
        title: const Text('My Bag'),
        actions: <Widget>[
          if (!shop.isCartEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: TextButton(
                onPressed: () => _confirmClear(context, shop),
                style: TextButton.styleFrom(foregroundColor: AppColors.accent),
                child: const Text('Clear all'),
              ),
            ),
        ],
      ),
      body: shop.isCartEmpty
          ? EmptyState(
              icon: Icons.shopping_bag_outlined,
              title: 'Your bag is empty',
              message:
                  'Looks like you have not added anything yet. Let us fix that!',
              actionLabel: 'Browse products',
              onAction: () {
                if (onBrowse != null) {
                  onBrowse!();
                } else if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
            )
          : CartBody(shop: shop),
    );
  }

  Future<void> _confirmClear(BuildContext context, ShopState shop) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: const Text('Clear bag?'),
        content: const Text(
          'This will remove every item from your bag. This cannot be undone.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accent,
              minimumSize: const Size(0, 46),
              padding: const EdgeInsets.symmetric(horizontal: 22),
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (confirmed ?? false) shop.clearCart();
  }
}

import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../navigation/app_routes.dart';
import '../state/shop_scope.dart';
import '../state/shop_state.dart';
import '../theme/app_colors.dart';
import '../widgets/cart_line_tile.dart';
import '../widgets/empty_state.dart';

/// Shopping cart. Renders as a pushed route or an embedded tab
/// ([embedded] = true hides the back button).
class CartScreen extends StatelessWidget {
  const CartScreen({super.key, this.embedded = false, this.onBrowse});

  final bool embedded;
  final VoidCallback? onBrowse;

  @override
  Widget build(BuildContext context) {
    final ShopState shop = ShopScope.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !embedded,
        title: Text('My Cart${shop.isCartEmpty ? '' : ' (${shop.cartCount})'}'),
        actions: <Widget>[
          if (!shop.isCartEmpty)
            TextButton(
              onPressed: () => _confirmClear(context, shop),
              style: TextButton.styleFrom(foregroundColor: AppColors.accent),
              child: const Text('Clear'),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: shop.isCartEmpty
          ? EmptyState(
              icon: Icons.shopping_bag_outlined,
              title: 'Your cart is empty',
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
          : _CartBody(shop: shop),
    );
  }

  Future<void> _confirmClear(BuildContext context, ShopState shop) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('Clear cart?'),
        content: const Text(
          'This will remove every item from your cart. This cannot be undone.',
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
              minimumSize: const Size(0, 44),
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (confirmed ?? false) shop.clearCart();
  }
}

class _CartBody extends StatelessWidget {
  const _CartBody({required this.shop});

  final ShopState shop;

  @override
  Widget build(BuildContext context) {
    final List<CartItem> items = shop.cartItems;

    return Column(
      children: <Widget>[
        if (!shop.qualifiesForFreeShipping)
          _FreeShippingProgress(shop: shop)
        else
          const _FreeShippingBanner(),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (BuildContext context, int index) {
              final CartItem item = items[index];
              return CartLineTile(
                item: item,
                onIncrement: () => shop.increment(item),
                onDecrement: () => shop.decrement(item),
                onRemove: () => shop.removeFromCart(item),
                onTap: () => AppRoutes.openProduct(context, item.product),
              );
            },
          ),
        ),
        _CartSummary(shop: shop),
      ],
    );
  }
}

class _FreeShippingProgress extends StatelessWidget {
  const _FreeShippingProgress({required this.shop});

  final ShopState shop;

  @override
  Widget build(BuildContext context) {
    final double progress =
        (shop.subtotal / shop.freeShippingThreshold).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Add \$${shop.amountToFreeShipping.toStringAsFixed(2)} more for free shipping',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.surface,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _FreeShippingBanner extends StatelessWidget {
  const _FreeShippingBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F9EE),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: <Widget>[
          Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
          SizedBox(width: 10),
          Text(
            'You have unlocked free shipping!',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  const _CartSummary({required this.shop});

  final ShopState shop;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Column(
            children: <Widget>[
              _SummaryRow(label: 'Subtotal', value: shop.subtotal),
              const SizedBox(height: 8),
              _SummaryRow(
                label: 'Shipping',
                value: shop.shipping,
                freeWhenZero: true,
              ),
              const SizedBox(height: 8),
              _SummaryRow(label: 'Tax (8%)', value: shop.tax),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1),
              ),
              Row(
                children: <Widget>[
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '\$${shop.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => AppRoutes.openCheckout(context),
                child: const Text('Proceed to Checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.freeWhenZero = false,
  });

  final String label;
  final double value;
  final bool freeWhenZero;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        const Spacer(),
        Text(
          freeWhenZero && value == 0
              ? 'Free'
              : '\$${value.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: freeWhenZero && value == 0
                ? AppColors.success
                : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

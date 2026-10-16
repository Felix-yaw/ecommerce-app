import 'package:flutter/material.dart';

import '../../models/cart_item.dart';
import '../../navigation/app_routes.dart';
import '../../state/shop_state.dart';
import '../cart_line_tile.dart';
import '../reveal.dart';
import 'cart_summary.dart';
import 'free_shipping_banner.dart';
import 'free_shipping_progress.dart';

/// The filled-cart layout: shipping hint, item list and summary.
class CartBody extends StatelessWidget {
  const CartBody({super.key, required this.shop});

  final ShopState shop;

  @override
  Widget build(BuildContext context) {
    final List<CartItem> items = shop.cartItems;

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
          child: shop.qualifiesForFreeShipping
              ? const FreeShippingBanner()
              : FreeShippingProgress(
                  remaining: shop.amountToFreeShipping,
                  progress: (shop.subtotal / shop.freeShippingThreshold).clamp(
                    0.0,
                    1.0,
                  ),
                ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 14),
            itemBuilder: (BuildContext context, int index) {
              final CartItem item = items[index];
              return Reveal(
                key: ValueKey<String>(item.variantKey),
                delay: Duration(milliseconds: 45 * index),
                child: CartLineTile(
                  item: item,
                  onIncrement: () => shop.increment(item),
                  onDecrement: () => shop.decrement(item),
                  onRemove: () => shop.removeFromCart(item),
                  onTap: () => AppRoutes.openProduct(context, item.product),
                ),
              );
            },
          ),
        ),
        CartSummary(
          subtotal: shop.subtotal,
          shipping: shop.shipping,
          tax: shop.tax,
          total: shop.total,
          onCheckout: () => AppRoutes.openCheckout(context),
        ),
      ],
    );
  }
}

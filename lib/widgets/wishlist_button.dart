import 'package:flutter/material.dart';

import '../models/product.dart';
import '../state/shop_scope.dart';
import '../state/shop_state.dart';
import '../theme/app_colors.dart';

/// Circular heart toggle that reads/writes the wishlist in [ShopState].
class WishlistButton extends StatelessWidget {
  const WishlistButton({
    super.key,
    required this.product,
    this.size = 36,
    this.iconSize = 18,
    this.background = Colors.white,
  });

  final Product product;
  final double size;
  final double iconSize;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final ShopState shop = ShopScope.of(context);
    final bool active = shop.isWishlisted(product);

    return Material(
      color: background,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          shop.toggleWishlist(product);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 1),
                content: Text(
                  active
                      ? '${product.name} removed from wishlist'
                      : '${product.name} added to wishlist',
                ),
              ),
            );
        },
        child: SizedBox(
          width: size,
          height: size,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            transitionBuilder: (Widget child, Animation<double> animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Icon(
              active ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              key: ValueKey<bool>(active),
              size: iconSize,
              color: active ? AppColors.accent : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

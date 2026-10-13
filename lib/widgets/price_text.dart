import 'package:flutter/material.dart';

import '../models/product.dart';
import '../theme/app_colors.dart';

/// Price row showing the current price plus a struck-through original price
/// and discount badge when the product is on sale.
class PriceText extends StatelessWidget {
  const PriceText({
    super.key,
    required this.product,
    this.priceSize = 16,
    this.showDiscountBadge = false,
  });

  final Product product;
  final double priceSize;
  final bool showDiscountBadge;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: <Widget>[
        Text(
          product.displayPrice,
          style: TextStyle(
            fontSize: priceSize,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        if (product.hasDiscount) ...<Widget>[
          const SizedBox(width: 6),
          Text(
            product.displayOldPrice,
            style: TextStyle(
              fontSize: priceSize - 3,
              color: AppColors.textSecondary,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
        if (showDiscountBadge && product.hasDiscount) ...<Widget>[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.accentLight,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '-${product.discountPercent}%',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.accent,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

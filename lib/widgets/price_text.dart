import 'package:flutter/material.dart';

import '../models/product.dart';
import '../theme/app_colors.dart';

/// Price row with editorial typography and an optional sale treatment.
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
            fontWeight: FontWeight.w900,
            letterSpacing: -0.6,
            color: AppColors.textPrimary,
          ),
        ),
        if (product.hasDiscount) ...<Widget>[
          const SizedBox(width: 7),
          Text(
            product.displayOldPrice,
            style: TextStyle(
              fontSize: priceSize - 4,
              fontWeight: FontWeight.w500,
              color: AppColors.textTertiary,
              decoration: TextDecoration.lineThrough,
              decorationColor: AppColors.textTertiary,
            ),
          ),
        ],
        if (showDiscountBadge && product.hasDiscount) ...<Widget>[
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.accentLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Save ${product.discountPercent}%',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: AppColors.accent,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

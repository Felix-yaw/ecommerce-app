import 'package:flutter/material.dart';

import '../../models/product.dart';
import '../../theme/app_colors.dart';
import '../group_heading.dart';
import '../price_text.dart';
import '../quantity_stepper.dart';
import '../rating_stars.dart';
import 'color_selector.dart';
import 'size_selector.dart';

/// The scrollable information block of the product detail screen:
/// brand, name, rating, price, description and variant pickers.
class ProductDetails extends StatelessWidget {
  const ProductDetails({
    super.key,
    required this.product,
    required this.quantity,
    required this.selectedColor,
    required this.selectedSize,
    required this.onQuantityChanged,
    required this.onColorSelected,
    required this.onSizeSelected,
  });

  final Product product;
  final int quantity;
  final Color? selectedColor;
  final String? selectedSize;
  final ValueChanged<int> onQuantityChanged;
  final ValueChanged<Color> onColorSelected;
  final ValueChanged<String> onSizeSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                product.brand.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (product.isFeatured)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'TRENDING',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.w800,
                    color: AppColors.accent,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          product.name,
          style: const TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w900,
            height: 1.18,
            letterSpacing: -0.8,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            RatingStars(
              rating: product.rating,
              reviewCount: product.reviewCount,
              pill: true,
            ),
            const Spacer(),
            if (product.freeShipping)
              const Row(
                children: <Widget>[
                  Icon(
                    Icons.local_shipping_outlined,
                    size: 16,
                    color: AppColors.success,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Free shipping',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: 18),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: PriceText(
            product: product,
            priceSize: 28,
            showDiscountBadge: true,
          ),
        ),
        const SizedBox(height: 24),
        const GroupHeading('Description'),
        const SizedBox(height: 10),
        Text(
          product.description,
          style: const TextStyle(
            fontSize: 14.5,
            height: 1.6,
            color: AppColors.textSecondary,
          ),
        ),
        if (product.colors.isNotEmpty) ...<Widget>[
          const SizedBox(height: 26),
          const GroupHeading('Colour'),
          const SizedBox(height: 14),
          ColorSelector(
            colors: product.colors,
            selected: selectedColor,
            onSelected: onColorSelected,
          ),
        ],
        if (product.sizes.isNotEmpty) ...<Widget>[
          const SizedBox(height: 26),
          const GroupHeading('Size'),
          const SizedBox(height: 14),
          SizeSelector(
            sizes: product.sizes,
            selected: selectedSize,
            onSelected: onSizeSelected,
          ),
        ],
        const SizedBox(height: 26),
        Row(
          children: <Widget>[
            const GroupHeading('Quantity'),
            const Spacer(),
            QuantityStepper(
              quantity: quantity,
              onIncrement: () => onQuantityChanged(quantity + 1),
              onDecrement: () =>
                  onQuantityChanged(quantity > 1 ? quantity - 1 : 1),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../state/shop_state.dart';
import '../../theme/app_colors.dart';
import '../network_product_image.dart';
import '../price_text.dart';
import '../rating_stars.dart';
import '../wishlist_button.dart';
import 'quick_add_button.dart';
import 'tag_badge.dart';

/// Ultra-modern vertical product card for the home, search and category grids.
///
/// Features an isolated image stage, a floating discount flag, a spring
/// wishlist heart and a tactile quick-add cart button.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  final Product product;
  final VoidCallback onTap;

  void _quickAdd(BuildContext context) {
    context.read<ShopState>().addToCart(product);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 1400),
          content: Row(
            children: <Widget>[
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(child: Text('Added ${product.name} to bag')),
            ],
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: AppColors.softShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSecondary,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: NetworkProductImage(
                        url: product.imageUrl,
                        cacheWidth: 420,
                        cacheHeight: 420,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (product.hasDiscount)
                      Positioned(
                        top: 16,
                        left: 16,
                        child: TagBadge(
                          text: '-${product.discountPercent}%',
                          backgroundColor: AppColors.accent,
                          textColor: Colors.white,
                        ),
                      )
                    else if (product.isFeatured)
                      const Positioned(
                        top: 16,
                        left: 16,
                        child: TagBadge(
                          text: 'HOT',
                          backgroundColor: AppColors.primary,
                          textColor: Colors.white,
                        ),
                      ),
                    Positioned(
                      top: 14,
                      right: 14,
                      child: WishlistButton(
                        product: product,
                        size: 34,
                        iconSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            product.brand.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 10,
                              letterSpacing: 0.8,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: RatingStars(
                            rating: product.rating,
                            showValue: true,
                            starSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                        letterSpacing: -0.2,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: PriceText(product: product, priceSize: 17),
                          ),
                        ),
                        QuickAddButton(onTap: () => _quickAdd(context)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

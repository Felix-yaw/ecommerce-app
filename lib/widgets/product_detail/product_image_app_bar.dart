import 'package:flutter/material.dart';

import '../../models/product.dart';
import '../../theme/app_colors.dart';
import '../circle_icon_button.dart';
import '../network_product_image.dart';
import '../wishlist_button.dart';

/// Collapsing image header for the product detail screen.
class ProductImageAppBar extends StatelessWidget {
  const ProductImageAppBar({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 420,
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.all(10),
        child: CircleIconButton(
          icon: Icons.arrow_back_rounded,
          size: 44,
          iconSize: 22,
          background: Colors.white,
          elevated: true,
          onTap: () => Navigator.of(context).pop(),
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: SizedBox(
            width: 44,
            height: 44,
            child: Center(
              child: WishlistButton(
                product: product,
                size: 44,
                iconSize: 22,
                background: Colors.white,
              ),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: ColoredBox(
          color: AppColors.surfaceSecondary,
          child: NetworkProductImage(
            url: product.imageUrl,
            width: MediaQuery.sizeOf(context).width,
            height: 420,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

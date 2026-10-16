import 'package:flutter/material.dart';

import '../../data/sample_data.dart';
import '../../models/product.dart';
import '../../navigation/app_routes.dart';
import '../product_card/product_card.dart';
import '../reveal.dart';

/// Horizontally scrolling rail of featured products.
class FeaturedRail extends StatelessWidget {
  const FeaturedRail({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Product> featured = SampleData.featured;
    return SizedBox(
      height: 290,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: featured.length,
        itemBuilder: (BuildContext context, int index) {
          final Product product = featured[index];
          return Padding(
            padding: const EdgeInsets.only(right: 14),
            child: SizedBox(
              width: 190,
              child: Reveal(
                key: ValueKey<String>(product.id),
                delay: Duration(milliseconds: 60 * index),
                child: ProductCard(
                  product: product,
                  onTap: () => AppRoutes.openProduct(context, product),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

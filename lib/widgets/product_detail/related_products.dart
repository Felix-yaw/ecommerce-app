import 'package:flutter/material.dart';

import '../../data/sample_data.dart';
import '../../models/product.dart';
import '../product_card.dart';
import '../reveal.dart';
import '../section_header.dart';

/// Horizontal rail of products from the same category.
class RelatedProducts extends StatelessWidget {
  const RelatedProducts({
    super.key,
    required this.product,
    required this.onSelect,
  });

  final Product product;
  final ValueChanged<Product> onSelect;

  @override
  Widget build(BuildContext context) {
    final List<Product> related = SampleData.products
        .where(
          (Product p) =>
              p.categoryId == product.categoryId && p.id != product.id,
        )
        .take(8)
        .toList(growable: false);

    if (related.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SectionHeader(
              title: 'You may also like',
              subtitle: 'Based on this product',
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 290,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: related.length,
              itemBuilder: (BuildContext context, int index) {
                final Product p = related[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: SizedBox(
                    width: 190,
                    child: Reveal(
                      key: ValueKey<String>(p.id),
                      delay: Duration(milliseconds: 50 * index),
                      child: ProductCard(
                        product: p,
                        onTap: () => onSelect(p),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../models/product.dart';
import '../../navigation/app_routes.dart';
import '../../theme/app_colors.dart';
import '../product_card/product_card.dart';
import '../reveal.dart';

/// Grid of search results with a result-count header.
class ResultsGrid extends StatelessWidget {
  const ResultsGrid({super.key, required this.results});

  final List<Product> results;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
          child: Text(
            '${results.length} result${results.length == 1 ? '' : 's'}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.60,
            ),
            itemCount: results.length,
            itemBuilder: (BuildContext context, int index) {
              final Product product = results[index];
              return Reveal(
                delay: Duration(milliseconds: 40 * (index % 6)),
                child: ProductCard(
                  product: product,
                  onTap: () => AppRoutes.openProduct(context, product),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

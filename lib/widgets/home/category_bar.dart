import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/sample_data.dart';
import '../../models/product_category.dart';
import '../../state/shop_state.dart';
import '../category_chip.dart';

/// Horizontal category filter row. Rebuilds only when the selection changes.
class CategoryBar extends StatelessWidget {
  const CategoryBar({super.key});

  @override
  Widget build(BuildContext context) {
    final String selectedId = context.select<ShopState, String>(
      (ShopState s) => s.selectedCategoryId,
    );

    return SizedBox(
      height: 46,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: SampleData.categories.length,
        itemBuilder: (BuildContext context, int index) {
          final ProductCategory category = SampleData.categories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CategoryChip(
              category: category,
              selected: selectedId == category.id,
              onTap: () =>
                  context.read<ShopState>().selectCategory(category.id),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../models/product.dart';
import '../navigation/app_routes.dart';
import '../state/shop_scope.dart';
import '../state/shop_state.dart';
import '../theme/app_colors.dart';
import '../widgets/empty_state.dart';
import '../widgets/product_card.dart';
import '../widgets/search_input.dart';

/// Full-screen product search.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';

  static const List<String> _suggestions = <String>[
    'Headphones',
    'Sneakers',
    'Hoodie',
    'Smart Watch',
    'Perfume',
    'Yoga Mat',
  ];

  @override
  Widget build(BuildContext context) {
    final ShopState shop = ShopScope.read(context);
    final List<Product> results =
        _query.trim().isEmpty ? const <Product>[] : shop.search(_query);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: SearchInput(
            autofocus: true,
            onChanged: (String value) => setState(() => _query = value),
          ),
        ),
      ),
      body: _query.trim().isEmpty
          ? _Suggestions(
              suggestions: _suggestions,
              onSelect: (String value) => setState(() => _query = value),
            )
          : results.isEmpty
          ? const EmptyState(
              icon: Icons.search_off_rounded,
              title: 'No results',
              message: 'We could not find anything matching your search.',
            )
          : GridView.builder(
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
                return ProductCard(
                  product: product,
                  onTap: () => AppRoutes.openProduct(context, product),
                );
              },
            ),
    );
  }
}

class _Suggestions extends StatelessWidget {
  const _Suggestions({required this.suggestions, required this.onSelect});

  final List<String> suggestions;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: <Widget>[
        const Text(
          'Popular searches',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: <Widget>[
            for (final String suggestion in suggestions)
              ActionChip(
                label: Text(suggestion),
                onPressed: () => onSelect(suggestion),
                backgroundColor: AppColors.surface,
                side: BorderSide.none,
                labelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

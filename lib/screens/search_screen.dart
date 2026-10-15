import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../navigation/app_routes.dart';
import '../state/shop_state.dart';
import '../theme/app_colors.dart';
import '../widgets/empty_state.dart';
import '../widgets/product_card.dart';
import '../widgets/reveal.dart';
import '../widgets/search/search_suggestions.dart';
import '../widgets/search_input.dart';

/// Full-screen product search with live results.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const List<String> _suggestions = <String>[
    'Headphones',
    'Sneakers',
    'Hoodie',
    'Smart Watch',
    'Perfume',
    'Yoga Mat',
  ];

  String _query = '';

  @override
  Widget build(BuildContext context) {
    final ShopState shop = context.read<ShopState>();
    final List<Product> results =
        _query.trim().isEmpty ? const <Product>[] : shop.search(_query);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: SearchInput(
            autofocus: true,
            onChanged: (String value) => setState(() => _query = value),
          ),
        ),
      ),
      body: _query.trim().isEmpty
          ? SearchSuggestions(
              suggestions: _suggestions,
              onSelect: (String value) => setState(() => _query = value),
            )
          : results.isEmpty
          ? const EmptyState(
              icon: Icons.search_off_rounded,
              title: 'No results',
              message: 'We could not find anything matching your search.',
            )
          : _ResultsGrid(results: results),
    );
  }
}

class _ResultsGrid extends StatelessWidget {
  const _ResultsGrid({required this.results});

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

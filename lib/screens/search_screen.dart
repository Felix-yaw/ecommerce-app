import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../state/shop_state.dart';
import '../widgets/empty_state.dart';
import '../widgets/search/results_grid.dart';
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
          : ResultsGrid(results: results),
    );
  }
}

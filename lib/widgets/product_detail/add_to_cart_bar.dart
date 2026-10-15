import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// Floating bottom action bar for the product detail screen.
///
/// [onAdd] is called with `goToCart: true` by "Buy now" and with no argument
/// by "Add to bag".
class AddToCartBar extends StatelessWidget {
  const AddToCartBar({
    super.key,
    required this.enabled,
    required this.onAdd,
  });

  final bool enabled;
  final void Function({bool goToCart}) onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: AppColors.floatingShadow,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton(
                  onPressed: enabled ? () => onAdd(goToCart: true) : null,
                  child: const Text('Buy now'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: FilledButton.icon(
                  onPressed: enabled ? () => onAdd() : null,
                  icon: const Icon(Icons.add_shopping_cart_rounded, size: 20),
                  label: const Text('Add to bag'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

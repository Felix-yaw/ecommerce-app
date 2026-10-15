import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A label/value line for cart and order totals.
///
/// When [freeWhenZero] is set and the value is `0`, it renders "Free" in the
/// success colour (used for shipping).
class SummaryRow extends StatelessWidget {
  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.freeWhenZero = false,
  });

  final String label;
  final double value;
  final bool freeWhenZero;

  @override
  Widget build(BuildContext context) {
    final bool isFree = freeWhenZero && value == 0;
    return Row(
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        const Spacer(),
        Text(
          isFree ? 'Free' : '\$${value.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isFree ? AppColors.success : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
